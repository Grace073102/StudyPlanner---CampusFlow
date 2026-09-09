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

    init(repository: AssignmentRepository) {
        self.repository = repository
        load()
    }

    // Load assignments from repository
    func load() {
        assignments = repository.assignments
    }

    // Add assignment
    func add(_ assignment: Assignment) {
        repository.add(assignment)
        assignments = repository.assignments
    }

    // Update assignment
    func update(_ assignment: Assignment) {
        repository.update(assignment)
        assignments = repository.assignments
    }

    // Delete assignment
    func delete(_ assignment: Assignment) {
        repository.delete(assignment)
        assignments = repository.assignments
    }

    // Calculate overall task progress
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
