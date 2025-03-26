//
//  ViewExtensions.swift
//  ToDoList
//
//  Created by Alina Doskulova on 26/3/25.
//

import SwiftUI

// Расширение для View с методом softNeumorphism
extension View {
    func softNeumorphism(colorScheme: ColorScheme) -> some View {
        self
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.white.opacity(0.8),
                radius: 10, x: -5, y: -5
            )
            .shadow(
                color: colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1),
                radius: 10, x: 5, y: 5
            )
    }
}
