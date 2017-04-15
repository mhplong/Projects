//
//  WashingMaching_Test.swift
//  DayUtility
//
//  Created by Mark Long on 4/15/17.
//  Copyright © 2017 Mark Long. All rights reserved.
//

import XCTest
@testable import DayUtility

class WashingMachine_Test: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_mulitply_2_by_2() {
        //prepare
        let two = 2
        
        //action
        let result = two * two
        
        //verify
        verifyIntTrue(expected: 4, actual: result)
    }
    
    func test_intializeWashingMachine() {
        let machine = WashingMachine()
        
        XCTAssertNotNil(machine)
    }
    
    func verifyIntTrue(expected: Int, actual: Int) {
        XCTAssertTrue(expected == actual);
    }

}
