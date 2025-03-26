//
//  PriorityBadge.swift
//  ToDoList
//
//  Created by Alina Doskulova on 18/2/25.
//

import SwiftUI

struct PriorityBadge: View {
    let priority: Priority

    var body: some View {
        Text(priority.rawValue.capitalized)
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(priorityColor.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(priorityColor.opacity(0.6), lineWidth: 1)
                    )
            )
            .foregroundColor(priorityColor)
    }

    private var priorityColor: Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        case .none:
            return .gray
        }
    }
}
