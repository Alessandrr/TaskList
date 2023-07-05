//
//  StorageManager.swift
//  TaskList
//
//  Created by Александр Мамлыго on /57/2566 BE.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func fetchTasks() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
            return taskList
        } catch(let error) {
            print(error.localizedDescription)
            return []
        }
    }
    
    func createTask(_ taskName: String, completion: ((Task) -> Void)? = nil) {
        let task = Task(context: persistentContainer.viewContext)
        task.title = taskName
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        
        completion?(task)
    }
    
    func updateTask(_ task: Task, withNewName name: String) {
        task.title = name
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



