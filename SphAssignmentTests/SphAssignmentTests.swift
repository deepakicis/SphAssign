//
//  SphAssignmentTests.swift
//  SphAssignmentTests
//
//  Created by Deepak Kumar on 28/6/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import XCTest
import RealmSwift
import Hippolyte
@testable import SphAssignment

class SphAssignmentTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension XCTestCase{

    func ApiGetData(offset: Int, limit: Int) -> String {
        return "https://data.gov.sg/api/action/datastore_search?offset=\(offset)&limit=\(limit)&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
    }

    func getJsonForStub(error: String) -> Data? {
        if let path = Bundle.main.path(forResource: error, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                print("error: \(error.localizedDescription)")
            }
        }
        return nil
    }
}

class NetworkError404: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let url : URL = URL(string: self.ApiGetData(offset: 0, limit: 25))!
        var stub = StubRequest(method: .GET, url: url)
        var response = StubResponse(error: NSError(domain: "https://data.gov.sg", code: 404, userInfo: [NSLocalizedDescriptionKey : Constant.serverNotFoundError]))
        response.body = self.getJsonForStub(error: "NotFound")
        stub.response = response
        
        Hippolyte.shared.clearStubs()
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Hippolyte.shared.stop()
    }
    
    func testStubForNotFound() {
        
        let expectation = self.expectation(description: "Server Not Found")
        let dataProvider = List<DataDetail>()
        DataService.APIUsageDetails(usageDetails: dataProvider, offset: 0, limit: 25) { (isCache, status, message, usageResponse) in
            if(message == Constant.serverNotFoundError){
                assert(message == Constant.serverNotFoundError)
                assert(dataProvider.count == 0)
                Hippolyte.shared.stop()
                URLSession.shared.invalidateAndCancel()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

class NetworkError500: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let url : URL = URL(string: self.ApiGetData(offset: 0, limit: 20))!
        var stub = StubRequest(method: .GET, url: url)
        var response = StubResponse(error: NSError(domain: "https://data.gov.sg", code: 500, userInfo: [NSLocalizedDescriptionKey : Constant.serverError]))
        response.body = self.getJsonForStub(error: "ServerError")
        stub.response = response
        Hippolyte.shared.clearStubs()
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Hippolyte.shared.stop()
    }
    
    func stubForInternalServerError() {
        
        let expectation = self.expectation(description: "Server Not Found")
        let dataProvider = List<DataDetail>()
        DataService.APIUsageDetails(usageDetails: dataProvider, offset: 0, limit: 25) { (isCache, status, message, usageResponse) in
            if(message == Constant.serverError){
                assert(message == Constant.serverError)
                assert(dataProvider.count == 0)
                Hippolyte.shared.stop()
                URLSession.shared.invalidateAndCancel()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

