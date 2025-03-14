//
//  Settings.swift
//  ToDoList
//
//  Created by Alina Doskulova on 21/2/25.

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en" {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("selectedTheme") var selectedTheme: Theme = .system {
        willSet {
            objectWillChange.send()
        }
    }
    
    enum Theme: String, CaseIterable {
        case light = "light.theme"
        case dark = "dark.theme"
        case system = "system.theme"
    }
}

// Поддержка RawRepresentable для Theme
extension Settings.Theme: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case "light.theme":
            self = .light
        case "dark.theme":
            self = .dark
        case "system.theme":
            self = .system
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .light:
            return "light.theme"
        case .dark:
            return "dark.theme"
        case .system:
            return "system.theme"
        }
    }
}
