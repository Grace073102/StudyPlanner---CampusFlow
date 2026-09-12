//
//  DetailTaskView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 12/9/2026.
//

import SwiftUI

struct DetailTaskView: View {
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel

    @State private var selectedFilter = "All"
    @Namespace private var animation

    let filters = [
        "All",
        "Today",
        "This Week",
        "Completed"
    ]

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                HStack {
                    Text("Tasks")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()
                }

                HStack(spacing: 0) {
                    ForEach(
                        filters,
                        id: \.self
                    ) { filter in
                        Button {
                            withAnimation(
                                .easeInOut
                            ) {
                                selectedFilter = filter
                            }
                        } label: {
                            ZStack {
                                if selectedFilter == filter {
                                    RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        Color.blue
                                            .opacity(0.15)
                                    )
                                    .matchedGeometryEffect(id: "filter", in: animation)
                                }

                                Text(filter)
                                    .font(.subheadline)
                                    .fontWeight(
                                        selectedFilter == filter ? .semibold : .regular
                                    )
                                    .foregroundStyle(
                                        selectedFilter == filter ? .blue : .secondary
                                    )
                                    .frame(
                                        maxWidth:
                                            .infinity
                                    )
                                    .padding(.vertical, 8)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(4)
                .background(
                    RoundedRectangle(
                        cornerRadius: 10
                    )
                    .fill(
                        Color(.systemBackground)
                    )
                )

                prioritySection(
                    title: "High Priority",
                    priority: .high
                )

                prioritySection(
                    title: "Medium Priority",
                    priority: .medium
                )

                prioritySection(
                    title: "Low Priority",
                    priority: .low
                )
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
        )
    }

    private func prioritySection(title: String, priority: Assignment.Priority) -> some View {
        let assignments =
            filteredAssignments.filter {
                $0.priority == priority &&
                    !$0.tasks.isEmpty
            }

        return Group {
            if !assignments.isEmpty {
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    Text(title)
                        .font(.headline)

                    VStack(spacing: 0) {
                        ForEach(
                            assignments
                        ) { assignment in
                            ForEach(
                                assignment.tasks
                            ) { task in
                                TaskView(
                                    task: task
                                ) {
                                    taskViewModel
                                        .toggleTask(taskID: task.id)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                        .fill(
                            Color(
                                .systemBackground
                            )
                        )
                    )
                }
            }
        }
    }

    private var filteredAssignments:
        [Assignment] {
        switch selectedFilter {
        case "Today":
            return assignmentViewModel
                .assignments.filter {
                    Calendar.current
                        .isDateInToday(
                            $0.dueDate
                        )
                }

        case "This Week":
            return assignmentViewModel
                .assignments.filter {
                    Calendar.current.isDate(
                        $0.dueDate,
                        equalTo: Date(),
                        toGranularity:
                            .weekOfYear
                    )
                }

        case "Completed":
            return assignmentViewModel
                .assignments.map {
                    assignment in
                    var updatedAssignment = assignment
                    updatedAssignment.tasks =
                        assignment.tasks.filter {
                            $0.isCompleted
                        }
                    return updatedAssignment
                }
        default:
            return assignmentViewModel
                .assignments
        }
    }
}
