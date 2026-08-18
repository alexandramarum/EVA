//
//  ContentRepository.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

protocol ContentRepository {
    func microPractices() -> [MicroPractice]
    func attentionalGoals() -> [AttentionalGoal]
    func eveningReflection() -> EveningReflection
    func periodicCheckIn() -> PeriodicCheckIn
}

final class JSONContentRepository: ContentRepository {
    private let library: EVAContentLibrary

    init(service: EVAContentService = EVAContentService()) {
        do {
            self.library = try service.loadContent()
        } catch {
            fatalError("Failed to load bundled EVA content: \(error)")
        }
    }

    func microPractices() -> [MicroPractice] { library.microPractices }
    func attentionalGoals() -> [AttentionalGoal] { library.attentionalGoals }
    func eveningReflection() -> EveningReflection { library.eveningReflection }
    func periodicCheckIn() -> PeriodicCheckIn { library.periodicCheckIn }
}
