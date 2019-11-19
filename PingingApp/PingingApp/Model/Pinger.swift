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
    private let NUMBER_OF_PINGS : Int = 3
    private let NUMBER_OF_IP : Int = 255
    
    public var ipObjArray : [Ip] = []
    public var isStopped = true
        
    func generateIpAddresses(startingAddress: String){
        for i in 1...NUMBER_OF_IP{
            let currentAddr = "\(startingAddress)\(i)"
            let pingableIp = PingableIp()
            pingableIp.ipAddress = currentAddr
            IpStorage.initialIpArray.append(pingableIp)
        }
    }

    func startPinging(){
        isStopped = false
        DispatchQueue.concurrentPerform(iterations: NUMBER_OF_PINGERS) { (int) in
            //mockPing(currentIndex: int)
            let objCPing = ObjCPinger()
            objCPing.prepareObject()
            objCPing.pingHost(IpStorage.initialIpArray[int].ipAddress, int)
            IpStorage.initialIpArray[int].pinged = true
        }
    }
    
     @objc public func updateIpObjList(ipAddress: String, status: Int){
        print("OMG VEIKIA ipas: \(ipAddress) and status: \(status)")
        
        if let foundIpIdx = IpStorage.ipObjArray.firstIndex(where: {$0.ipAddress == ipAddress}){
            let foundIp = IpStorage.ipObjArray[foundIpIdx]

            if !foundIp.reachable{
                foundIp.reachable = status == 1 ? true : false
            }
            IpStorage.ipObjArray[foundIpIdx] = foundIp
        }
        else{
            let ipObj = Ip()
            ipObj.ipAddress = ipAddress
            ipObj.reachable = status == 1 ? true : false
            IpStorage.ipObjArray.append(ipObj)
        }
    }
    
    @objc public func getIpAddress(idx: Int) -> String{
        print("GET IP ADDRESS CALLED")
        
        if let foundIpIdx = IpStorage.initialIpArray.firstIndex(where: {$0.pinged == false}){
            IpStorage.initialIpArray[foundIpIdx].pinged = true
            return IpStorage.initialIpArray[foundIpIdx].ipAddress
        }
    
        isStopped = true
        return "-1"
    }
    
    //    func mockPing(currentIndex: Int){
    //        if isStopped{
    //            return
    //        }
    //
    //        if initialIpArray.count <= currentIndex{
    //            isStopped = true
    //            return
    //        }
    //
    //        let ipObj = Ip()
    //            //imitation of ping
    //        let secondsToWait = Double(1.0 + (Float(currentIndex) / 10))
    //        print("Seconds \(secondsToWait)")
    //        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToWait) {
    //            if self.initialIpArray.count <= currentIndex{
    //                self.isStopped = true
    //                return
    //            }
    //            ipObj.ipAddress = self.initialIpArray[currentIndex]
    //            ipObj.reachable = Bool.random()
    //
    //            self.ipObjArray.append(ipObj)
    //            self.initialIpArray.remove(at: currentIndex)
    //            self.delegate?.updateUI()
    //            self.mockPing(currentIndex: currentIndex)
    //        }
    //
    //    
}
