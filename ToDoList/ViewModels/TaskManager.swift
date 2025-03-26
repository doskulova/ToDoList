//
//  TaskManager.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import Combine
import Foundation
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
            DataManager.shared.updateTaskCompletion(id: task.id, isCompleted: tasks[index].isCompleted)
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        DataManager.shared.deleteTask(id: task.id)
    }
    
    func deleteTask(at indices: IndexSet) {
            indices.forEach { index in
                let task = tasks[index]
                DataManager.shared.deleteTask(id: task.id)
            }
            tasks.remove(atOffsets: indices)
        }
    
    func moveTasks(from source: IndexSet, to destination: Int) {
            tasks.move(fromOffsets: source, toOffset: destination)
            
        }
    
    func updateTask(_ task: Task, title: String, description: String, dueDate: Date, category: Category, priority: Priority) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].update(title: title, description: description, dueDate: dueDate, category: category, priority: priority)
            
            DataManager.shared.updateTask(
                            id: task.id,
                            name: title,
                            date: dueDate,
                            category: category.id,
                            priority: priority.rawValue,
                            isCompleted: tasks[index].isCompleted
                        )
        }
    }
    
    func fetchTasks() {
        tasks = DataManager.shared.fetchTask()
    }
    
    init() {
        fetchTasks()
    }
}
