//
//  AssigmentViewModel.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import Foundation
import Combine

final class AssignmentViewModel: ObservableObject {
    @Published var assignments: [Assignment] = []

    let repository: AssignmentRepository

    private let addAssignmentUseCase: AddAssignmentUseCase

    init(repository: AssignmentRepository) {
        self.repository = repository
        self.addAssignmentUseCase = AddAssignmentUseCase(repository: repository)
        load()
    }

    func load() {
        assignments = repository.assignments
    }

    func add(
        title: String,
        course: String,
        dueDate: Date,
        priority: Assignment.Priority,
        description: String
    ) throws {
        _ = try addAssignmentUseCase.execute(
            title: title,
            course: course,
            dueDate: dueDate,
            priority: priority,
            description: description
        )

        assignments = repository.assignments
    }

    func update(_ assignment: Assignment) {
        repository.update(assignment)
        assignments = repository.assignments
    }

    func delete(_ assignment: Assignment) {
        repository.delete(assignment)
        assignments = repository.assignments
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

        guard let assignmentIndex = assignments.firstIndex(
            where: { $0.id == assignmentID }
        ) else {
            return
        }

        let newTask = AcademicTask(
            title: cleanedTitle,
            isCompleted: false
        )

        assignments[assignmentIndex].tasks.append(
            newTask
        )

        repository.update(
            assignments[assignmentIndex]
        )

        assignments = repository.assignments
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

        for assignmentIndex in assignments.indices {
            if let taskIndex = assignments[assignmentIndex].tasks.firstIndex(
                where: { $0.id == taskID }
            ) {
                assignments[assignmentIndex].tasks[taskIndex].title = cleanedTitle
                repository.update(assignments[assignmentIndex])
                assignments = repository.assignments
                return
            }
        }
    }

    func deleteTask(taskID: String) {
        for assignmentIndex in assignments.indices {
            if let taskIndex = assignments[assignmentIndex].tasks.firstIndex(
                where: { $0.id == taskID }
            ) {
                assignments[assignmentIndex].tasks.remove(
                    at: taskIndex
                )
                repository.update(assignments[assignmentIndex])
                assignments = repository.assignments
                return
            }
        }
    }

    func toggleTask(taskID: String) {
        for assignmentIndex in assignments.indices {
            if let taskIndex = assignments[assignmentIndex].tasks.firstIndex(
                where: { $0.id == taskID }
            ) {
                assignments[assignmentIndex].tasks[taskIndex].isCompleted.toggle()

                repository.update(
                    assignments[assignmentIndex]
                )

                assignments = repository.assignments

                return
            }
        }
    }

    var allTasks: [AcademicTask] {
        assignments.flatMap { $0.tasks }
    }

    var todayTasks: [AcademicTask] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let oneWeekLater = calendar.date(
            byAdding: .day,
            value: 7,
            to: today
        ) else {
            return []
        }

        return assignments
            .filter {
                $0.dueDate >= today &&
                $0.dueDate <= oneWeekLater
            }
            .flatMap { $0.tasks }
    }

    var overallProgress: Double {
        let allTasks = assignments.flatMap { $0.tasks }

        guard !allTasks.isEmpty else {
            return 0
        }

        let completedTasks = allTasks.filter {
            $0.isCompleted
        }.count

        return Double(completedTasks) / Double(allTasks.count)
    }
}
