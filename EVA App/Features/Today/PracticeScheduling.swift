//
//  PracticeScheduling.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

protocol PracticeScheduling {
    func draw(from pool: [MicroPractice], excluding: Set<String>) -> MicroPractice?
}
 
struct PracticeScheduler: PracticeScheduling {
    func draw(from pool: [MicroPractice], excluding: Set<String>) -> MicroPractice? {
        pool.filter { !excluding.contains($0.id) }.randomElement()
    }
}
