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
    @State private var selectedDate: Date?
    @State private var showDatePicker = false
    
    private var primaryColor: Color {
        settings.selectedTheme == .dark ? Color(red: 0.04, green: 0.26, blue: 0.11) : .green
    }
    
    private var secondaryColor: Color {
        settings.selectedTheme == .dark ? Color(red: 0.07, green: 0.15, blue: 0.13) : .yellow.opacity(0.7)
    }
    
    // Цвета для кнопок в темной теме
    private var darkButtonText: Color {
        Color(red: 0.6, green: 0.8, blue: 0.6)
    }
    
    private var darkButtonBackground: Color {
        Color(red: 0.1, green: 0.2, blue: 0.1)
    }
    
    private var darkButtonBorder: Color {
        Color(red: 0.3, green: 0.5, blue: 0.3)
    }
    
    var filteredTasks: [Task] {
        taskManager.tasks.filter { task in
            (searchQuery.isEmpty || task.title.localizedCaseInsensitiveContains(searchQuery)) &&
            (showCompleted || !task.isCompleted) &&
            (selectedDate == nil || Calendar.current.isDate(task.dueDate, inSameDayAs: selectedDate!))
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        settings.selectedTheme == .dark ? primaryColor.opacity(0.1) : primaryColor.opacity(0.1),
                        settings.selectedTheme == .dark ? secondaryColor.opacity(0.3) : secondaryColor.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                
                VStack(spacing: 0) {
                    
                    searchAndFilterView
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .background(
                            Color(.systemBackground)
                                .softNeumorphism(colorScheme: settings.selectedTheme.colorScheme ?? .light)
                        )
                    
                    
                    if filteredTasks.isEmpty {
                        emptyStateView
                    } else {
                        TaskListView(filteredTasks: filteredTasks)
                            .frame(maxHeight: .infinity)
                    }
                }
                
                
                floatingActionButton
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsButton
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskEditView()
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(20)
                    .presentationBackground(Color(.systemBackground))
            }
            .preferredColorScheme(settings.selectedTheme.colorScheme)
        }
    }
    
    
    
    private var settingsButton: some View {
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 20))
                .foregroundColor(settings.selectedTheme == .dark ? darkButtonText : primaryColor)
                .padding(8)
                .background(
                    Circle()
                        .fill(settings.selectedTheme == .dark ? darkButtonBackground : primaryColor.opacity(0.2))
                        .softNeumorphism(colorScheme: settings.selectedTheme.colorScheme ?? .light)
                )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist.unchecked")
                .font(.system(size: 60))
                .foregroundColor(primaryColor.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No tasks found")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(settings.selectedTheme == .dark ? .white : .primary)
                
                Text("Try adjusting your filters or add a new task")
                    .font(.subheadline)
                    .foregroundColor(settings.selectedTheme == .dark ? .white.opacity(0.7) : .secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
    }
    
    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingAddTask = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            primaryColor
                                .softNeumorphism(colorScheme: settings.selectedTheme.colorScheme ?? .light)
                        )
                        .clipShape(Circle())
                        .shadow(color: primaryColor.opacity(0.4), radius: 10, x: 0, y: 5)
                        .padding(24)
                }
            }
        }
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(settings.selectedTheme == .dark ? .white : .secondary)
                
                TextField("Search tasks...", text: $searchQuery)
                    .foregroundColor(settings.selectedTheme == .dark ? .white : .primary)
                
                if !searchQuery.isEmpty {
                    Button(action: {
                        searchQuery = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(settings.selectedTheme == .dark ? .white : .secondary)
                    }
                }
            }
            .padding(10)
            .background(settings.selectedTheme == .dark ? Color(.systemGray5) : Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            
            HStack {
                
                Button(action: {
                    withAnimation {
                        showDatePicker.toggle()
                        if !showDatePicker {
                            selectedDate = nil
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(selectedDate != nil ? selectedDate!.formatted(.dateTime.day().month()) : "Any date")
                            .font(.subheadline)
                    }
                    .padding(10)
                    .foregroundColor(settings.selectedTheme == .dark ? darkButtonText : primaryColor)
                    .background(
                        settings.selectedTheme == .dark ? darkButtonBackground : Color(.secondarySystemBackground)
                    )
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(settings.selectedTheme == .dark ? darkButtonBorder : primaryColor.opacity(0.3), lineWidth: 1)
                    )
                }
                
                
                Button(action: {
                    withAnimation {
                        showCompleted.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: showCompleted ? "checkmark.circle.fill" : "circle")
                        Text("Completed")
                            .font(.subheadline)
                    }
                    .padding(10)
                    .foregroundColor(settings.selectedTheme == .dark ? darkButtonText : primaryColor)
                    .background(
                        settings.selectedTheme == .dark ? darkButtonBackground : Color(.secondarySystemBackground)
                    )
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(settings.selectedTheme == .dark ? darkButtonBorder : primaryColor.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            
            
            if showDatePicker {
                DatePicker(
                    "Filter by date",
                    selection: Binding(get: { selectedDate ?? Date() }, set: { selectedDate = $0 }),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(settings.selectedTheme == .dark ? Color(.systemGray5) : Color(.secondarySystemBackground))
                .cornerRadius(10)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(Settings())
}
