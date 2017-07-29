//
//  DateFunctions.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/13/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import Foundation


func elapsedDateToString(date: NSDate) -> String {
    return dateToString(date, elapsed: true)
}

func dateToString(date: NSDate, elapsed: Bool = false) -> String {
    let dateFormatter = NSDateFormatter()
    if elapsed {
        dateFormatter.dateFormat = "HH:mm:ss.S"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    } else {
        dateFormatter.dateFormat = "hh:mm:ss.S"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
    }
    
    return dateFormatter.stringFromDate(date)
}

func dateToElapsedDate(start: NSDate, end: NSDate) -> NSDate {
    let interval = end.timeIntervalSinceDate(start)
    return NSDate(timeIntervalSinceReferenceDate: interval)
}

func elapsedTime(fromInterval interval : NSTimeInterval, toInterval now: NSTimeInterval) -> String {
    let elapsedFormatter = NSDateFormatter()
    elapsedFormatter.dateFormat = "HH:mm:ss.S"
    elapsedFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    
    let elapsedTime = now - interval
    let intervalDate = NSDate(timeIntervalSinceReferenceDate: elapsedTime)
    
    return elapsedFormatter.stringFromDate(intervalDate)
}