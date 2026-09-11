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

    func toggleTask(taskID: String) {
        for assignmentIndex in assignments.indices {
            if let taskIndex = assignments[assignmentIndex].tasks.firstIndex(
                where: { $0.id == taskID }
            ) {
                assignments[assignmentIndex].tasks[taskIndex].isCompleted.toggle()
                repository.update(assignments[assignmentIndex])
                assignments = repository.assignments
                return
            }
        }
    }

    var allTasks: [AcademicTask] {
        assignments.flatMap { $0.tasks }
    }

    var todayTasks: [AcademicTask] {
        assignments
            .filter {
                Calendar.current.isDateInToday($0.dueDate)
            }
            .flatMap { $0.tasks }
    }

    var overallProgress: Double {
        let allTasks =
            assignments.flatMap { $0.tasks }

        guard !allTasks.isEmpty else {
            return 0
        }

        let completedTasks =
            allTasks.filter {
                $0.isCompleted
            }.count

        return Double(completedTasks) / Double(allTasks.count)
    }
}
