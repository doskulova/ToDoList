//
//  TaskListView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 25/3/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    let filteredTasks: [Task]
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Фоновый градиент
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            TaskRowView(task: task)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            taskManager.deleteTask(task)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .scale.combined(with: .opacity)
                                ))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: filteredTasks)
    }
    
    private var gradientColors: [Color] {
        if colorScheme == .dark {
            return [Color("0A431D"), Color("122620")]
        } else {
            return [Color("F8F9FF"), Color("E8F3FF")]
        }
    }
}
