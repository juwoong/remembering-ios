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

func addMinutes(_ date: Date, _ minutes: Int) -> Date {
    return Calendar.current.date(byAdding: .minute, value: minutes, to: date)!
}

func startOfDay(_ date: Date) -> Date {
    return Calendar.current.startOfDay(for: date)
}

func dateToSQLString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: date)
}

