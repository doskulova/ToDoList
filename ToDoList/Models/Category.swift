//
//  Category.swift
//  ToDoList
//
//  Created by Alina Doskulova on 17/2/25.
//



enum Category: String, CaseIterable, Identifiable, Codable {
    case work = "Работа"
    case personal = "Личное"
    case shopping = "Покупки"
    
    var id: String { self.rawValue }
}

