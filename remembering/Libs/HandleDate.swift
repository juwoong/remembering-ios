//
//  HandleDate.swift
//  remembering
//
//  Created by 배주웅 on 1/20/25.
//
import Foundation


func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    return components.day ?? 0
}
