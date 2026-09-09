//
//  UpcomingDeadlinesView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 9/9/2026.
//

import SwiftUI

struct UpcomingDeadlinesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming Deadlines")
                    .font(.headline)
                
                Spacer()
                
                Text("View All")
                    .font(.caption)
            }
            
            Divider()
            
            HStack {
                Circle()
                    .frame(width: 8, height: 8)
                
                Text("Database Assignment")
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Circle()
                    .frame(width: 8, height: 8)
                
                Text("UI/UX Project")
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Circle()
                    .frame(width: 8, height: 8)
                
                Text("Marketing Quiz")
                
                Spacer()
            }
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
    UpcomingDeadlinesView()
}
