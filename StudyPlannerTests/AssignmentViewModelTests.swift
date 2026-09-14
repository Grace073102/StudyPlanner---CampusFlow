//
//  AssignmentViewModelTests.swift
//  StudyPlannerTests
//
//  Created by Grace Chi Yen Chong on 14/9/2026.
//

import XCTest
@testable import StudyPlanner

final class AssignmentViewModelTests: XCTestCase {

    func testAddAssignment() throws {
        let repository = MockAddAssignmentRepository()
        let useCase = AddAssignmentUseCase(repository: repository)

        _ = try useCase.execute(
            title: "Database Assignment",
            course: "Database Systems",
            dueDate: Date().addingTimeInterval(86400),
            priority: .high,
            description: ""
        )

        XCTAssertEqual(repository.assignments.count, 1)
    }
    
    func testAddAssignmentWithEmptyTitle() {
            let repository = MockAddAssignmentRepository()
            let useCase = AddAssignmentUseCase(repository: repository)

            XCTAssertThrowsError(
                try useCase.execute(
                    title: "",
                    course: "Database Systems",
                    dueDate: Date().addingTimeInterval(86400),
                    priority: .high,
                    description: ""
                )
            )

            XCTAssertEqual(repository.assignments.count, 0)
        }
    
    func testAddAssignmentWithEmptyCourse() {
        let repository = MockAddAssignmentRepository()
        let useCase = AddAssignmentUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                title: "Database Assignment",
                course: "",
                dueDate: Date().addingTimeInterval(86400),
                priority: .high,
                description: ""
            )
        )

        XCTAssertEqual(repository.assignments.count, 0)
    }
    
    func testAddAssignmentWithPastDueDate() {
        let repository = MockAddAssignmentRepository()
        let useCase = AddAssignmentUseCase(repository: repository)

        let yesterday = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: Date()
        )!

        XCTAssertThrowsError(
            try useCase.execute(
                title: "Database Assignment",
                course: "Database Systems",
                dueDate: yesterday,
                priority: .high,
                description: ""
            )
        )

        XCTAssertEqual(repository.assignments.count, 0)
    }
    
    func testAssignmentIsCompleted() {
        let tasks = [
            AcademicTask(
                title: "Research",
                isCompleted: true,
                plannedDate: nil,
                estimatedMinutes: nil
            ),
            AcademicTask(
                title: "Write Report",
                isCompleted: true,
                plannedDate: nil,
                estimatedMinutes: nil
            )
        ]

        let assignment = Assignment(
            title: "Database Assignment",
            course: "Database Systems",
            dueDate: Date(),
            priority: .high,
            description: "",
            tasks: tasks
        )

        XCTAssertTrue(assignment.isCompleted)
    }
    
    func testProgressCalculation() {
        let tasks = [
            AcademicTask(
                title: "Task 1",
                isCompleted: true,
                plannedDate: nil,
                estimatedMinutes: nil
            ),
            AcademicTask(
                title: "Task 2",
                isCompleted: false,
                plannedDate: nil,
                estimatedMinutes: nil
            )
        ]

        let completedTasks = tasks.filter {
            $0.isCompleted
        }.count

        let progress = Double(completedTasks) / Double(tasks.count)

        XCTAssertEqual(progress, 0.5)
    }
    
    func testAddTaskLogic() {
        var assignment = Assignment(
            title: "Database Assignment",
            course: "Database",
            dueDate: Date(),
            priority: .high,
            description: "",
            tasks: []
        )

        let task = AcademicTask(
            title: "Complete Part 1",
            isCompleted: false,
            plannedDate: nil,
            estimatedMinutes: nil
        )

        assignment.tasks.append(task)

        XCTAssertEqual(assignment.tasks.count, 1)
        XCTAssertEqual(assignment.tasks.first?.title, "Complete Part 1")
    }
    
    func testTaskPlannedForToday() {
        let task = AcademicTask(
            title: "Study Database",
            isCompleted: false,
            plannedDate: Date(),
            estimatedMinutes: 45
        )

        let isToday = Calendar.current.isDateInToday(
            task.plannedDate!
        )

        XCTAssertTrue(isToday)
    }
}

final class MockAddAssignmentRepository: AssignmentRepository {
    private(set) var assignments: [Assignment] = []

    func load() -> [Assignment] {
        assignments
    }

    func add(_ assignment: Assignment) {
        assignments.append(assignment)
    }

    func update(_ assignment: Assignment) {
        guard let index = assignments.firstIndex(
            where: { $0.id == assignment.id }
        ) else {
            return
        }

        assignments[index] = assignment
    }

    func delete(_ assignment: Assignment) {
        assignments.removeAll {
            $0.id == assignment.id
        }
    }
}
