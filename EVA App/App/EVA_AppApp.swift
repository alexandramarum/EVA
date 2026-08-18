//
//  EVA_AppApp.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/9/26.
//

import SwiftUI

@main
struct EVAApp: App {
    private let dependencies = AppDependencies.live

    var body: some Scene {
        WindowGroup {
            RootTabBar(dependencies: dependencies)
        }
    }
}
