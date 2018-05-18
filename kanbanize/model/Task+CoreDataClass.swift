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
import UIKit


public class Task: NSManagedObject {
    static let entityName = "Task"
    
    static func All() -> [NSManagedObject] {
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
    
    static func FetchData(sort:Bool, board:String, status:String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "board == %@ AND status == %@", argumentArray: [board, status])
        
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
    
    static func FetchData(sort:Bool, board:String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "board == %@", board)
        
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
    
    static func FetchUpcomingTask() -> NSManagedObject? {
        let now = Date()
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "status == %@ OR status == %@", argumentArray: ["todo", "doing"])
        
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            if (list.count == 0) {
                return nil
            } else {
                var result = list[0]
                for record in list {
                    let recordDate = (record as! Task).dueDate! as Date
                    if (recordDate > now && recordDate < (result as! Task).dueDate! as Date) {
                        result = record
                    }
                }
                return result
            }
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    static func Create() -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: DB.MOC)
    }
    
    func ChangeStatus(status: String) {
        setValue(status, forKey: "status")
        setValue(0, forKey: "order")
        DB.Save()
    }
}
