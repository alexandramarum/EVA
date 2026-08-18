//
//  WeekState.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation
import Observation

struct DailyPracticeRecord: Codable, Equatable {
    var practiceID: String?
    var isCompleted: Bool?
}

@Observable
final class WeekState: WeekStateProviding {

    private(set) var cycleStartDate: Date
    private(set) var dailyRecords: [String: DailyPracticeRecord]

    private let persistence: WeekStatePersisting
    private let resolver: WeekResolverProviding

    var currentWeekNumber: Int {
        resolver.weekNumber(cycleStartDate: cycleStartDate, today: .now)
    }

    init(
        persistence: WeekStatePersisting = UserDefaultsWeekStatePersistence(),
        resolver: WeekResolverProviding = WeekResolver()
    ) {
        self.persistence = persistence
        self.resolver = resolver
        self.cycleStartDate = persistence.loadCycleStartDate()
            ?? Calendar.current.startOfDay(for: .now)
        self.dailyRecords = persistence.loadDailyRecords()
    }

    func beginNewCycle(on date: Date) {
        let start = Calendar.current.startOfDay(for: date)
        cycleStartDate = start
        dailyRecords = [:]
        persistence.save(cycleStartDate: start)
        persistence.save(dailyRecords: dailyRecords)
    }

    func drawnPracticeID(on date: Date) -> String? {
        dailyRecords[key(for: date)]?.practiceID
    }

    func setDrawnPracticeID(_ practiceID: String, on date: Date) {
        var record = dailyRecords[key(for: date)] ?? DailyPracticeRecord()
        record.practiceID = practiceID
        dailyRecords[key(for: date)] = record
        persistence.save(dailyRecords: dailyRecords)
    }

    func isCompleted(on date: Date) -> Bool? {
        dailyRecords[key(for: date)]?.isCompleted
    }

    func setCompleted(_ completed: Bool, on date: Date) {
        var record = dailyRecords[key(for: date)] ?? DailyPracticeRecord()
        record.isCompleted = completed
        dailyRecords[key(for: date)] = record
        persistence.save(dailyRecords: dailyRecords)
    }

    private func key(for date: Date) -> String {
        let day = Calendar.current.startOfDay(for: date)
        return ISO8601DateFormatter.dayOnly.string(from: day)
    }
}

private extension ISO8601DateFormatter {
    static let dayOnly: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
}

protocol WeekStatePersisting {
    func loadCycleStartDate() -> Date?
    func save(cycleStartDate: Date)
    func loadDailyRecords() -> [String: DailyPracticeRecord]
    func save(dailyRecords: [String: DailyPracticeRecord])
}

struct UserDefaultsWeekStatePersistence: WeekStatePersisting {
    private let cycleStartKey = "com.eva.cycleStartDate"
    private let dailyRecordsKey = "com.eva.dailyRecords"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadCycleStartDate() -> Date? {
        let stored = defaults.double(forKey: cycleStartKey)
        return stored == 0 ? nil : Date(timeIntervalSince1970: stored)
    }

    func save(cycleStartDate: Date) {
        defaults.set(cycleStartDate.timeIntervalSince1970, forKey: cycleStartKey)
    }

    func loadDailyRecords() -> [String: DailyPracticeRecord] {
        guard let data = defaults.data(forKey: dailyRecordsKey),
              let decoded = try? JSONDecoder().decode([String: DailyPracticeRecord].self, from: data)
        else {
            return [:]
        }
        return decoded
    }

    func save(dailyRecords: [String: DailyPracticeRecord]) {
        guard let data = try? JSONEncoder().encode(dailyRecords) else { return }
        defaults.set(data, forKey: dailyRecordsKey)
    }
}
