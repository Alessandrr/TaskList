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
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func fetchTasks(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try viewContext.fetch(fetchRequest)
            completion(.success(taskList))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func createTask(_ taskName: String, completion: ((Task) -> Void)? = nil) {
        let task = Task(context: viewContext)
        task.title = taskName
        completion?(task)
        saveContext()
    }
    
    func updateTask(_ task: Task, withNewName name: String) {
        task.title = name
        saveContext()
    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



