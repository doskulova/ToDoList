//
//  Category.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//



import SwiftUI

enum Category: String, CaseIterable, Identifiable, Codable {
    case work = "Работа"
    case personal = "Личное"
    case shopping = "Покупки"
    
    var id: String { self.rawValue }
}

extension Category {
    var color: Color {
        switch self {
        case .work:
            return Color(red: 0.0, green: 0.48, blue: 1.0) // Синий iOS
        case .personal:
            return Color(red: 0.2, green: 0.78, blue: 0.35) // Зеленый iOS
        case .shopping:
            return Color(red: 1.0, green: 0.58, blue: 0.0) // Оранжевый iOS
        }
    }
    
    var iconName: String {
        switch self {
        case .work:
            return "briefcase.fill"
        case .personal:
            return "heart.fill" // Более подходящая иконка для личного
        case .shopping:
            return "cart.fill"
        }
    }
    
    // Дополнительное свойство для градиента
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.8), color.opacity(0.4)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Локализованное название для интерфейса
    var localizedName: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
}
