//
//  AddAssignmentView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 10/9/2026.
//

import SwiftUI

struct AddAssignmentView: View {

    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var selectedSubject = "Select Subject"
    @State private var dueDate = Date()
    @State private var priority: Assignment.Priority = .high
    @State private var description = ""

    private let subjects = [
        "Database Systems",
        "UI/UX Design",
        "Cloud Computing",
        "Digital Forensics",
        "Programming",
        "Marketing"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Assignment Title")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        TextField(
                            "e.g. Database Assignment",
                            text: $title
                        )
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.gray.opacity(0.4),
                                    lineWidth: 1
                                )
                        )
                    }

                    VStack(alignment: .leading, spacing: 7) {
                        Text("Subject")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Menu {
                            ForEach(subjects, id: \.self) { subject in
                                Button(subject) {
                                    selectedSubject = subject
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedSubject)
                                    .foregroundStyle(
                                        selectedSubject == "Select Subject"
                                        ? .secondary
                                        : .primary
                                    )

                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.gray.opacity(0.4),
                                        lineWidth: 1
                                    )
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 7) {
                        Text("Due Date")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        DatePicker(
                            "",
                            selection: $dueDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.gray.opacity(0.4),
                                    lineWidth: 1
                                )
                        )
                    }

                    VStack(alignment: .leading, spacing: 7) {
                        Text("Priority")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Menu {
                            Button {
                                priority = .high
                            } label: {
                                Text("High")
                            }

                            Button {
                                priority = .medium
                            } label: {
                                Text("Medium")
                            }

                            Button {
                                priority = .low
                            } label: {
                                Text("Low")
                            }

                        } label: {
                            HStack {
                                Circle()
                                    .fill(priorityColor(priority))
                                    .frame(width: 9, height: 9)

                                Text(priority.rawValue)
                                    .foregroundStyle(.primary)

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.gray.opacity(0.4),
                                        lineWidth: 1
                                    )
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 7) {
                        Text("Description (Optional)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.gray.opacity(0.4),
                                    lineWidth: 1
                                )

                            if description.isEmpty {
                                Text("Enter assignment details...")
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                            }

                            TextEditor(text: $description)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        .frame(height: 120)
                    }

                    Button {
                        saveAssignment()
                    } label: {
                        Text("Add Assignment")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                    }
                    .disabled(
                        title.trimmingCharacters(
                            in: .whitespaces
                        ).isEmpty ||
                        selectedSubject == "Select Subject"
                    )
                    .opacity(
                        title.trimmingCharacters(
                            in: .whitespaces
                        ).isEmpty ||
                        selectedSubject == "Select Subject"
                        ? 0.5
                        : 1
                    )
                }
                .padding(20)
            }
            .navigationTitle("Add Assignment")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - Top Buttons
            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {

                    Button {
                        dismiss()
                    } label: {

                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                    }
                }

                ToolbarItem(
                    placement: .confirmationAction
                ) {

                    Button {
                        saveAssignment()
                    } label: {

                        Image(systemName: "checkmark")
                            .fontWeight(.semibold)
                    }
                    .disabled(
                        title.trimmingCharacters(
                            in: .whitespaces
                        ).isEmpty ||
                        selectedSubject == "Select Subject"
                    )
                }
            }
        }
    }

    // MARK: - Save Assignment
    private func saveAssignment() {

        let newAssignment = Assignment(
            title: title,
            course: selectedSubject,
            dueDate: dueDate,
            priority: priority,
            tasks: []
        )

        assignmentViewModel.add(newAssignment)

        dismiss()
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

    AddAssignmentView()
        .environmentObject(
            AssignmentViewModel(
                repository: LocalAssignmentRepository()
            )
        )
}
