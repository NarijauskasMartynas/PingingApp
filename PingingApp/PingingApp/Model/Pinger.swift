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
    func updateTableView()
}

class Pinger : NSObject, GBPingDelegate {
    private let NUMBER_OF_PINGERS : Int = 10
    private let NUMBER_OF_PINGS : Int = 3
    private let NUMBER_OF_IP : Int = 255
    
    var delegate : UpdateIpListDelegate?
    
    var isStopped = true
    private var initialIpArray : [String] = []
    var ipObjArray : [Ip] = []

    
    func generateIpAddresses(startingAddress: String){
        for i in 1...NUMBER_OF_IP{
            let currentAddr = "\(startingAddress)\(i)"
            initialIpArray.append(currentAddr)
        }
        print("Pradinio dydis: \(initialIpArray.count)")
    }

        // Do any additional setup after loading the view, typically from a nib.
    func startPinging(){
        print("Start Pinging")
        DispatchQueue.concurrentPerform(iterations: NUMBER_OF_PINGERS) { (int) in
            mockPing(currentIndex: int)
        }
        
    }
    
    func mockPing(currentIndex: Int){
        if initialIpArray.count <= currentIndex{
                return
            }
        let ipObj = Ip()
            //imitation of ping
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("inside")
            if self.initialIpArray.count <= currentIndex{
                return
            }
            ipObj.ipAddress = self.initialIpArray[currentIndex]
            ipObj.reachable = Bool.random()
            
            self.ipObjArray.append(ipObj)
            self.initialIpArray.remove(at: currentIndex)
            self.delegate?.updateTableView()
            self.mockPing(currentIndex: currentIndex)
        }
       
    }
    
//
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
