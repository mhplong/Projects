//
//  Session.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/11/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import Foundation
import CoreData


class Session: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var date: NSDate?
    @NSManaged var moments: NSOrderedSet?
    @NSManaged var session: Session?
    
// Insert code here to add functionality to your managed object subclass

    init?(insertIntoManagedObjectContext context: NSManagedObjectContext) {
        if let desc = NSEntityDescription.entityForName("Session", inManagedObjectContext: context) {
            super.init(entity: desc, insertIntoManagedObjectContext: context)
        } else {
            print("Error creating Session")
            return nil
        }
    }
}
