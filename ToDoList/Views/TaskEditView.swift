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
    @State private var title: String
    @State private var taskDescription: String
    @State private var dueDate: Date
    @State private var category: Category
    @State private var priority: Priority
    private var task: Task?
    
    init(task: Task? = nil) {
        self.task = task
        _title = State(initialValue: task?.title ?? "")
        _taskDescription = State(initialValue: task?.description ?? "")
        _dueDate = State(initialValue: task?.dueDate ?? Date())
        _category = State(initialValue: task?.category ?? .work)
        _priority = State(initialValue: task?.priority ?? .medium)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Основное").font(.headline).foregroundColor(.primary)) {
                    TextField("Название задачи", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 8)
                    
                    TextField("Описание", text: $taskDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 8)
                    
                    DatePicker("Дата выполнения", selection: $dueDate, displayedComponents: .date)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Детали").font(.headline).foregroundColor(.primary)) {
                    Picker("Категория", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                    
                    Picker("Приоритет", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle(title.isEmpty ? "Новая задача" : "Редактирование")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveTask()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func saveTask() {
        if let task = task {
            taskManager.updateTask(
                task,
                title: title,
                description: taskDescription, // Передаем описание
                dueDate: dueDate,
                category: category,
                priority: priority
            )
        } else {
            let newTask = Task(
                title: title,
                dueDate: dueDate,
                category: category,
                priority: priority,
                description: taskDescription
            )
            taskManager.addTask(newTask)
        }
    }

}
