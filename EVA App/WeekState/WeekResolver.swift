//
//  WeekResolver.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

struct WeekResolver: WeekResolverProviding {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func weekNumber(cycleStartDate: Date, today: Date, totalWeeks: Int = 7) -> Int {
        let start = calendar.startOfDay(for: cycleStartDate)
        let now = calendar.startOfDay(for: today)
        let elapsedDays = calendar.dateComponents([.day], from: start, to: now).day ?? 0
        let week = (elapsedDays / 7) + 1
        return min(max(week, 1), totalWeeks)
    }

    func status(for date: Date, today: Date) -> DayStatus {
        let day = calendar.startOfDay(for: date)
        let referenceDay = calendar.startOfDay(for: today)
        if day == referenceDay { return .today }
        return day < referenceDay ? .past : .future
    }

    func daysInWeek(_ weekNumber: Int, cycleStartDate: Date, today: Date) -> [ProgramDay] {
        let cycleStart = calendar.startOfDay(for: cycleStartDate)
        let offsetToWeekStart = (weekNumber - 1) * 7

        guard let weekStart = calendar.date(byAdding: .day, value: offsetToWeekStart, to: cycleStart) else {
            return []
        }

        return (0..<7).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else {
                return nil
            }
            return ProgramDay(id: dayOffset + 1, date: date, status: status(for: date, today: today))
        }
    }

    func currentTheme(forWeek weekNumber: Int, in goals: [AttentionalGoal]) -> AttentionalGoal? {
        goals.first { $0.week == weekNumber }
    }

    func cyclePosition(forWeek weekNumber: Int, totalWeeks: Int = 7) -> CyclePosition {
        CyclePosition(currentWeek: weekNumber, totalWeeks: totalWeeks)
    }
}
