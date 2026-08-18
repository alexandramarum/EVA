//
//  WeeklyResolving.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

enum DayStatus: String, Codable {
    case past
    case today
    case future
}

struct ProgramDay: Identifiable, Hashable {
    /// 1...7, position within the week (1 = the week's first day).
    let id: Int
    let date: Date
    let status: DayStatus
}

struct CyclePosition: Equatable {
    let currentWeek: Int
    let totalWeeks: Int

    var displayText: String {
        "Week \(currentWeek) of \(totalWeeks)"
    }

    var isFinalWeek: Bool {
        currentWeek >= totalWeeks
    }
}

protocol WeekResolverProviding {
    func weekNumber(cycleStartDate: Date, today: Date, totalWeeks: Int) -> Int

    func status(for date: Date, today: Date) -> DayStatus

    func daysInWeek(_ weekNumber: Int, cycleStartDate: Date, today: Date) -> [ProgramDay]

    func currentTheme(forWeek weekNumber: Int, in goals: [AttentionalGoal]) -> AttentionalGoal?

    func cyclePosition(forWeek weekNumber: Int, totalWeeks: Int) -> CyclePosition
}

extension WeekResolverProviding {
    func weekNumber(cycleStartDate: Date, today: Date) -> Int {
        weekNumber(cycleStartDate: cycleStartDate, today: today, totalWeeks: 7)
    }

    func cyclePosition(forWeek weekNumber: Int) -> CyclePosition {
        cyclePosition(forWeek: weekNumber, totalWeeks: 7)
    }
}
