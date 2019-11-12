//
//  ViewController.swift
//  PingingApp
//
//  Created by Martynq on 09/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit
import PlainPing
import SwiftPing

class IpListViewController: UITableViewController {

    @IBOutlet weak var StartButton: UIBarButtonItem!
    @IBOutlet weak var ProgressView: UIProgressView!

    private var ipAddress : String = ""
    private var startingArray : [String] = []
    private var ipArray : [Ip] = []
    private var currentIndex = 1
    private var isStopped = true
    private var startTime : Date = Date()
    private var endTime : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ipGetter = IpGetter()
        ipAddress = ipGetter.getIPAddress()
        generateIpAddresses(startingAddress: ipAddress)
    }
    
    func generateIpAddresses(startingAddress: String){

        startingArray.append("http://192.168.43.220")
        startingArray.append("192.168.43.220")
        startingArray.append("http://192.168.43.41")
        startingArray.append("192.168.43.41")
        startingArray.append("www.facebook.com")
        startingArray.append("www.google.com")
        
        
        for i in 1...3{
            var currentAddr = "\(startingAddress)\(i)"
            startingArray.append(currentAddr)
        }
        for i in 1...3{
            var currentAddr = "http://\(startingAddress)\(i)"
            startingArray.append(currentAddr)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ipArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IpItemCell", for: indexPath)
        
        if ipArray.count > 0 {
            cell.textLabel?.text = (ipArray[indexPath.row].ipAddress)
            let image = ipArray[indexPath.row].reachable ? UIImage(systemName: "sun.min") : UIImage(systemName: "zzz")
            cell.accessoryView = UIImageView(image: image)
        }
        else{
            cell.textLabel?.text = "lalala"
        }
        
        return cell
    }
    
    @IBAction func startPinging(_ sender: UIBarButtonItem) {
        isStopped = !isStopped
        if isStopped{
            StartButton.title = "Start"
        }
        else{
            StartButton.title = "Stop"
        }
        
        DispatchQueue.concurrentPerform(iterations: 10) { (int) in
            pingSwift(url: startingArray[int])


        }
        
        
//        let queue = DispatchQueue(label: "PingingApp", attributes: .concurrent)
//
//        queue.async {
//            self.pingNext(test: 1)
//            self.pingNext(test: 2)
//            self.pingNext(test: 3)
//            self.pingNext(test: 4)
//            self.pingNext(test: 5)
//
//        }
            //DispatchQueue.global(qos: .userInitiated).async {
//            DispatchQueue.concurrentPerform(iterations: 10) { (count) in
//                DispatchQueue.global(qos: .userInitiated).async {
//                    self.pingNext(test: count)
//                }
            //}
        
//            DispatchQueue.concurrentPerform(iterations: 10) { (count) in
//                DispatchQueue.main.async {
//                    self.pingNext(test: count, firstIteration: true)
//                }
//        }
//        let operationQueue = OperationQueue()
//        operationQueue.maxConcurrentOperationCount = 10
//        operationQueue.qualityOfService = .userInteractive
//        operationQueue.addOperation {
//            DispatchQueue.main.async {
//                print("Called")
//                self.pingNext(test: 1, firstIteration: false, url: "www.google.com")
//                self.pingNext(test: 2, firstIteration: false, url: "www.facebook.com")
//                self.pingNext(test: 3, firstIteration: false, url: "www.youtube.com")
//                self.pingNext(test: 5, firstIteration: false, url: "www.google.com")
//
//
//            }
//        }
//
//        operationQueue.waitUntilAllOperationsAreFinished()
//    }
        
//        DispatchQueue.main.async {
//            self.pingNext(test: 2)
//            self.pingNext(test: 4)
//        }
        //}

    }
    
//    func pingNext(test : Int, firstIteration : Bool) {
//        
//        var url = startingArray[test]
//        startingArray.remove(at: test)
//        print("Starts")
//        if ipArray.count >= 254 {
//            isStopped = true;
//            StartButton.title = "Start"
//            endTime = Date()
//            print(endTime.timeIntervalSince(startTime))
//            return
//        }
//        
//        if isStopped{
//            return
//        }
//
//        if firstIteration{
//            currentIndex = currentIndex + test
//            print(currentIndex)
//            print(test)
//        }
//        let currentAddress = url
//        let ipObj = Ip()
//
//        ipObj.ipAddress = "\(currentAddress) : thread: \(test)"
//        let ping = currentAddress
//        PlainPing.ping(url, withTimeout: 3, completionBlock: { (timeElapsed:Double?, error:Error?) in
//            if timeElapsed != nil {
//                ipObj.reachable = true
//            }
//            else{
//                ipObj.reachable = false
//            }
//            self.ipArray.append(ipObj)
//            print("got in")
//            self.currentIndex = self.currentIndex + 1
//            self.startingArray.remove(at: test)
//            DispatchQueue.main.async {
//                self.ProgressView.setProgress(Float(self.ipArray.count) / Float(255), animated: true)
//                self.tableView.reloadData()
//            }
//
//            self.pingNext(test: test, firstIteration: false)
//
//        })
//
//
//    }

    func pingSwift(url: String){
        let pingInterval:TimeInterval = 3
        let timeoutInterval:TimeInterval = 4


        let config : PingConfiguration = {
            return PingConfiguration(pInterval: pingInterval, withTimeout: timeoutInterval)
        }()
       // print(url)

        SwiftPing.ping(host: url,
                            configuration: config, queue: .main) { (ping, error) in
                             if error == nil {
                                print(ping.debugDescription)
                                 print("no error \(url)")
                             }
                             else{
                                 print("error \(url)")
                             }


        }


    }
    
//    func swiftyCall(url : String){
//        print(url)
//        let pinger = SwiftyPing(host: url, configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.main)
//        pinger?.observer = { (_, response) in
//            print("inside")
//            let duration = response.duration
//            print(duration)
//        }
//    }
//
//    func pingHost(_ fullURL: String) {
//        print("prasided")
//        if let url = URL(string: "https://10.70.190.131") {
//          var request = URLRequest(url: url)
//          request.httpMethod = "HEAD"
//
//          URLSession(configuration: .default)
//            .dataTask(with: request) { (_, response, error) -> Void in
//              guard error == nil else {
//                print("Error:", error ?? "")
//                return
//              }
//
//              guard (response as? HTTPURLResponse)?
//                .statusCode == 200 else {
//                  print("down")
//                  return
//              }
//
//              print("up")
//            }
//            .resume()
//        }
//    }


}


