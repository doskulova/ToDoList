//
//  AddTask.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) var dismiss
    @State private var newTask: Task
    private var isEditing: Bool
    
    // Инициализатор для создания новой задачи
    init() {
        self._newTask = State(initialValue: Task(title: ""))
        self.isEditing = false
    }
    
    // Инициализатор для редактирования существующей задачи
    init(task: Task) {
        self._newTask = State(initialValue: task)
        self.isEditing = true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название задачи", text: $newTask.title)
                    TextField("Описание", text: $newTask.description)
                }
                
                Section("Детали") {
                    DatePicker(
                        "Дата выполнения",
                        selection: $newTask.dueDate,
                        displayedComponents: .date
                    )
                    
                    Picker("Категория", selection: $newTask.category) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    Picker("Приоритет", selection: $newTask.priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Редактировать" : "Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Готово" : "Сохранить") {
                        saveTask()
                    }
                    .disabled(newTask.title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        if isEditing {
            taskManager.updateTask(newTask)
        } else {
            taskManager.addTask(newTask)
        }
        dismiss()
    }
}

