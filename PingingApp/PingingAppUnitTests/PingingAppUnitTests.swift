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
        getter = IpGetter()
        pinger = Pinger()
    }

    override func tearDown() {
        getter = nil
        pinger = nil
    }

    func testRetrievedIp() {
        let retrievedIp = getter.getIPAddress()
        let ipParts = retrievedIp.split(separator: ".")
        XCTAssertEqual(ipParts.count, 3)
    }
    
    func testGeneratedIp(){
        pinger.generateIpAddresses(startingAddress: getter.getIPAddress())
        XCTAssertEqual(IpStorage.initialIpArray.count, 255)
    }

    func testIpStructure(){
        var ipObj = Ip()
        ipObj.ipAddress = "123.456.789.1011"
        XCTAssertEqual(ipObj.ipNumber, 1011)
    }
    
    func testGeneratedIpObj(){
        IpStorage.isStopped = false
        pinger.generateIpAddresses(startingAddress: getter.getIPAddress())
        pinger.startPinging()
        let expect = expectation(description: "Wait to get ip obj")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        XCTAssertGreaterThan(IpStorage.ipObjArray.count, 0)
        IpStorage.ipObjArray.sort {$0.ipNumber < $1.ipNumber}
        XCTAssertEqual(IpStorage.ipObjArray[0].ipAddress, "\(getter.getIPAddress())1")
        XCTAssertEqual(IpStorage.ipObjArray[0].ipNumber, 1)
    }
    
    func testUpdateIpObjList(){
        pinger.updateIpObjList(ipAddress: "123.456.789.1011", status: 1)
        pinger.updateIpObjList(ipAddress: "123.456.789.1012", status: 2)
        
        XCTAssertGreaterThan(IpStorage.ipObjArray.count, 0)
        
        XCTAssertEqual(IpStorage.ipObjArray[0].ipAddress, "123.456.789.1011")
        XCTAssertEqual(IpStorage.ipObjArray[1].ipAddress, "123.456.789.1012")
        
        XCTAssertTrue(IpStorage.ipObjArray[0].reachable)
        XCTAssertFalse(IpStorage.ipObjArray[1].reachable)
    }
    
    func testGetIpAddress(){
        IpStorage.isStopped = false
        pinger.generateIpAddresses(startingAddress: getter.getIPAddress())
        XCTAssertEqual(pinger.getIpAddress(idx: 0), "\(getter.getIPAddress())1")
        
        IpStorage.isStopped = true
        XCTAssertEqual(pinger.getIpAddress(idx: 0), "stop")
    }

}
