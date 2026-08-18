//
//  TabView.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/16/26.
//

import Foundation
import SwiftUI

struct RootTabBar: View {
    var dependencies: AppDependencies
    
    var body: some View {
        TabView {
            Tab("Today", systemImage: "sun.max.fill") { TodayView(vm: .init(content: dependencies.contentRepository, weekState: dependencies.weekState)) }
            Tab("Practices", systemImage: "diamond") {}
            Tab("Program", systemImage: "smallcircle.filled.circle") {}
            Tab("Journal", systemImage: "book") {}
        }
    }
}
