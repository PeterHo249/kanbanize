//
//  Board+CoreDataProperties.swift
//  kanbanize
//
//  Created by Peter Ho on 4/23/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//
//

import Foundation
import CoreData


extension Board {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Board> {
        return NSFetchRequest<Board>(entityName: "Board")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameOrder: Int32

}
