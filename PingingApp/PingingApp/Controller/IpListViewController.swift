//
//  ViewController.swift
//  PingingApp
//
//  Created by Martynq on 09/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit
import PlainPing
//import SwiftPing

class IpListViewController: UITableViewController {

    @IBOutlet weak var StartButton: UIBarButtonItem!
    @IBOutlet weak var ProgressView: UIProgressView!

    private var ipAddress : String = ""
    private var ipArray : [Ip] = []
    private var currentIndex = 1
    private var isStopped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ipGetter = IpGetter()
        ipAddress = ipGetter.getIPAddress()
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
        
            DispatchQueue.concurrentPerform(iterations: 10) { (count) in
                DispatchQueue.main.async {
                    self.pingNext(test: count, firstIteration: true)
                }
        }
//        DispatchQueue.main.async {
//            self.pingNext(test: 2)
//            self.pingNext(test: 4)
//        }
        //}


    }
    
    func pingNext(test : Int, firstIteration :Bool) {
        print("\(test) pradzia")
        if ipArray.count >= 254 {
            isStopped = true;
            StartButton.title = "Start"
            return
        }
        
        if isStopped{
            return
        }
//
//        if firstIteration{
//            currentIndex = currentIndex + test
//            print(currentIndex)
//            print(test)
//        }
        let currentAddress = "\(ipAddress)\(test)"
        let ipObj = Ip()
        ipObj.ipAddress = "\(currentAddress) : thread: \(test)"
        let ping = currentAddress
        PlainPing.ping(ping, withTimeout: 1, completionBlock: { (timeElapsed:Double?, error:Error?) in
            if timeElapsed != nil {
                ipObj.reachable = true
            }
            else{
                ipObj.reachable = false
            }
            if let error = error?.localizedDescription{
                print(error)
            }
            
            self.ipArray.append(ipObj)
            self.currentIndex = self.currentIndex + 1
            DispatchQueue.main.async {
                self.ProgressView.setProgress(Float(self.ipArray.count) / Float(255), animated: true)
                self.tableView.reloadData()
            }
            self.pingNext(test: test, firstIteration: false)
        })
        
        //print(ipObj.ipAddress)
        
        //pingNext(test: test)
    }


}

