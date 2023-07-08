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
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
        saveContext()
        
        completion?(task)
    }
    
    func updateTask(_ task: Task, withNewName name: String) {
        task.title = name
        saveContext()
    }
    
    func deleteTask(_ task: Task) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



