//
//  TaskView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 9/9/2026.
//

import SwiftUI

struct TaskView: View {

    @Binding var task: AcademicTask

    var body: some View {
        HStack(spacing: 12) {

            Button {
                withAnimation {
                    task.isCompleted.toggle()
                }
            } label: {
                Image(
                    systemName: task.isCompleted
                        ? "checkmark.square.fill"
                        : "square"
                )
                .font(.title3)
            }
            .buttonStyle(.plain)

            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(
                    task.isCompleted ? .secondary : .primary
                )

            Spacer()
        }
    }
}
