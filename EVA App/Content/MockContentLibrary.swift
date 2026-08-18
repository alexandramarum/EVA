//
//  MockContentLibrary.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

final class MockContentRepository: ContentRepository {

    private lazy var live = JSONContentRepository()

    func microPractices() -> [MicroPractice] {
        [
            MicroPractice(
                id: "MP-01",
                title: "Breath Awareness",
                durationMinutes: 15,
                whatYouNeed: "Somewhere to sit. No devices required.",
                primaryCapacity: "Focused attention, and meta-awareness of mind-wandering.",
                instruction: "Sit comfortably and rest your attention on the breath. When your mind drifts, bring it back.",
                whyItWorks: "Trains noticing when attention has drifted and returning to the present.",
                reflectionPrompt: "How quickly did you tend to notice you had wandered?"
            )
        ]
    }

    func attentionalGoals() -> [AttentionalGoal] {
        [
            AttentionalGoal(
                week: 3,
                virtue: "Just Attention",
                virtueTagline: "Listen charitably!",
                virtueDescription: "The habit of attending to others fairly and without distortion.",
                goalTitle: "Listen well enough to pass their test",
                goalStatement: "Before I give my own reply, I will make sure I could state the other person's point in a way they would endorse as fair.",
                rationale: "We tend to listen strategically, waiting for the gap where we can respond. This habit offers a litmus test for real listening.",
                endOfWeekReflection: "Was there a conversation where trying to pass this test changed what you heard, or how you answered?"
            )
        ]
    }

    func eveningReflection() -> EveningReflection {
        live.eveningReflection()
    }

    func periodicCheckIn() -> PeriodicCheckIn {
        live.periodicCheckIn()
    }
}
