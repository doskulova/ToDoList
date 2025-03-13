//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    func addTask(_ task: Task) {
        tasks.append(task)
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    func filterTasks(by category: Category) -> [Task] {
        tasks.filter { $0.category == category }
    }
}
