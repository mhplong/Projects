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

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(insertIntoManagedObjectContext context: NSManagedObjectContext) {
        if let desc = NSEntityDescription.entityForName("Session", inManagedObjectContext: context) {
            super.init(entity: desc, insertIntoManagedObjectContext: context)
        } else {
            print("Error creating Session")
            return nil
        }
    }
    
    func addMoment(ment: Moment) {
        var momentArray = [Moment]()
        if self.moments != nil {
            momentArray = self.moments!.array as! [Moment]
            momentArray.append(ment)
        } else {
            momentArray = [ment]
        }
        self.moments = NSOrderedSet(array: momentArray)
    }
    
    func getTotalElapsedTime() -> NSDate {
        if self.moments?.count > 0 {
            let lastMent = self.moments?.lastObject as! Moment
            let lastInterval = lastMent.end_time!.timeIntervalSinceDate(self.date!)
            return NSDate(timeIntervalSinceReferenceDate: lastInterval)
        } else {
            return NSDate(timeIntervalSinceReferenceDate: 0)
        }
    }
}
