//
//  CoreDataAccess.swift
//  kanbanize
//
//  Created by Peter Ho on 5/16/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAccess {
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "kanbanize")
        
        let appName = "kanbanize"
        var persistentStoreDescriptions: NSPersistentStoreDescription
        
        let storeUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.kanbanize")!.appendingPathComponent("kanbanize.sqlite")
        
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.kanbanize")!.appendingPathComponent("kanbanize.sqlite"))]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    /*func saveContext () {
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
    }*/
}
