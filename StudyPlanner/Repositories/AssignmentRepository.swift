//
//  AssignmentRepository.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import Foundation

protocol AssignmentRepository {
    var assignments: [Assignment] { get }
    func load() -> [Assignment]
    func add(_ assignment: Assignment)
    func update(_ assignment: Assignment)
    func delete(_ assignment: Assignment)
}
