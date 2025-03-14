//
//  AddTask.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import SwiftUI

struct TaskEditView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) var dismiss
    @State private var newTask: Task
    
    init(task: Task? = nil) {
        _newTask = State(initialValue: task ?? Task(title: ""))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фон с градиентом
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemTeal).opacity(0.1), Color(.systemIndigo).opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Основной контент
                Form {
                    Section(header: Text("Основное")
                        .font(.headline)
                        .foregroundColor(.primary)
                    ) {
                        TextField("Название задачи", text: $newTask.title)
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                        
                        DatePicker("Дата выполнения", selection: $newTask.dueDate, displayedComponents: .date)
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                    }
                    
                    Section(header: Text("Детали")
                        .font(.headline)
                        .foregroundColor(.primary)
                    ) {
                        Picker("Категория", selection: $newTask.category) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // More visually engaging
                        .padding(.vertical)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                )
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(newTask.title.isEmpty ? "Новая задача" : "Редактирование")
            .toolbar {
                // Кнопка отмены
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                // Кнопка сохранения
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        if taskManager.tasks.contains(where: { $0.id == newTask.id }) {
                            taskManager.updateTask(newTask) //
                        } else {
                            taskManager.addTask(newTask)
                        }
                        dismiss()
                    }
                    .disabled(newTask.title.isEmpty) //
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    TaskEditView()
        .environmentObject(TaskManager())
}
