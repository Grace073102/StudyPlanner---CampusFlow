//
//  AddAssignmentUseCase.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 10/9/2026.
//

import Foundation


struct AddAssignmentUseCase {
    
    let repository: AssignmentRepository

    enum AddAssignmentError: LocalizedError {
        case missingTitle
        case missingCourse
        case dueDateInPast
        var errorDescription: String? {
            switch self {
            case .missingTitle:
                return "Enter an assignment title before saving."
            case .missingCourse:
                return "Enter the course of this assignment."
            case .dueDateInPast:
                return "Choose a due date."
            }
        }
    }

    func execute(
        title: String,
        course: String,
        dueDate: Date,
        priority: Assignment.Priority,
        description: String
    ) throws -> Assignment {
        let cleanedTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanedCourse = course.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedTitle.isEmpty else {
            throw AddAssignmentError.missingTitle
        }

        guard !cleanedCourse.isEmpty else {
            throw AddAssignmentError.missingCourse
        }

        let calendar = Calendar.current

        let today = calendar.startOfDay(for: Date())

        let selectedDueDate =
            calendar.startOfDay(for: dueDate)

        guard selectedDueDate >= today else {
            throw AddAssignmentError.dueDateInPast
        }

        let assignment = Assignment(
            title: cleanedTitle,
            course: cleanedCourse,
            dueDate: dueDate,
            priority: priority,
            description: description,
            tasks: []
        )

        repository.add(assignment)

        return assignment
    }
}
