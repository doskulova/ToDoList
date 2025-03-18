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
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func saveTask(name: String, date: Date, category: String, priority: String, isCompleted: Bool) {
        let task = TasksEntity(context: context)
        task.id = UUID()
        task.category = category
        task.text = name
        task.time = date
        task.priority = priority
        task.isCompleted = isCompleted
        save()
    }

    
    func deleteTask(id: UUID) {
        let request: NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasksToDelete = try context.fetch(request)
            if tasksToDelete.isEmpty {
                print("No task found with ID: \(id)")
            } else {
                for task in tasksToDelete {
                    context.delete(task)
                }
                save()
            }
        } catch {
            print("Failed to delete task with ID \(id): \(error.localizedDescription)")
        }
    }
    
    
    func fetchTask() -> [Task] {
        let request: NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        do {
            let tasks = try context.fetch(request)
            return tasks.compactMap { item in
                guard
                    let category = Category(rawValue: item.category),
                    let priority = Priority(rawValue: item.priority)
                else {
                    return nil
                }
                return Task(
                    id: item.id,
                    title: item.text,
                    dueDate: item.time,
                    category: category,
                    isCompleted: item.isCompleted,
                    priority: priority
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }
}

