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
            _newTask = State(initialValue: task ?? Task(
                title: "",
                dueDate: Date(),
                category: .work,
                isCompleted: false,
                priority: .medium,
                description: ""
            ))
        }


    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemTeal).opacity(0.1), Color(.systemIndigo).opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                Form {
                    Section(header: Text("Основное")
                        .font(.headline)
                        .foregroundColor(.primary)
                    ) {
                        TextField("Название задачи", text: $newTask.title)
                            .padding()
                            .background(adaptiveBackground)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                        
                        TextField("Описание", text: Binding(
                            get: { newTask.description ?? "" },
                            set: { newTask.description = $0 }
                        ))
                        .padding()
                        .background(adaptiveBackground)
                        .cornerRadius(8)
                        .shadow(radius: 4)

                        
                        DatePicker("Дата выполнения", selection: $newTask.dueDate, displayedComponents: .date)
                            .padding()
                            .background(adaptiveBackground)
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
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(newTask.title.isEmpty ? "Новая задача" : "Редактирование")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        if taskManager.tasks.contains(where: { $0.id == newTask.id }) {
                            taskManager.updateTask(newTask)
                        } else {
                            taskManager.addTask(newTask)
                        }
                        dismiss()
                    }
                    .disabled(newTask.title.isEmpty)
                    .foregroundColor(.blue)
                }
            }
        }
    }
    

    private var adaptiveBackground: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.systemBackground
        })
    }
}

#Preview {
    TaskEditView()
        .environmentObject(TaskManager())
}
