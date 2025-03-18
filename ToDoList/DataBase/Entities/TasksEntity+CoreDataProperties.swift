//
//  TasksEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Alina Doskulova on 28/2/25.
//
//

import Foundation
import CoreData


extension TasksEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksEntity> {
        return NSFetchRequest<TasksEntity>(entityName: "Tasks")
    }

    @NSManaged public var text: String
    @NSManaged public var time: Date
    @NSManaged public var id: UUID
    @NSManaged public var category: String
    @NSManaged public var priority: String
    @NSManaged public var isCompleted: Bool
}

extension TasksEntity: Identifiable {}
