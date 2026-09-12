//
//  TaskViewModel.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 12/9/2026.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    let assignmentViewModel: AssignmentViewModel

    init(assignmentViewModel: AssignmentViewModel) {
        self.assignmentViewModel = assignmentViewModel
    }

    var allTasks: [AcademicTask] {
        assignmentViewModel.assignments.flatMap { $0.tasks }
    }

    var upcomingTasks: [AcademicTask] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let oneWeekLater = calendar.date(
            byAdding: .day,
            value: 7,
            to: today
        ) else {
            return []
        }

        return assignmentViewModel.assignments
            .filter {
                let dueDate = calendar.startOfDay(for: $0.dueDate)

                return dueDate >= today &&
                    dueDate <= oneWeekLater
            }
            .flatMap { $0.tasks }
    }

    func addTask(
        title: String,
        to assignmentID: String
    ) {
        let cleanedTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedTitle.isEmpty else {
            return
        }

        guard var assignment =
                assignmentViewModel.assignments.first(
                    where: { $0.id == assignmentID }
                )
        else {
            return
        }

        let newTask = AcademicTask(
            title: cleanedTitle,
            isCompleted: false
        )

        assignment.tasks.append(newTask)

        assignmentViewModel.update(assignment)
    }

    func editTask(
        taskID: String,
        newTitle: String
    ) {
        let cleanedTitle = newTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedTitle.isEmpty else {
            return
        }

        for assignment in assignmentViewModel.assignments {
            guard let taskIndex = assignment.tasks.firstIndex(
                where: { $0.id == taskID }
            ) else {
                continue
            }

            var updatedAssignment = assignment

            updatedAssignment.tasks[taskIndex].title =
                cleanedTitle

            assignmentViewModel.update(
                updatedAssignment
            )

            return
        }
    }

    func deleteTask(taskID: String) {
        for assignment in assignmentViewModel.assignments {
            guard let taskIndex = assignment.tasks.firstIndex(
                where: { $0.id == taskID }
            ) else {
                continue
            }

            var updatedAssignment = assignment

            updatedAssignment.tasks.remove(
                at: taskIndex
            )

            assignmentViewModel.update(
                updatedAssignment
            )

            return
        }
    }

    func toggleTask(taskID: String) {
        for assignment in assignmentViewModel.assignments {
            guard let taskIndex = assignment.tasks.firstIndex(
                where: { $0.id == taskID }
            ) else {
                continue
            }

            var updatedAssignment = assignment

            updatedAssignment.tasks[taskIndex]
                .isCompleted.toggle()

            assignmentViewModel.update(
                updatedAssignment
            )

            return
        }
    }
}
