//
//  ViewController.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/11/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testDatabase()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func testDatabase() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let dbContext = delegate.managedObjectContext
            
            if let e1 = Session(insertIntoManagedObjectContext: dbContext) {
                e1.name = "Test Session"
                e1.date = NSDate()
                
                var moments = [Moment]()
                
                if let start = Moment(insertIntoManagedObjectContext: dbContext) {
                    start.name = "start"
                    start.start_time = NSDate()
                    sleep(1)
                    start.end_time = NSDate()
                    moments.append(start)
                }
                
                sleep(2)
                
                if let finish = Moment(insertIntoManagedObjectContext: dbContext) {
                    finish.name = "finish"
                    finish.start_time = NSDate()
                    sleep(6)
                    finish.end_time = NSDate()
                    moments.append(finish)
                }
                
                e1.moments = NSOrderedSet(array: moments)
                
                print("\(e1.name!): \(dateToString(e1.date!))")
                for elem in e1.moments! {
                    let ment = elem as! Moment
                    let start = dateToString(ment.start_time!)
                    let end = dateToString(ment.end_time!)
                    let interval = ment.end_time?.timeIntervalSinceDate(ment.start_time!)
                    let elapsed = dateToString(NSDate(timeIntervalSinceReferenceDate: interval!), elapsed: true)
                    print("\(ment.name!): \(start) to \(end) Elapsed:\(elapsed)")
                }
            }
        }
    }
    
    func dateToString(date: NSDate, elapsed: Bool = false) -> String {
        let dateFormatter = NSDateFormatter()
        if elapsed {
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        } else {
            dateFormatter.dateFormat = "hh:mm:ss"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
        }
        
        return dateFormatter.stringFromDate(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

