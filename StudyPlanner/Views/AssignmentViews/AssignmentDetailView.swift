//
//  AssignmentDetailView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 12/9/2026.
//

import SwiftUI

struct AssignmentDetailView: View {
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel

    let assignment: Assignment

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AssignmentProgressView(
                    assignment: currentAssignment
                )

                SubtaskListView(
                    assignment: currentAssignment
                )

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
}
