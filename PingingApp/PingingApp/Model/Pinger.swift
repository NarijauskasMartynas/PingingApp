//
//  Pinger.swift
//  PingingApp
//
//  Created by Martynq on 12/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import Foundation
import PlainPing

class Pinger {
    
    private var startingArray : [String] = []
    private var isStopped : Bool = true
    private var ipArray : [Ip] = []
    
    func generateIpAddresses(startingAddress: String){
        for i in 1...254{
            var currentAddr = "\(startingAddress)\(i)"
            startingArray.append(currentAddr)
        }
    }
    
    public func pingNext(test : Int, url : String) {
            print("start of ping next")
            print(url)
            
//            if isStopped{
//                return
//            }
    //
    //        if firstIteration{
    //            currentIndex = currentIndex + test
    //            print(currentIndex)
    //            print(test)
    //        }
            let currentAddress = url
            let ipObj = Ip()
            
            ipObj.ipAddress = "\(currentAddress) : thread: \(test)"
            let ping = currentAddress
            PlainPing.ping(url, withTimeout: 3, completionBlock: { (timeElapsed:Double?, error:Error?) in
                if timeElapsed != nil {
                    ipObj.reachable = true
                    print("******************************")
                }
                else{
                    ipObj.reachable = false
                    print("Rip")
                }
                self.ipArray.append(ipObj)
                print("got in")
//                DispatchQueue.main.async {
//                    self.ProgressView.setProgress(Float(self.ipArray.count) / Float(255), animated: true)
//                    self.tableView.reloadData()
//                }
                
                //self.pingNext(test: test, firstIteration: false)

            })
            
            if(ipObj.reachable){
                //pingNext(test: test, firstIteration: true)
            }
                

        }
        
}
