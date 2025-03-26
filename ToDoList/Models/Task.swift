//
//  Task.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//

import Foundation

struct Task: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var dueDate: Date
    var category: Category
    var isCompleted: Bool
    var priority: Priority
    var description: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        dueDate: Date = Date(),
        category: Category = .personal,
        isCompleted: Bool = false,
        priority: Priority = .low,
        description: String? = nil
    )
    {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.category = category
        self.isCompleted = isCompleted
        self.priority = priority
        self.description = description
        
    }
    mutating func update(title: String, description: String, dueDate: Date, category: Category, priority: Priority) {
           self.title = title
           self.description = description
           self.dueDate = dueDate
           self.category = category
           self.priority = priority
        
       }
    
}
