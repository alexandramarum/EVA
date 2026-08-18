//
//  AppDependencies.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/17/26.
//

import Foundation

struct AppDependencies {
    let contentRepository: ContentRepository
    let weekState: any WeekStateProviding

    static let live = AppDependencies(
        contentRepository: JSONContentRepository(),
        weekState: WeekState()
    )

    static let preview = AppDependencies(
        contentRepository: MockContentRepository(),
        weekState: MockWeekState()
    )
}
