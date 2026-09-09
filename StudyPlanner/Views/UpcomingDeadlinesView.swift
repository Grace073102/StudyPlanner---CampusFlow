//
//  UpcomingDeadlinesView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 9/9/2026.
//

//
//  UpcomingDeadlinesView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 9/9/2026.
//

import SwiftUI

struct UpcomingDeadlinesView: View {

    let assignments: [Assignment]

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Header
            HStack {

                VStack(alignment: .leading, spacing: 3) {

                    Text("Upcoming Deadlines")
                        .font(.headline)
                        .fontWeight(.bold)

                    Text("Stay on top of your work")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    // Navigation will be added later
                } label: {

                    HStack(spacing: 3) {
                        Text("View All")

                        Image(systemName: "chevron.right")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                }
            }

            // MARK: - Assignment List
            if assignments.isEmpty {

                Text("No upcoming deadlines")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)

            } else {

                ForEach(
                    assignments
                        .sorted { $0.dueDate < $1.dueDate }
                        .prefix(3)
                ) { assignment in

                    HStack(spacing: 0) {

                        // MARK: Priority Bar
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                priorityColor(
                                    assignment.priority
                                )
                            )
                            .frame(
                                width: 4,
                                height: 52
                            )

                        // MARK: Assignment Information
                        HStack {

                            VStack(
                                alignment: .leading,
                                spacing: 2
                            ) {

                                Text(assignment.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)

                                Text(assignment.course)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }

                            Spacer()

                            // Due Date
                            Text(
                                assignment.dueDate,
                                format: .dateTime
                                    .day()
                                    .month(.abbreviated)
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            // Priority Badge
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
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                Color(
                                    .secondarySystemBackground
                                )
                            )
                    )
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
    }

    // MARK: - Priority Colour
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


// MARK: - Preview
#Preview {

    UpcomingDeadlinesView(
        assignments: [

            Assignment(
                title: "Database Assignment",
                course: "Database Systems",
                dueDate: Date().addingTimeInterval(86400 * 2),
                priority: .high,
                tasks: []
            ),

            Assignment(
                title: "UI/UX Project",
                course: "UI/UX Design",
                dueDate: Date().addingTimeInterval(86400 * 5),
                priority: .medium,
                tasks: []
            ),

            Assignment(
                title: "Marketing Quiz",
                course: "Marketing",
                dueDate: Date().addingTimeInterval(86400 * 7),
                priority: .low,
                tasks: []
            )
        ]
    )
    .padding()
    .background(
        Color(.systemGroupedBackground)
    )
}
