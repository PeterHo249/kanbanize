//
//  Task+CoreDataClass.swift
//  kanbanize
//
//  Created by Peter Ho on 4/23/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//
//

import Foundation
import CoreData


public class Task: NSManagedObject {
    static let entityName = "Student"
    
    static func all() -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func fetchData(sort:Bool, status:String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "status == %@", status)
        
        if sort {
            let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func create() -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: DB.MOC)
    }
}
