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

    func load() {
        assignments = repository.load()
    }

    func add(_ assignment: Assignment) {
        repository.add(assignment)
        load()
    }

    func update(_ assignment: Assignment) {
        repository.update(assignment)
        load()
    }

    func delete(_ assignment: Assignment) {
        repository.delete(assignment)
        load()
    }
}
