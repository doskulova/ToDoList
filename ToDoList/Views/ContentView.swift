//
//  b.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(taskManager.tasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        VStack(alignment: .leading) {
                            Text(task.title)
                            Text(task.dueDate, style: .date)
                                .font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Tasks")
            .toolbar {
                Button(action: { showingAddTask = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = taskManager.tasks[index]
            taskManager.deleteTask(task)
        }
    }
}
#Preview {
    ContentView()
}
