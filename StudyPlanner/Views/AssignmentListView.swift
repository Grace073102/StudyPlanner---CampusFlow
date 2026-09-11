//
//  AssignmentListView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import SwiftUI

struct AssignmentListView: View {
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Assignments")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("\(sortedAssignments.count) assignments")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if sortedAssignments.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 38))
                            .foregroundStyle(.secondary)

                        Text("No assignments yet")
                            .font(.headline)

                        Text("Add an assignment to start organising your deadlines.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    ForEach(sortedAssignments) { assignment in
                        HStack(spacing: 14) {
                            VStack(spacing: 2) {
                                Text(
                                    assignment.dueDate,
                                    format: .dateTime.day()
                                )
                                .font(.title3)
                                .fontWeight(.bold)

                                Text(
                                    assignment.dueDate,
                                    format: .dateTime.month(.abbreviated)
                                )
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                            }
                            .frame(width: 52, height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        priorityColor(
                                            assignment.priority
                                        )
                                        .opacity(0.10)
                                    )
                            )

                            VStack(alignment: .leading, spacing: 5) {
                                Text(assignment.title)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)

                                HStack(spacing: 5) {
                                    Image(systemName: "book.closed")
                                        .font(.caption2)

                                    Text(assignment.course)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .foregroundStyle(.secondary)

                                if !assignment.tasks.isEmpty {
                                    Text(
                                        "\(completedTaskCount(for: assignment))/\(assignment.tasks.count) tasks completed"
                                    )
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 10) {
                                Text(assignment.priority.rawValue)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(
                                        priorityColor(
                                            assignment.priority
                                        )
                                    )
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        priorityColor(
                                            assignment.priority
                                        )
                                        .opacity(0.12)
                                    )
                                    .clipShape(Capsule())

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(
                                    color: .black.opacity(0.05),
                                    radius: 5,
                                    x: 0,
                                    y: 2
                                )
                        )
                    }
                }
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sortedAssignments: [Assignment] {
        assignmentViewModel.assignments.sorted {
            $0.dueDate < $1.dueDate
        }
    }

    private func completedTaskCount(
        for assignment: Assignment
    ) -> Int {
        assignment.tasks.filter {
            $0.isCompleted
        }.count
    }

    private func priorityColor(
        _ priority: Assignment.Priority
    ) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}

#Preview {
    NavigationStack {
        AssignmentListView()
            .environmentObject(
                AssignmentViewModel(
                    repository: LocalAssignmentRepository()
                )
            )
    }
}
