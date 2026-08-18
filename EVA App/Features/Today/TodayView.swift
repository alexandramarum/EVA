//
//  TodayView.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/16/26.
//

import SwiftUI

struct TodayView: View {
    var vm: TodayViewModel
    
    var body: some View {
        VStack {
            header
            
            dayTracker
        }
    }
    
    private var header: some View {
        HStack {
            Image(.eva)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
                .frame(width: 56)
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "gearshape")
                    .foregroundStyle(Color.primary)
            }
        }
        .font(Font.system(size: 24))
        .padding()
    }
    
    private var dayTracker: some View {
        HStack {
            ForEach(vm.trackedDays) { day in
                CircleView(day: day)
            }
        }
    }
}


struct CircleView: View {
   var day: TrackedDay

   var body: some View {
       Circle()
           .fill(fillColor)
           .overlay(
               Circle()
                   .stroke(Color.accentColor, lineWidth: day.dayStatus == .today ? 2 : 0)
                   .padding(-3)
           )
           .frame(width: 10, height: 10)
   }

   private var fillColor: Color {
       switch day.completionStatus {
       case .completed:
           return .green
       case .skipped:
           return .red
       case .pending:
           return Color(.systemGray4)
       case .notApplicable:
           return Color(.systemGray5)
       }
   }
}


#Preview {
    TodayView(vm: TodayViewModel(content: MockContentRepository(), weekState: MockWeekState(
        weekNumber: 3,
        dayOfWeek: 5,
        records: [
            1: .init(isCompleted: true),
            2: .init(isCompleted: true),
            3: .init(isCompleted: false),
            4: .init(isCompleted: false)
        ]
    )))
}
