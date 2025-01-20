//
//  Consts.swift
//  remembering
//
//  Created by 배주웅 on 1/17/25.
//

struct FuzzRange {
    let start: Double
    let end: Double
    let factor: Double
}

struct Global {
    static let DAY_IN_MINUTES = 1440
    static let LAPSE_INTERVAL_MULTIPLIER: Double = 0.1
    static let FUZZ_RANGE: [FuzzRange] = [
        FuzzRange(start: 2.5, end: 7.0, factor: 0.15),
        FuzzRange(start: 7.0, end: 20.0, factor: 0.1),
        FuzzRange(start: 20.0, end: Double.infinity, factor: 0.05)
    ]
}
