//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import SwiftUI

struct TaskDetailView: View {
    var task: Task
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) var dismiss
    @State private var showingEditScreen = false // For modal window
    
    var body: some View {
        VStack(spacing: 20) {
            headerSection
            Divider().padding(.horizontal)
            detailsSection
            Spacer()
            actionButtons
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemTeal).opacity(0.1), Color(.systemIndigo).opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Детали задачи")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditScreen) {
            TaskEditView(task: task) // Edit modal
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.title.bold())
                .foregroundColor(.primary)
            
            Text("Описание")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoRow(title: "Дата", value: task.dueDate.formatted(date: .abbreviated, time: .omitted))
            InfoRow(title: "Категория", value: task.category.rawValue)
            InfoRow(title: "Приоритет", value: Priority.high.rawValue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pink.mix(with: .white, by: 0.5))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                showingEditScreen = true // Activate modal
            } label: {
                Label("Редактировать", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Button(role: .destructive) {
                taskManager.deleteTask(task)
                dismiss()
            } label: {
                Label("Удалить", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
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
}
