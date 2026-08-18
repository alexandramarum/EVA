//
//  WeekStateProviding.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

protocol WeekStateProviding: AnyObject {
    var cycleStartDate: Date { get }
    var currentWeekNumber: Int { get }
    func beginNewCycle(on date: Date)
    func drawnPracticeID(on date: Date) -> String?
    func setDrawnPracticeID(_ practiceID: String, on date: Date)
    func isCompleted(on date: Date) -> Bool?
    func setCompleted(_ completed: Bool, on date: Date)
}
