//
//  TodayView.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/16/26.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        VStack {
            header
            
            
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
            
        }
    }
}

#Preview {
    TodayView()
}
