//
//  AssignmentView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import SwiftUI

struct AssignmentView: View {

    @EnvironmentObject var assignmentViewModel: AssignmentViewModel

    var body: some View {

        VStack(spacing: 20) {

            // Top navigation bar
            HStack {
                Image(systemName: "line.3.horizontal")

                Spacer()

                Image(systemName: "bell")
            }
            .padding(.horizontal)

            // Greeting
            HStack {
                Text("Hi, Sarah!")
                    .font(.title2)
                    .fontWeight(.medium)

                Spacer()
            }
            .padding(.horizontal)

            // Section 1 - Upcoming Deadlines
            UpcomingDeadlinesView(
                assignments: assignmentViewModel.assignments
            )

            // Section 2 - Today's Tasks
            VStack(alignment: .leading, spacing: 12) {

                Text("Today's Task")
                    .font(.headline)
                    .fontWeight(.semibold)

                if !assignmentViewModel.assignments.isEmpty {

                    ForEach(
                        $assignmentViewModel.assignments[0].tasks
                    ) { $task in

                        TaskView(task: $task) {

                            let updatedAssignment =
                                assignmentViewModel.assignments[0]

                            assignmentViewModel.update(updatedAssignment)
                        }
                    }
                } else {
                    Text("No tasks available")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
            .padding(.horizontal)

            // Section 3 - Progress Overview
            ProgressOverviewView(
                progress: assignmentViewModel.overallProgress
            )

            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    AssignmentView()
        .environmentObject(
            AssignmentViewModel(
                repository: LocalAssignmentRepository()
            )
        )
}
