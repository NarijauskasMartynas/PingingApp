//
//  ViewController.swift
//  PingingApp
//
//  Created by Martynq on 09/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit
import PlainPing

class IpListViewController: UITableViewController {

    @IBOutlet weak var StartButton: UIBarButtonItem!
    private var ipAddress : String = ""
    private var ipArray : [Ip] = []
    private var currentIndex = 1
    private var isStopped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ipGetter = IpGetter()
        ipAddress = ipGetter.getIPAddress()
        // Do any additional setup after loading the view.
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
        pingNext()
    }
    func pingNext() {
        
        if isStopped{
            return
        }
        
        let currentAddress = "\(ipAddress)\(currentIndex)"
        let ipObj = Ip()
        ipObj.ipAddress = currentAddress
        let ping = currentAddress
        currentIndex = currentIndex + 1
        PlainPing.ping(ping, withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            if let latency = timeElapsed {
                ipObj.reachable = true
            }
            else{
                ipObj.reachable = false
            }
            self.ipArray.append(ipObj)
            self.tableView.reloadData()
            self.pingNext()
        })
    }


}

