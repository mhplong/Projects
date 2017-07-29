//
//  Moment.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/11/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import Foundation
import CoreData


class Moment: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var end_time: NSDate?
    @NSManaged var start_time: NSDate?

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(insertIntoManagedObjectContext context: NSManagedObjectContext) {
        if let desc = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context) {
            super.init(entity: desc, insertIntoManagedObjectContext: context)
        } else {
            print("Error creating Moment")
            return nil
        }
    }
    
}
