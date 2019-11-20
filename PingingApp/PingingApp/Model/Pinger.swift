//
//  Pinger.swift
//  PingingApp
//
//  Created by Martynq on 12/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import Foundation
import GBPing


class Pinger : NSObject {
    private let NUMBER_OF_PINGERS : Int = 10
    private let NUMBER_OF_PINGS : Int = 1
    private let NUMBER_OF_IP : Int = 255
    
    func generateIpAddresses(startingAddress: String){
        for i in 1...NUMBER_OF_IP{
            let currentAddr = "\(startingAddress)\(i)"
            var pingableIp = PingableIp(ipAddress: currentAddr, pinged: false)
            pingableIp.ipAddress = currentAddr
            IpStorage.initialIpArray.append(pingableIp)
        }
    }

    func startPinging(){
        IpStorage.isStopped = false
        DispatchQueue.concurrentPerform(iterations: NUMBER_OF_PINGERS) { (int) in
            let objCPing = ObjCPinger()
            objCPing.prepareObject()
            objCPing.pingHost(IpStorage.initialIpArray[int].ipAddress, int, NUMBER_OF_PINGS)
            IpStorage.initialIpArray[int].pinged = true
        }
    }
    
     @objc public func updateIpObjList(ipAddress: String, status: Int){
        if let foundIpIdx = IpStorage.ipObjArray.firstIndex(where: {$0.ipAddress == ipAddress}){
            var foundIp = IpStorage.ipObjArray[foundIpIdx]

            if !foundIp.reachable{
                foundIp.reachable = status == 1 ? true : false
            }
            IpStorage.ipObjArray[foundIpIdx] = foundIp
        }
        else{
            var ipObj = Ip()
            ipObj.ipAddress = ipAddress
            ipObj.reachable = status == 1 ? true : false
            IpStorage.ipObjArray.append(ipObj)
        }
    }
    
    @objc public func getIpAddress(idx: Int) -> String{        
        if IpStorage.isStopped {
            return "stop"
        }
        
        if let foundIpIdx = IpStorage.initialIpArray.firstIndex(where: {$0.pinged == false}){
            IpStorage.initialIpArray[foundIpIdx].pinged = true
            if foundIpIdx == 254{
                IpStorage.isStopped = true
            }
            return IpStorage.initialIpArray[foundIpIdx].ipAddress
        }

        return "stop"
        
    }
}
