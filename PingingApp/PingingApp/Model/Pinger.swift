//
//  Pinger.swift
//  PingingApp
//
//  Created by Martynq on 12/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import Foundation
import GBPing

protocol UpdateIpListDelegate{
    func updateUI()
}

class Pinger : NSObject, GBPingDelegate {
    private let NUMBER_OF_PINGERS : Int = 10
    private let NUMBER_OF_PINGS : Int = 3
    private let NUMBER_OF_IP : Int = 255
    
    internal var initialIpArray : [String] = []

    public var delegate : UpdateIpListDelegate?
    public var ipObjArray : [Ip] = []
    public var isStopped = true
    
    func generateIpAddresses(startingAddress: String){
        for i in 1...NUMBER_OF_IP{
            let currentAddr = "\(startingAddress)\(i)"
            initialIpArray.append(currentAddr)
        }
    }

    func startPinging(){
        isStopped = false
        DispatchQueue.concurrentPerform(iterations: NUMBER_OF_PINGERS) { (int) in
            mockPing(currentIndex: int)
        }
    }
    
    func mockPing(currentIndex: Int){
        if isStopped{
            return
        }
        
        if initialIpArray.count <= currentIndex{
            isStopped = true
            return
        }
        
        let ipObj = Ip()
            //imitation of ping
        let secondsToWait = Double(1.0 + (Float(currentIndex) / 10))
        print("Seconds \(secondsToWait)")
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToWait) {
            if self.initialIpArray.count <= currentIndex{
                self.isStopped = true
                return
            }
            ipObj.ipAddress = self.initialIpArray[currentIndex]
            ipObj.reachable = Bool.random()
            
            self.ipObjArray.append(ipObj)
            self.initialIpArray.remove(at: currentIndex)
            self.delegate?.updateUI()
            self.mockPing(currentIndex: currentIndex)
        }
       
    }
    
//    Lib doesn't accept IP address as HOST
//    private func ping(currentIdx: Int){
//        if ipObjArray.count >= 254{
//            isStopped = true
//            return
//        }
//
//        if isStopped{
//            return
//        }
//
//        print("Passed stops")
//        if currentIdx >= initialIpArray.count{
//            isStopped = true
//            print("STOPPPPEDDDDD*********")
//            return
//        }
//        print(currentIdx)
//        print(initialIpArray.count)
//        let currentUrl = initialIpArray[currentIdx]
//        initialIpArray.remove(at: currentIdx)
//
//        let pingInterval:TimeInterval = 3
//        let timeoutInterval:TimeInterval = 4
//
//
//        let config : PingConfiguration = {
//            return PingConfiguration(pInterval: pingInterval, withTimeout: timeoutInterval)
//        }()
//        let ip = Ip()
//        ip.ipAddress = "\(currentUrl) + \(currentIdx)"
//        SwiftPing.ping(host: currentUrl,
//            configuration: config, queue: .main) { (ping, error) in
//                if error == nil {
//                    ip.reachable = true
//                }
//
//                self.ipObjArray.append(ip)
//                self.ping(currentIdx: currentIdx)
//        }
//    }
}
