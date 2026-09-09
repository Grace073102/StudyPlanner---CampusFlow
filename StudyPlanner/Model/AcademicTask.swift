//
//  Academic Task.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

import Foundation

struct AcademicTask: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var isCompleted: Bool
}
