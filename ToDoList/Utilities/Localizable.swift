//
//  Localizable.swift
//  ToDoList
//
//  Created by Alina Doskulova on 21/2/25.
//
import SwiftUI

extension String {
    func localized(bundle: Bundle = .main) -> String {
        NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
