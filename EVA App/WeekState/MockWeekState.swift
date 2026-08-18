//
//  MockWeekState.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

final class MockWeekState: WeekStateProviding {
    var cycleStartDate: Date
    var currentWeekNumber: Int
    private var dailyRecords: [String: DailyPracticeRecord]

    init(
        weekNumber: Int = 3,
        dayOfWeek: Int = 4,
        records: [Int: DailyPracticeRecord] = [:]
    ) {
        self.currentWeekNumber = weekNumber

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let elapsedDays = (weekNumber - 1) * 7 + (dayOfWeek - 1)
        self.cycleStartDate = calendar.date(byAdding: .day, value: -elapsedDays, to: today) ?? today

        var resolved: [String: DailyPracticeRecord] = [:]
        for (dayOfWeek, record) in records {
            let offsetFromCycleStart = (weekNumber - 1) * 7 + (dayOfWeek - 1)
            if let date = calendar.date(byAdding: .day, value: offsetFromCycleStart, to: cycleStartDate) {
                resolved[Self.key(for: date)] = record
            }
        }
        self.dailyRecords = resolved
    }

    func beginNewCycle(on date: Date) {
        cycleStartDate = date
        dailyRecords = [:]
    }

    func drawnPracticeID(on date: Date) -> String? {
        dailyRecords[Self.key(for: date)]?.practiceID
    }

    func setDrawnPracticeID(_ practiceID: String, on date: Date) {
        var record = dailyRecords[Self.key(for: date)] ?? DailyPracticeRecord()
        record.practiceID = practiceID
        dailyRecords[Self.key(for: date)] = record
    }

    func isCompleted(on date: Date) -> Bool? {
        dailyRecords[Self.key(for: date)]?.isCompleted
    }

    func setCompleted(_ completed: Bool, on date: Date) {
        var record = dailyRecords[Self.key(for: date)] ?? DailyPracticeRecord()
        record.isCompleted = completed
        dailyRecords[Self.key(for: date)] = record
    }

    private static func key(for date: Date) -> String {
        let day = Calendar.current.startOfDay(for: date)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: day)
    }
}
