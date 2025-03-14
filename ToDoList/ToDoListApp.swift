//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//
import SwiftUI

@main
struct ToDoListApp: App {
    @StateObject private var taskManager = TaskManager()
    @StateObject var settings = Settings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskManager)
                .environmentObject(settings)
                .preferredColorScheme(settings.selectedTheme.colorScheme)
        }
    }
}


extension Settings.Theme {
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
