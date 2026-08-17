//
//  ContentLibrary.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/9/26.
//

import Foundation

// MARK: - Top-Level Container

/// The full content library delivered by the EVA app: the seven micro-practices,
/// the seven weekly attentional goals, the Evening Reflection instrument, and the
/// Periodic Check-In survey (baseline / midpoint / completion).
struct EVAContentLibrary: Codable {
    let microPractices: [MicroPractice]
    let attentionalGoals: [AttentionalGoal]
    let eveningReflection: EveningReflection
    let periodicCheckIn: PeriodicCheckIn
}

// MARK: - Part One: Micro-Practices

/// One of the seven 15-minute analogue attention exercises (MP-01 ... MP-07).
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

// MARK: - Part One: Attentional Goals

/// One week's behavioral intention, tied to one of the seven virtues of attention.
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

// MARK: - Part Two: Evening Reflection

/// The short daily survey completed each evening (three sections, ~2-3 minutes).
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
    /// Optional shared instruction/stem shown once for the section (e.g. the I-PANAS-SF stem).
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

/// The kind of UI control a reflection or check-in item should render as.
enum ResponseType: String, Codable {
    case singleChoice
    case freeText
    case scale1to5
    /// Not a question — a read-only display of context (e.g. the week's goal text).
    case display
}

struct ReflectionItem: Codable, Identifiable, Hashable {
    var id: String { prompt }
    let prompt: String
    let responseType: ResponseType
    /// Populated for `.singleChoice`; empty otherwise.
    let options: [String]?
    /// Populated for `.scale1to5`; the 1 and 5 anchor labels.
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

// MARK: - Part Three: Periodic Check-In

/// The longer survey administered three times per 7-week cycle: baseline, midpoint, completion.
struct PeriodicCheckIn: Codable {
    let administrationPoints: [String]
    let attentionalHabitsInventory: AttentionalHabitsInventory
    let digitalBehaviorsInventory: DigitalBehaviorsInventory
}

/// The EVA Attentional Habits Inventory (AHI) — seven virtue domains, each with
/// behaviorally grounded, Likert-scored items (some reverse-keyed), plus three
/// optional open-ended reflection questions.
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

/// A single Likert item. `isReverseKeyed` items should be recoded (6 - rawScore
/// on a 1-5 scale) before aggregating, so that higher always means the more
/// skillful habit.
struct HabitItem: Codable, Identifiable, Hashable {
    var id: String { text }
    let text: String
    let isReverseKeyed: Bool
}

/// The five-item Digital Behaviors Inventory administered alongside the AHI.
struct DigitalBehaviorsInventory: Codable {
    let prompt: String
    let scaleLowLabel: String
    let scaleHighLabel: String
    let items: [HabitItem]
}
