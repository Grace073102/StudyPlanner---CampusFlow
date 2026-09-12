//
//  SubtaskListView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 13/9/2026.
//

import SwiftUI

struct SubtaskListView: View {

    @EnvironmentObject var taskViewModel: TaskViewModel

    let assignment: Assignment

    @State private var newTaskTitle = ""
    @State private var editingTaskID = ""
    @State private var editingTaskTitle = ""
    @State private var showEditTask = false
    @State private var deletingTaskID = ""
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Subtasks")
                        .font(.title3)
                        .fontWeight(.bold)

                    Spacer()

                    Text(
                        "\(completedTaskCount)/\(assignment.tasks.count)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                if assignment.tasks.isEmpty {
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
                                assignment.tasks.enumerated()
                            ),
                            id: \.element.id
                        ) { index, task in
                            HStack(spacing: 12) {
                                Button {
                                    withAnimation {
                                        taskViewModel.toggleTask(
                                            taskID: task.id
                                        )
                                    }
                                } label: {
                                    Image(
                                        systemName:
                                            task.isCompleted
                                            ? "checkmark.square.fill"
                                            : "square"
                                    )
                                    .font(.title3)
                                    .foregroundStyle(
                                        task.isCompleted
                                        ? .blue
                                        : .secondary
                                    )

                                }
                                .buttonStyle(.plain)

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

                                Button {
                                    editingTaskID = task.id
                                    editingTaskTitle = task.title
                                    showEditTask = true
                                } label: {
                                    Image(systemName: "pencil")
                                        .font(.subheadline)
                                        .foregroundStyle(.blue)
                                        .frame(
                                            width: 30,
                                            height: 30
                                        )
                                        .background(
                                            Circle()
                                                .fill(
                                                    Color.blue
                                                        .opacity(0.10)
                                                )
                                        )

                                }
                                .buttonStyle(.plain)
                                Button {
                                    deletingTaskID = task.id
                                    showDeleteConfirmation = true
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.subheadline)
                                        .foregroundStyle(.red)
                                        .frame(
                                            width: 30,
                                            height: 30
                                        )
                                        .background(
                                            Circle()
                                                .fill(
                                                    Color.red
                                                        .opacity(0.10)
                                                )
                                        )
                                }
                                .buttonStyle(.plain)

                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)

                            if index < assignment.tasks.count - 1 {

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

            }
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.blue)

                    Text("Add New Subtask")
                        .font(.headline)
                        .fontWeight(.semibold)
                }

                HStack(spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "checklist")
                            .foregroundStyle(.secondary)

                        TextField(
                            "Enter subtask title",
                            text: $newTaskTitle
                        )
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(
                                    .secondarySystemBackground
                                )
                            )
                    )

                    Button {

                        addTask()

                    } label: {

                        HStack(spacing: 5) {

                            Image(systemName: "plus")

                            Text("Add")

                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )

                    }
                    .disabled(cleanedTitle.isEmpty)
                    .opacity(
                        cleanedTitle.isEmpty
                        ? 0.5
                        : 1
                    )

                }

            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )

        }
        .alert(
            "Edit Subtask",
            isPresented: $showEditTask
        ) {
            TextField(
                "Subtask title",
                text: $editingTaskTitle
            )
            Button("Cancel", role: .cancel) {
            }

            Button("Save") {
                taskViewModel.editTask(
                    taskID: editingTaskID,
                    newTitle: editingTaskTitle
                )
            }
        }
        .alert(
            "Delete Subtask?",
            isPresented: $showDeleteConfirmation
        ) {
            Button(
                "Delete",
                role: .destructive
            ) {
                taskViewModel.deleteTask(
                    taskID: deletingTaskID
                )
            }

            Button("Cancel", role: .cancel) { }
        } message: {
            Text(
                "This subtask will be permanently removed."
            )
        }
    }

    private var completedTaskCount: Int {
        assignment.tasks.filter {
            $0.isCompleted
        }.count
    }

    private var cleanedTitle: String {
        newTaskTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private func addTask() {
        guard !cleanedTitle.isEmpty else {
            return
        }
        taskViewModel.addTask(
            title: cleanedTitle,
            to: assignment.id
        )
        newTaskTitle = ""
    }
}
