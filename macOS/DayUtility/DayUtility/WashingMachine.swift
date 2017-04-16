//
//  WashingMachine.swift
//  DayUtility
//
//  Created by Mark Long on 4/15/17.
//  Copyright © 2017 Mark Long. All rights reserved.
//

import Cocoa

class WashingMachine: NSObject {
    
    func wash(_ load : Load) -> Load {
        for cloth : Clothing in load.clothings?.allObjects as! [Clothing] {
            cloth.lastworn = NSDate()
        }
        return load
    }
    
}
