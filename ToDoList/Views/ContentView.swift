//
//  ContentView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var settings: Settings
    @State private var showingAddTask = false
    @State private var searchQuery = ""
    @State private var showCompleted = true
    
    // Определите основной цвет
    private let primaryColor = Color.pink
    
    var filteredTasks: [Task] {
        taskManager.tasks.filter { task in
            (searchQuery.isEmpty || task.title.lowercased().contains(searchQuery.lowercased())) &&
            (showCompleted || !task.isCompleted)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Поиск и фильтрация
                searchAndFilterView
                
                // Задачи или пустое состояние
                if filteredTasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("Tasks".localized())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24))
                            .foregroundColor(primaryColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskEditView()
                    .presentationDetents([.medium, .large])
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [primaryColor.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .overlay(
                addButton,
                alignment: .bottomTrailing
            )
        }
        .preferredColorScheme(settings.selectedTheme.colorScheme)
    }
    
    private var taskListView: some View {
        List {
            ForEach(filteredTasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    TaskRowView(task: task)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        taskManager.toggleTaskCompletion(task)
                    } label: {
                        Label("Done", systemImage: "checkmark.circle.fill")
                    }
                    .tint(primaryColor)
                    
                    Button(role: .destructive) {
                        taskManager.deleteTask(task)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: deleteTask)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundColor(primaryColor)
            
            Text("No tasks yet")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Tap the + button to add your first task!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var addButton: some View {
        Button(action: {
            showingAddTask = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(primaryColor)
                .shadow(color: primaryColor.opacity(0.6), radius: 8, x: 0, y: 4)
        }
        .padding()
    }
    
    private var searchAndFilterView: some View {
        VStack {
            // Поиск
            TextField("Search tasks...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .top])
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // Фильтрация
            Toggle(isOn: $showCompleted) {
                Text("Show Completed Tasks")
                    .font(.subheadline)
            }
            .padding([.horizontal])
            .tint(primaryColor)
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                taskManager.deleteTask(taskManager.tasks[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(Settings())
}
