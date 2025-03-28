//
//  Priority.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//


enum Priority: String, CaseIterable, Identifiable, Codable {
    case none = "Нет"
    case low = "Низкий"
    case medium = "Средний"
    case high = "Высокий"
    
    
    var id: String { self.rawValue }
    
    static let defaultValue: Priority = .low
}
