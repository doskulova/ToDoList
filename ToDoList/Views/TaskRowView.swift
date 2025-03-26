//
//  TaskRowView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 18/2/25.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    @EnvironmentObject private var taskManager: TaskManager
    @State private var showingEditView = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 16) {
            completionIndicator

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(task.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted, color: .secondary)
                        .lineLimit(2)

                    Spacer()

                    PriorityBadge(priority: task.priority)
                }

                if !task.isCompleted || !task.category.rawValue.isEmpty {
                    HStack(spacing: 16) {
                        if !task.isCompleted, task.dueDate != Date.distantFuture {
                            dueDateLabel
                        }

                        if !task.category.rawValue.isEmpty {
                            categoryLabel
                        }
                    }
                    .font(.system(.caption, design: .rounded))
                }
            }

            Spacer()

            VStack {
                editButton
                deleteButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
        )
        .opacity(task.isCompleted ? 0.9 : 1.0)
        .scaleEffect(task.isCompleted ? 0.98 : 1.0)
    }

    private var gradientColors: [Color] {
        let lightColors = [Color.green.opacity(0.3), Color.yellow.opacity(0.2)]
        let darkColors = [Color.brown.opacity(0.3), Color.green.opacity(0.4)]
        return colorScheme == .dark ? darkColors : lightColors
    }

    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.2) 
    }

    private var completionIndicator: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                taskManager.toggleTaskCompletion(task)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(task.isCompleted ? Color.green.opacity(0.3) : Color.yellow.opacity(0.2))
                    .frame(width: 36, height: 36)

                Circle()
                    .stroke(task.isCompleted ? Color.green : Color.yellow, lineWidth: 2)
                    .frame(width: 36, height: 36)

                if task.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.green)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var dueDateLabel: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .font(.system(size: 12))
                .foregroundColor(task.dueDate < Date() ? .red : .green)

            Text(task.dueDate.formatted(.dateTime.day().month().year()))
                .foregroundColor(task.dueDate < Date() ? .red : .green)
        }
    }

    private var categoryLabel: some View {
        Text(task.category.rawValue)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.green.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(Color.green.opacity(0.4), lineWidth: 1)
                    )
            )
            .foregroundColor(.green)
    }

    private var editButton: some View {
        Button(action: {
            showingEditView.toggle()
        }) {
            Image(systemName: "pencil.circle.fill")
                .font(.title2)
                .foregroundColor(Color.yellow)
                .opacity(0.9)
        }
        .sheet(isPresented: $showingEditView) {
            TaskEditView(task: task)
                .environmentObject(taskManager)
        }
    }

    private var deleteButton: some View {
        Button(action: {
            withAnimation {
                taskManager.deleteTask(task)
            }
        }) {
            Image(systemName: "trash.circle.fill")
                .font(.title2)
                .foregroundColor(.red)
                .opacity(0.9)
        }
        .buttonStyle(.plain)
    }
}
