//
//  ViewController.swift
//  PingingApp
//
//  Created by Martynq on 09/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit
import GBPing


class IpListViewController: UITableViewController, UpdateIpListDelegate {
    @IBOutlet weak var StartButton: UIBarButtonItem!
    @IBOutlet weak var ProgressView: UIProgressView!

    private var ipAddress : String = ""
    
    private var pinger : Pinger = Pinger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ipGetter = IpGetter()
        ipAddress = ipGetter.getIPAddress()
        pinger.generateIpAddresses(startingAddress: ipAddress)
        pinger.delegate = self
//        DispatchQueue.concurrentPerform(iterations: 10) { (int) in
//
//        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinger.ipObjArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IpItemCell", for: indexPath)
        
        if pinger.ipObjArray.count > 0 {
            cell.textLabel?.text = (pinger.ipObjArray[indexPath.row].ipAddress)
            let image = pinger.ipObjArray[indexPath.row].reachable ? UIImage(systemName: "sun.min") : UIImage(systemName: "zzz")
            cell.accessoryView = UIImageView(image: image)
        }
        else{
            cell.textLabel?.text = "lalala"
        }
        
        return cell
    }
    @IBAction func SortTapped(_ sender: UIBarButtonItem) {
        print(pinger.ipObjArray.count)
        tableView.reloadData()
    }
    
    @IBAction func startPinging(_ sender: UIBarButtonItem) {
//        if pinger.isStopped{
//            pinger.isStopped = false
//            pinger.startPinging()
//            StartButton.title = "Stop"
//        }
//        else{
//            StartButton.title = "Start"
//            pinger.isStopped = true
//            tableView.reloadData()
//        }
        pinger.startPinging()
    }
    
    func updateTableView() {
        print("Lalala")
        tableView.reloadData()
    }

}


