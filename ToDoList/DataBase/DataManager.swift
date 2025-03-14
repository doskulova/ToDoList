//
//  DataManager.swift
//  ToDoList
//
//  Created by Alina Doskulova on 28/2/25.
//
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() {}
    var controller : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListDB")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context : NSManagedObjectContext {
        controller.viewContext
    }
    
    func save() {
        if context.hasChanges {
                try? context.save()
        }
    }
    
    func saveTask(name : String, date : Date, category : String) {
        let task = TasksEntity(context: context)
        task.id = UUID()
        task.category = category
        task.text = name
        task.time = date
        save()
    }
    
    func deleteTask(id : UUID) {
        
    }
    
    func fetchTask() -> [Task]{
        let request : NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        let tasks = try? context.fetch(request)
        let result = tasks?.map{Item in
            Task(id: Item.id, title: Item.text, dueDate: Item.time, category: .personal)
        }
        return result ?? []
    }
}

