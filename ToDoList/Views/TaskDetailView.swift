//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import SwiftUI

struct TaskDetailView: View {
    var task: Task?
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var settings: Settings
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme 
    @State private var showingEditScreen = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let task = task {
                    headerSection(task: task)
                    Divider().padding(.horizontal)
                    detailsSection(task: task)
                    Spacer()
                    actionButtons(task: task)
                } else {
                    Text("Задача не найдена")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .ignoresSafeArea()
        )
        .navigationTitle("Детали задачи")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditScreen) {
            TaskEditView(task: task)
        }
    }

    private func headerSection(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.title.bold())
                .foregroundColor(task.isCompleted ? .secondary : .primary)
                .strikethrough(task.isCompleted, color: .secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let description = task.description, !description.isEmpty {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Описание отсутствует")
                    .font(.body.italic())
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                .shadow(color: shadowColor, radius: 8, x: 0, y: 2)
        )
    }

    private func detailsSection(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoRow(title: "Дата", value: task.dueDate.formatted(date: .abbreviated, time: .omitted))
            InfoRow(title: "Категория", value: task.category.rawValue)
            InfoRow(title: "Приоритет", value: task.priority.rawValue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        )
    }

    private func actionButtons(task: Task) -> some View {
        HStack(spacing: 16) {
            Button {
                showingEditScreen = true
            } label: {
                Label("Редактировать", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                    .foregroundColor(.white)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }

            Button(role: .destructive) {
                taskManager.deleteTask(task)
                dismiss()
            } label: {
                Label("Удалить", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.9))
                    )
                    .foregroundColor(.white)
                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, 20)
    }

    private struct InfoRow: View {
        let title: String
        let value: String

        var body: some View {
            HStack {
                Text(title + ":")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text(value)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }

    private var gradientColors: [Color] {
        let lightColors = [Color.green.opacity(0.1), Color.yellow.opacity(0.1)]
        let darkColors = [Color.brown.opacity(0.3), Color.green.opacity(0.2)]
        return colorScheme == .dark ? darkColors : lightColors
    }

    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.4) : Color.gray.opacity(0.2)
    }
}
