//
//  SuperMemo2.swift
//  remembering
//
//  Created by 배주웅 on 1/17/25.
//
import Foundation

struct SuperMemo2Result {
    let phase: LearningPhase
    let step: Int?
    let ease: Double?
    let interval: Int?
    let leech: Int
    
    init(_ phase: LearningPhase, step: Int? = nil, ease: Double? = nil, interval: Int? = nil, leech: Int = 0) {
        self.phase = phase
        self.step = step
        self.ease = ease
        self.interval = interval
        self.leech = leech
    }
}

// TODO: make this configurable and save to local
struct SuperMemo2Config {
    let hardIntervalMultiplier: Double = 1.2
    let minDays: Int = 1
    let maxDays: Int = 36500 // 100 year
    let learnIntervals: [Int] = [1, 10]
    let relearnIntervals: [Int] = [10]
    let defaultEase: Double
    let graduatingInterval: Int
    let easyInterval: Int
    let easyBonus: Double
    let intervalModifier: Double
}


class SuperMemo2 {
    let cfg: SuperMemo2Config
    
    init(cfg: SuperMemo2Config) {
        self.cfg = cfg
    }
    
    static func daysToMinutes(_ day: Int) -> Int {
        return day * Global.DAY_IN_MINUTES
    }
    
    static func humanizeMinutes(_ minutes: Int) -> String {
        var unit: Int = 1
        var unitName: String = "m"
        let prefix = minutes < Global.DAY_IN_MINUTES ? "<" : ""
        
        if minutes > 60 && minutes < 60 * 24 {
            unit = 60
            unitName = "h"
        } else if minutes < 60 * 24 * 7 {
            unit = 60 * 24
            unitName = "d"
        } else if minutes < 60 * 24 * 30 {
            unit = 60 * 24 * 7
            unitName = "w"
        } else if minutes < 60 * 24 * 365 {
            unit = 60 * 24 * 30
            unitName = "mo"
        } else {
            unit = 60 * 24 * 365
            unitName = "y"
        }
        
        let minuteByUnit = Double(minutes) / Double(unit)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0  // 최소 소수점 자리수
        formatter.maximumFractionDigits = 1  // 최대 소수점 자리수
        formatter.numberStyle = .decimal     // 일반 숫자 스타일
        
        let formatUnit = formatter.string(from: NSNumber(value: minuteByUnit)) ?? "\(minuteByUnit)"
        
        return "\(prefix)\(formatUnit)\(unitName)"
    }
    
    func createInitialCard(_ dataId: Int, _ phase: LearningPhase) -> LearningCard {
        return LearningCard(id: 0, dataId: dataId, phase: phase, interval: 0, ease: self.cfg.defaultEase)
    }
    
    private func handleLearnPhase(_ card: LearningCard, _ choice: LearningChoice) -> SuperMemo2Result {
        
        switch choice {
        case .AGAIN:
            return SuperMemo2Result(.LEARN, step: 0, interval: self.cfg.learnIntervals[0], leech: card.leech + 1)
        case .HARD:
            if card.step == 0 && self.cfg.learnIntervals.count == 1 {
                let nextInterval = Int(
                    Double(self.cfg.learnIntervals[0]) * 1.5
                )
                return SuperMemo2Result(.LEARN, step: 0, interval: nextInterval)
            } else if card.step == 0 && self.cfg.learnIntervals.count > 1 {
                let nextInterval = (self.cfg.learnIntervals[card.step] + self.cfg.learnIntervals[card.step+1]) / 2
                return SuperMemo2Result(.LEARN, step: 0, interval: nextInterval)
            }
            return SuperMemo2Result(.LEARN, step: 1)
        case .GOOD:
            if card.step + 1 == self.cfg.learnIntervals.count {
                return SuperMemo2Result(.EXPONENTIAL, step: nil, ease: cfg.defaultEase, interval: cfg.graduatingInterval)
            }
            return SuperMemo2Result(.LEARN, step: card.step + 1, interval: cfg.learnIntervals[card.step+1])
        case .EASY:
            return SuperMemo2Result(.EXPONENTIAL, step: 0, ease: cfg.defaultEase, interval: cfg.easyInterval)
        
        }
    }
    
    private func handleExponentialPhase(_ card: LearningCard, _ choice: LearningChoice) -> SuperMemo2Result {

        switch choice {
        case .AGAIN:
            let nextEase = max(1.3, card.ease * 0.8)
            
            if cfg.relearnIntervals.count > 0 {
                return SuperMemo2Result(.RELEARN, step: 0, ease: nextEase, interval: cfg.relearnIntervals[0])
            }
            
            var nextInterval = max(
                Int(Double(card.interval) * Global.LAPSE_INTERVAL_MULTIPLIER),
                SuperMemo2.daysToMinutes(cfg.minDays)
            )
            // TODO: appliy fuzzed intervals
            
            return SuperMemo2Result(.EXPONENTIAL, ease: nextEase, interval: nextInterval, leech: card.leech + 1)
        case .HARD:
            let nextEase = max(1.3, card.ease * 0.85)
            // TODO: apply day adjustments
            
            let nextInterval = min(
                Int(Double(card.interval) * cfg.hardIntervalMultiplier * cfg.intervalModifier),
                SuperMemo2.daysToMinutes(cfg.maxDays)
            )
            
            return SuperMemo2Result(.EXPONENTIAL, ease: nextEase, interval: nextInterval)
        case .GOOD:
            // TODO: apply day adjustment
            let nextInterval = min(
                Int(Double(card.interval) * card.ease * cfg.intervalModifier),
                SuperMemo2.daysToMinutes(cfg.maxDays)
            )
            // TODO: apply fuzzed interval function
            
            return SuperMemo2Result(.EXPONENTIAL, ease: card.ease, interval: nextInterval)
        case .EASY:
            let nextEase = card.ease * 1.15
            // TODO: apply day adjustment
            let nextInterval = min(
                Int(Double(card.interval) * card.ease * cfg.intervalModifier * cfg.easyBonus),
                SuperMemo2.daysToMinutes(cfg.maxDays)
            )
            
            return SuperMemo2Result(.EXPONENTIAL, ease: nextEase, interval: nextInterval)
        }
    }
    
    private func handleRelearnPhase(_ card: LearningCard, _ choice: LearningChoice) -> SuperMemo2Result {
        
        // Handle if user setting handle interval as empty or step is over after relearnInterval configurations.
        if cfg.relearnIntervals.count == 0 || card.step >= cfg.relearnIntervals.count {
            let nextInterval = Int(Double(card.interval) * card.ease)
            
            return SuperMemo2Result(.EXPONENTIAL, step: nil, ease: card.ease, interval: nextInterval)
        }
        
        switch choice {
        case .AGAIN:
            return SuperMemo2Result(.RELEARN, step: 0, interval: cfg.relearnIntervals[0], leech: card.leech + 1)
        case .HARD:
            if card.step == 0 && cfg.relearnIntervals.count == 1 {
                let nextInterval = Int(Double(cfg.relearnIntervals[0]) * 1.5)
                return SuperMemo2Result(.RELEARN, step: 0, interval: nextInterval)
            } else if card.step == 0 && cfg.relearnIntervals.count > 1{
                let nextInterval = (cfg.relearnIntervals[card.step] + cfg.relearnIntervals[card.step + 1]) / 2
                return SuperMemo2Result(.RELEARN, step: 0, interval: nextInterval)
            }
        case .GOOD:
            if card.step + 1 == cfg.relearnIntervals.count {
                let nextInterval = Int(Double(card.interval) * card.ease)
                return SuperMemo2Result(.EXPONENTIAL, step: nil, interval: nextInterval)
            }
            
            return SuperMemo2Result(.RELEARN, step: card.step + 1, interval:  cfg.relearnIntervals[card.step + 1])
        case .EASY:
            break
        }
        
        let nextInterval = min(
            Int(Double(card.interval) * card.ease * cfg.easyBonus),
            SuperMemo2.daysToMinutes(cfg.maxDays)
        )
        
        return SuperMemo2Result(.EXPONENTIAL, step: nil, ease: card.ease, interval: nextInterval)
    }
    
    
    func getCardNext(_ card: LearningCard, _ choice: LearningChoice) -> SuperMemo2Result {
        switch card.phase {
        case .NEW, .LEARN:
            return self.handleLearnPhase(card, choice)
        case .EXPONENTIAL:
            return self.handleExponentialPhase(card, choice)
        case .RELEARN:
            return self.handleRelearnPhase(card, choice)
        }
    }
    
    func getExpectIntervals(_ card: LearningCard) -> [String] {
        // TODO: Can I merge two lines at once? using much more simple Syntax Sugar?
        let availableChoices: [LearningChoice] = [.AGAIN, .HARD, .GOOD, .EASY]
        var results: [String] = []
        for choice in availableChoices {
            let result = self.getCardNext(card, choice)
            results.append(SuperMemo2.humanizeMinutes(result.interval!))
        }
        
        return results
    }
    
}
