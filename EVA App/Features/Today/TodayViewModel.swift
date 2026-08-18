//
//  TodayViewModel.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/16/26.
//

import Foundation
import Observation

struct TrackedDay: Identifiable {
    let id: Int
    let date: Date
    let dayStatus: DayStatus
    let completionStatus: CompletionStatus
}

enum CompletionStatus {
    case completed
    case skipped
    case pending
    case notApplicable
}

@Observable
final class TodayViewModel {
    private let content: ContentRepository
    private let weekState: any WeekStateProviding
    private let scheduler: PracticeScheduling
    private let resolver: WeekResolverProviding

    private(set) var currentGoal: AttentionalGoal?
    private(set) var todaysPractice: MicroPractice?
    private(set) var trackedDays: [TrackedDay] = []

    init(
        content: ContentRepository,
        weekState: any WeekStateProviding,
        scheduler: PracticeScheduling = PracticeScheduler(),
        resolver: WeekResolverProviding = WeekResolver()
    ) {
        self.content = content
        self.weekState = weekState
        self.scheduler = scheduler
        self.resolver = resolver
        refresh()
    }

    func refresh() {
        let week = weekState.currentWeekNumber
        currentGoal = resolver.currentTheme(forWeek: week, in: content.attentionalGoals())
        todaysPractice = resolveTodaysPractice()
        trackedDays = buildTrackedDays(forWeek: week)
    }

    func markTodayCompleted() {
        weekState.setCompleted(true, on: .now)
        refresh()
    }

    func markTodaySkipped() {
        weekState.setCompleted(false, on: .now)
        refresh()
    }

    private func resolveTodaysPractice() -> MicroPractice? {
        let today = Date.now
        let pool = content.microPractices()

        if let drawnID = weekState.drawnPracticeID(on: today) {
            return pool.first { $0.id == drawnID }
        }

        guard let drawn = scheduler.draw(from: pool, excluding: []) else { return nil }
        weekState.setDrawnPracticeID(drawn.id, on: today)
        return drawn
    }

    private func buildTrackedDays(forWeek week: Int) -> [TrackedDay] {
        resolver.daysInWeek(week, cycleStartDate: weekState.cycleStartDate, today: .now)
            .map { day in
                TrackedDay(
                    id: day.id,
                    date: day.date,
                    dayStatus: day.status,
                    completionStatus: completionStatus(for: day)
                )
            }
    }

    private func completionStatus(for day: ProgramDay) -> CompletionStatus {
        switch day.status {
        case .future:
            return .notApplicable
        case .today:
            return weekState.isCompleted(on: day.date).map { $0 ? .completed : .skipped } ?? .pending
        case .past:
            return weekState.isCompleted(on: day.date).map { $0 ? .completed : .skipped } ?? .skipped
        }
    }
}
