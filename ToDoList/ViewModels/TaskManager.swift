//
//  TaskManager.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import Combine
@MainActor
class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    
    func addTask(_ task: Task) {
        tasks.append(task)
        tasks.sort { $0.dueDate < $1.dueDate }
        DataManager.shared.saveTask(
            name: task.title,
            date: task.dueDate,
            category: task.category.id,
            priority: task.priority.rawValue,
            isCompleted: task.isCompleted
        )
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        DataManager.shared.deleteTask(id: task.id)
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func fetchTasks() {
        tasks = DataManager.shared.fetchTask()
    }
    
    init() {
        fetchTasks()
    }
}
