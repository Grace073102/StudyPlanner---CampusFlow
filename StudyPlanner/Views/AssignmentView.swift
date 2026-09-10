//
//  AssignmentView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import SwiftUI

struct AssignmentView: View {

    @EnvironmentObject var assignmentViewModel: AssignmentViewModel

    @State private var showAddAssignment = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Top Navigation
                HStack {

                    Image(systemName: "line.3.horizontal")
                        .font(.title2)

                    Spacer()

                    // Add Assignment Button
                    Button {
                        showAddAssignment = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                    }
                }

                // MARK: - Greeting
                HStack {

                    Text("Hi, Sarah!")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()
                }

                // MARK: - Upcoming Deadlines
                UpcomingDeadlinesView(
                    assignments: assignmentViewModel.assignments
                )

                // MARK: - Today's Tasks
                VStack(alignment: .leading, spacing: 16) {

                    Text("Today's Task")
                        .font(.headline)
                        .fontWeight(.semibold)

                    if assignmentViewModel.assignments.isEmpty {

                        Text("No tasks available")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    } else {

                        ForEach(
                            $assignmentViewModel.assignments[0].tasks
                        ) { $task in

                            TaskView(task: $task) {

                                let updatedAssignment =
                                    assignmentViewModel.assignments[0]

                                assignmentViewModel.update(
                                    updatedAssignment
                                )
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(
                            color: .black.opacity(0.06),
                            radius: 5,
                            x: 0,
                            y: 2
                        )
                )

                // MARK: - Progress Overview
                ProgressOverviewView(
                    progress: assignmentViewModel.overallProgress
                )

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(
            Color(.systemGroupedBackground)
        )

        // MARK: - Add Assignment Sheet
        .sheet(isPresented: $showAddAssignment) {

            AddAssignmentView()
                .environmentObject(assignmentViewModel)
        }
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
