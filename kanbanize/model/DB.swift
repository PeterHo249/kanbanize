//
//  DB.swift
//  kanbanize
//
//  Created by Peter Ho on 4/18/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DB {
    static var MOC: NSManagedObjectContext {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //return appDelegate.persistentContainer.viewContext
        return CoreDataAccess.persistentContainer.viewContext
    }
    
    static func Save() {
        if MOC.hasChanges {
            do {
                try MOC.save()
            }
            catch let error as NSError {
                print("Cannot save db \(error)")
            }
        }
    }
}
