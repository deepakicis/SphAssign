//
//  DataTests.swift
//  SphAssignmentTests
//
//  Created by Deepak Kumar on 1/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import XCTest
@testable import SphAssignment

class cacheTests: XCTestCase {
    
    var record : Record? = nil
    var usageDetail : DataDetail? = nil
    
    override func setUp() {
        let json = ["volume_of_mobile_data":"0.248899", "quarter":"2008-Q2", "_id":1] as [String : AnyObject]
        self.record = Record(json: json)
        self.usageDetail = DataDetail(record: self.record!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseManager.clearData()
    }
    
    func testDatabaseManager() {
        self.addConsumption()
        self.getConsumption()
        self.getConsumptionByYear(year: 2004)
    }
    
    func addConsumption() {
        DatabaseManager.addData(dataProvided: self.usageDetail!)
    }
    
    func getConsumption() {
        let _ = DatabaseManager.getData()
    }
    
    func getConsumptionByYear(year: Int) {
        let _ = DatabaseManager.getData(year: year)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
