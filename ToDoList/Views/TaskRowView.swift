//
//  TaskRowView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 18/2/25.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    @EnvironmentObject var taskManager: TaskManager
    @State private var isTapped = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            completionIndicator
            contentStack
            Spacer()
            if task.dueDate < Date() && !task.isCompleted {
                overdueBadge
            }
        }
        .padding(16)
        .background(background)
        .overlay(priorityOverlay, alignment: .topTrailing)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isTapped ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isTapped)
        .onTapGesture {
            withAnimation {
                isTapped.toggle()
            }
        }
    }
    
    private var completionIndicator: some View {
        ZStack {
            Circle()
                .stroke(task.isCompleted ? Color.pink : Color.gray.opacity(0.3), lineWidth: 2)
                .frame(width: 32, height: 32)
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.pink)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onTapGesture {
            taskManager.toggleTaskCompletion(task)
        }
    }
    
    private var contentStack: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(task.title)
                .font(.system(.body, design: .rounded))
                .fontWeight(task.isCompleted ? .regular : .semibold)
                .foregroundColor(task.isCompleted ? .pink.opacity(0.7) : .primary)
                .strikethrough(task.isCompleted, color: .pink.opacity(0.5))
                .lineLimit(2)
            
            HStack {
                Image(systemName: "calendar")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text(task.dueDate.formatted(.dateTime.day().month().year()))
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(task.dueDate < Date() && !task.isCompleted ? .pink : .gray)
            }
        }
    }
    
    private var background: some View {

        let lightGradient = Gradient(colors: [
            Color.white.opacity(0.95),
            task.isCompleted ? Color.pink.opacity(0.1) : Color.blue.opacity(0.1)
        ])
        
        let darkGradient = Gradient(colors: [
            Color.black.opacity(0.95),
            task.isCompleted ? Color.green.opacity(0.1) : Color.blue.opacity(0.1)
        ])
        
        let gradient = colorScheme == .dark ? darkGradient : lightGradient
        
        return LinearGradient(
            gradient: gradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
    }
    
    private var overdueBadge: some View {
        Text("Overdue")
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.pink.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var priorityOverlay: some View {
        Group {
            if task.priority == .high {
                Text("High Priority")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(6)
                    .background(Color.pink.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.top, .trailing], 8)
            }
        }
    }
}
