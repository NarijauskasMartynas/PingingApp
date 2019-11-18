//
//  PingingAppUnitTests.swift
//  PingingAppUnitTests
//
//  Created by Martynq on 17/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import XCTest
@testable import PingingApp

class PingingAppUnitTests: XCTestCase {

    var pinger : Pinger!
    var getter : IpGetter!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        getter = IpGetter()
        pinger = Pinger()
    }

    override func tearDown() {
        getter = nil
        pinger = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRetrievedIp() {
        //Testing the pattern of received ip, should be XX.XX.XX.
        let retrievedIp = getter.getIPAddress()
        let ipParts = retrievedIp.split(separator: ".")
        XCTAssertEqual(ipParts.count, 3)
    }
    
    func testGeneratedIp(){
        //Testing the amount of ip addresses generated
        pinger.generateIpAddresses(startingAddress: getter.getIPAddress())
        XCTAssertEqual(pinger.initialIpArray.count, 255)
    }

    func testIpStructure(){
        //Testing the last part of ip (for sorting)
        let ipObj = Ip()
        ipObj.ipAddress = "123.456.789.1011"
        XCTAssertEqual(ipObj.ipNumber, 1011)
    }
    
    func testGeneratedIpObj(){
        //Testing the generated object.
        pinger.isStopped = false
        pinger.generateIpAddresses(startingAddress: "123.456.789.")
        pinger.mockPing(currentIndex: 0)
        let expect = expectation(description: "Wait to get ip obj")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 4)
        XCTAssertGreaterThan(self.pinger.ipObjArray.count, 0)
        XCTAssertEqual(self.pinger.ipObjArray[0].ipAddress, "123.456.789.1")
        XCTAssertEqual(self.pinger.ipObjArray[0].ipNumber, 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            pinger.generateIpAddresses(startingAddress: getter.getIPAddress())
        }
    }

}
