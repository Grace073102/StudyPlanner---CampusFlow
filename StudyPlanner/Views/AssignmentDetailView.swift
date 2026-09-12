//
//  AssignmentDetailView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 12/9/2026.
//

import SwiftUI

struct AssignmentDetailView: View {

    @EnvironmentObject var assignmentViewModel: AssignmentViewModel

    let assignment: Assignment

    @State private var newTaskTitle = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Overall Progress")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Text(
                                "\(Int(assignmentProgress * 100))% completed"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("\(Int(assignmentProgress * 100))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    
                    ProgressView(value: assignmentProgress)
                        .tint(.blue)
                        .scaleEffect(x: 1, y: 1.5)
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.caption)
                            Text(
                                currentAssignment.dueDate,
                                format: .dateTime
                                    .day()
                                    .month(.abbreviated)
                                    .year()
                            )
                            .font(.caption)
                        }
                        .foregroundStyle(.secondary)

                        Spacer()

                        Text(currentAssignment.priority.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                priorityColor(
                                    currentAssignment.priority
                                )
                            )
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                priorityColor(
                                    currentAssignment.priority
                                )
                                .opacity(0.12)
                            )
                            .clipShape(Capsule())
                    }
                }
                .padding(16)
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

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Subtasks")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Text(
                            "\(completedTaskCount)/\(currentAssignment.tasks.count)"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    if currentAssignment.tasks.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "checklist")
                                .font(.system(size: 30))
                                .foregroundStyle(.secondary)

                            Text("No subtasks yet")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Text("Add a task below to get started.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(
                                Array(
                                    currentAssignment.tasks.enumerated()
                                ),
                                id: \.element.id
                            ) { index, task in
                                Button {
                                    withAnimation {
                                        assignmentViewModel.toggleTask(
                                            taskID: task.id
                                        )
                                    }
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(
                                            systemName:
                                                task.isCompleted ? "checkmark.square.fill" : "square"
                                        )
                                        .font(.title3)
                                        .foregroundStyle(
                                            task.isCompleted
                                            ? .blue
                                            : .secondary
                                        )
                                        Text(task.title)
                                            .font(.subheadline)
                                            .foregroundStyle(
                                                task.isCompleted
                                                ? .secondary
                                                : .primary
                                            )
                                            .strikethrough(
                                                task.isCompleted
                                            )

                                        Spacer()

                                        if task.isCompleted {
                                            Image(
                                                systemName: "checkmark"
                                            )
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 14)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                if index < currentAssignment.tasks.count - 1 {
                                    Divider()
                                        .padding(.leading, 48)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemBackground))
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }

                    HStack(spacing: 10) {
                        TextField(
                            "Add a new subtask",
                            text: $newTaskTitle
                        )
                        .padding(.horizontal, 12)
                        .frame(height: 42)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color(
                                        .secondarySystemBackground
                                    )
                                )
                        )

                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 42, height: 42)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                )
                        }
                        .disabled(
                            newTaskTitle
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                .isEmpty
                        )
                        .opacity(
                            newTaskTitle
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                .isEmpty
                            ? 0.5
                            : 1
                        )
                    }
                }

                if let description = currentAssignment.description,
                   !description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)

                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
                }
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationTitle(currentAssignment.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var currentAssignment: Assignment {
        assignmentViewModel.assignments.first {
            $0.id == assignment.id
        } ?? assignment

    }

    private var completedTaskCount: Int {
        currentAssignment.tasks.filter {
            $0.isCompleted
        }.count
    }

    private var assignmentProgress: Double {
        guard !currentAssignment.tasks.isEmpty else {
            return 0
        }
        return Double(completedTaskCount) / Double(currentAssignment.tasks.count)
    }

    private func addTask() {
        let cleanedTitle = newTaskTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !cleanedTitle.isEmpty else {
            return
        }

        var updatedAssignment = currentAssignment

        updatedAssignment.tasks.append(
            AcademicTask(
                title: cleanedTitle,
                isCompleted: false
            )
        )
        assignmentViewModel.update(updatedAssignment)
        newTaskTitle = ""
    }

    private func priorityColor(_ priority: Assignment.Priority) -> Color {
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
