//
//  PriorityBadge.swift
//  ToDoList
//
//  Created by Alina Doskulova on 18/2/25.
//

import SwiftUI

struct PriorityBadge: View {
    let priority: Priority
    
    private let primaryColor = Color.pink
    
    var gradient: LinearGradient {
        switch priority {
        case .low:
            return LinearGradient(
                gradient: Gradient(colors: [primaryColor.opacity(0.3), primaryColor.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .medium:
            return LinearGradient(
                gradient: Gradient(colors: [primaryColor.opacity(0.5), primaryColor.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .high:
            return LinearGradient(
                gradient: Gradient(colors: [primaryColor.opacity(0.6), primaryColor.opacity(1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var textColor: Color {
        return primaryColor
    }
    
    var body: some View {
        Text(priority.rawValue.uppercased())
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(gradient)
            .foregroundColor(textColor)
            .clipShape(Capsule())
            .shadow(color: textColor.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
