//
//  SuperMemoConfig.swift
//  remembering
//
//  Created by 배주웅 on 1/26/25.
//

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


func getDefaultSuperMemo2Config() -> SuperMemo2Config {
    return SuperMemo2Config(
        defaultEase: 2.3,
        graduatingInterval: 1440,  // 1day
        easyInterval: 4 * 1440,
        easyBonus: 1.3,
        intervalModifier: 1.0
    )
}
