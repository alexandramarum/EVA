//
//  ContentLibrary.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/9/26.
//

import Foundation

struct EVAContentLibrary: Codable {
    let microPractices: [MicroPractice]
    let attentionalGoals: [AttentionalGoal]
    let eveningReflection: EveningReflection
    let periodicCheckIn: PeriodicCheckIn
}

struct MicroPractice: Codable, Identifiable, Hashable {
    let id: String                 // e.g. "MP-01"
    let title: String              // e.g. "Breath Awareness"
    let durationMinutes: Int       // always 15, kept as data rather than assumed
    let whatYouNeed: String
    let primaryCapacity: String    // e.g. "Sustained attention"
    let instruction: String        // user-facing how-to
    let whyItWorks: String         // user-facing rationale
    let reflectionPrompt: String   // shown after the practice
}

struct AttentionalGoal: Codable, Identifiable, Hashable {
    var id: Int { week }
    let week: Int                      // 1...7
    let virtue: String                 // e.g. "Patience"
    let virtueTagline: String          // e.g. "Give it time!"
    let virtueDescription: String      // what the virtue is / helps with
    let goalTitle: String              // short name for the week's goal, e.g. "Make honey, not nectar"
    let goalStatement: String          // the if-then / behavioral-intention text
    let rationale: String              // the "why" paragraph shown under the goal
    let endOfWeekReflection: String    // prompt shown at the end of the week
}

struct EveningReflection: Codable {
    let openingLine: String
    let closingLine: String
    let sections: [ReflectionSection]
}

struct ReflectionSection: Codable, Identifiable, Hashable {
    var id: Int { sectionNumber }
    let sectionNumber: Int
    let totalSections: Int
    let title: String
    let instruction: String?
    let items: [ReflectionItem]

    enum CodingKeys: String, CodingKey {
        case sectionNumber, totalSections, title, instruction, items
    }

    init(sectionNumber: Int, totalSections: Int, title: String, instruction: String? = nil, items: [ReflectionItem]) {
        self.sectionNumber = sectionNumber
        self.totalSections = totalSections
        self.title = title
        self.instruction = instruction
        self.items = items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sectionNumber = try container.decode(Int.self, forKey: .sectionNumber)
        totalSections = try container.decode(Int.self, forKey: .totalSections)
        title = try container.decode(String.self, forKey: .title)
        instruction = try container.decodeIfPresent(String.self, forKey: .instruction)
        items = try container.decode([ReflectionItem].self, forKey: .items)
    }
}

enum ResponseType: String, Codable {
    case singleChoice
    case freeText
    case scale1to5
    case display
}

struct ReflectionItem: Codable, Identifiable, Hashable {
    var id: String { prompt }
    let prompt: String
    let responseType: ResponseType
    let options: [String]?
    let scaleLowLabel: String?
    let scaleHighLabel: String?

    enum CodingKeys: String, CodingKey {
        case prompt, responseType, options, scaleLowLabel, scaleHighLabel
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decode(String.self, forKey: .prompt)
        responseType = try container.decode(ResponseType.self, forKey: .responseType)
        options = try container.decodeIfPresent([String].self, forKey: .options)
        scaleLowLabel = try container.decodeIfPresent(String.self, forKey: .scaleLowLabel)
        scaleHighLabel = try container.decodeIfPresent(String.self, forKey: .scaleHighLabel)
    }
}

struct PeriodicCheckIn: Codable {
    let administrationPoints: [String]
    let attentionalHabitsInventory: AttentionalHabitsInventory
    let digitalBehaviorsInventory: DigitalBehaviorsInventory
}

struct AttentionalHabitsInventory: Codable {
    let prompt: String
    let scaleLowLabel: String
    let scaleHighLabel: String
    let domains: [HabitDomain]
    let qualitativeQuestions: [String]
}

struct HabitDomain: Codable, Identifiable, Hashable {
    var id: String { virtue }
    let virtue: String
    let virtueTagline: String
    let items: [HabitItem]
}

struct HabitItem: Codable, Identifiable, Hashable {
    var id: String { text }
    let text: String
    let isReverseKeyed: Bool
}

struct DigitalBehaviorsInventory: Codable {
    let prompt: String
    let scaleLowLabel: String
    let scaleHighLabel: String
    let items: [HabitItem]
}
