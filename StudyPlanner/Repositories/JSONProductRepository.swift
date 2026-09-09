//
//  JSONProductRepository.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import Foundation

class JSONAssignmentRepository: AssignmentRepository {

    private(set) var assignments: [Assignment] = []

    private let fileURL: URL

    init() {
        let fileManager = FileManager.default

        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        fileURL = documentsURL.appendingPathComponent(
            "SampleAssignments.json"
        )

        if !fileManager.fileExists(atPath: fileURL.path) {
            if let bundledURL = Bundle.main.url(
                forResource: "SampleAssignments",
                withExtension: "json"
            ) {
                try? fileManager.copyItem(
                    at: bundledURL,
                    to: fileURL
                )
            }
        }

        assignments = load()
    }

    func load() -> [Assignment] {
        do {
            let data = try Data(contentsOf: fileURL)

            return try JSONDecoder().decode(
                [Assignment].self,
                from: data
            )
        } catch {
            print("Failed to load assignments: \(error)")
            return []
        }
    }

    func add(_ assignment: Assignment) {
        assignments.append(assignment)
        save()
    }

    func update(_ assignment: Assignment) {
        if let index = assignments.firstIndex(
            where: { $0.id == assignment.id }
        ) {
            assignments[index] = assignment
            save()
        }
    }

    func delete(_ assignment: Assignment) {
        assignments.removeAll {
            $0.id == assignment.id
        }

        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(assignments)

            try data.write(
                to: fileURL,
                options: .atomic
            )
        } catch {
            print("Failed to save assignments: \(error)")
        }
    }
}
