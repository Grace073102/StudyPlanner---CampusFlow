//
//  RootView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 9/9/2026.
//

import SwiftUI

struct RootView: View {

    @StateObject private var assignmentViewModel =
        AssignmentViewModel(
            repository: LocalAssignmentRepository()
        )

    var body: some View {
        AssignmentView()
            .environmentObject(assignmentViewModel)
    }
}

#Preview {
    RootView()
}
