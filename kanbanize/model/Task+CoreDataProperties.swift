//
//  Task+CoreDataProperties.swift
//  kanbanize
//
//  Created by Peter Ho on 4/23/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var board: String?
    @NSManaged public var detail: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var label: String?
    @NSManaged public var name: String?
    @NSManaged public var order: Int32
    @NSManaged public var status: String?

}
