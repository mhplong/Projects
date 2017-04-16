//
//  WashingMachine_should.swift
//  DayUtility
//
//  Created by Mark Long on 4/15/17.
//  Copyright © 2017 Mark Long. All rights reserved.
//

import XCTest
import CoreData
@testable import DayUtility

class WashingMachine_should: XCTestCase {

    var machine : WashingMachine!
    var managedObjectContext : NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        machine = WashingMachine()
        setupCoreDataContext()
    }
    
    func setupCoreDataContext() {
        let managedModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])
        let persistantStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel!)
        
        do {
            try persistantStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-store persistant store failed")
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistantStoreCoordinator
    }
    
    func setupLoad(size: Int) -> Load {
        let load = Load(context: managedObjectContext)
        
        for _ in [0..<size] {
            load.addToClothings(Clothing(context: managedObjectContext))
        }
        
        return load
    }
    
    func verifyLoadCleaned(_ load: Load) {
        let clothings = load.clothings?.allObjects as! [Clothing]
        for cloth in clothings {
            XCTAssertNotNil(cloth.lastworn)
        }
    }
    
    func test_wash_single_clothing() {
        let shirt = setupLoad(size: 1)
        
        let load = machine.wash(shirt)
        
        verifyLoadCleaned(load)
    }
    
    func test_wash_load_clothing() {
        let shirts = setupLoad(size: 3)
        
        let load = machine.wash(shirts)
        
        verifyLoadCleaned(load)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
