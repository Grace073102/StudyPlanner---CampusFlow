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
                HStack {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)

                    Spacer()

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

                HStack {
                    Text("Hi, Sarah!")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()
                }

                UpcomingDeadlinesView(
                    assignments: assignmentViewModel.assignments
                )

                VStack(alignment: .leading, spacing: 16) {
                    Text("Today's Task")
                        .font(.headline)
                        .fontWeight(.semibold)

                    if assignmentViewModel.todayTasks.isEmpty {
                        Text("No tasks for today")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(assignmentViewModel.todayTasks) { task in
                            Button {
                                assignmentViewModel.toggleTask(
                                    taskID: task.id
                                )
                            } label: {
                                HStack(spacing: 12) {
                                    Image(
                                        systemName: task.isCompleted
                                        ? "checkmark.square.fill"
                                        : "square"
                                    )

                                    Text(task.title)
                                        .strikethrough(task.isCompleted)

                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
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
