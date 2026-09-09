//
//  ProgressOverviewView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 9/9/2026.
//

import SwiftUI

struct ProgressOverviewView: View {
    var body: some View {
            HStack(spacing: 20) {
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                    
                    Text("50%")
                        .font(.headline)
                }
                .frame(width: 70, height: 70)
                
                VStack(alignment: .leading) {
                    Text("Overall Progress")
                        .font(.headline)
                    
                    Text("Keep going!")
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
            )
            .padding(.horizontal)
        }
}

#Preview {
    ProgressOverviewView()
}
