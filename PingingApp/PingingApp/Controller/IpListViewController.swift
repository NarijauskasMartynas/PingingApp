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
    
    private var pinger : Pinger = Pinger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ipGetter = IpGetter()
        let ipAddress = ipGetter.getIPAddress()
        pinger.generateIpAddresses(startingAddress: ipAddress)
        pinger.delegate = self
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
        let alert = UIAlertController(title: "Sort type", message: "Select your sorting type", preferredStyle: .actionSheet)

        let sortByIp = UIAlertAction(title: "Sort by IP", style: .default) { (_) in
            self.pinger.ipObjArray.sort {$0.ipAddress > $1.ipAddress}
            self.tableView.reloadData()
        }
        
        let sortByReachability = UIAlertAction(title: "Sort by reachability", style: .default) { (_) in
            self.pinger.ipObjArray.sort {$0.reachable && !$1.reachable}
            self.tableView.reloadData()
        }
        
        alert.addAction(sortByIp)
        alert.addAction(sortByReachability)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startPinging(_ sender: UIBarButtonItem) {
        if pinger.isStopped{
            pinger.isStopped = false
            pinger.startPinging()
            StartButton.title = "Stop"
        }
        else{
            StartButton.title = "Start"
            pinger.isStopped = true
        }
        pinger.startPinging()
    }
    
    func updateUI() {
        ProgressView.setProgress(Float(pinger.ipObjArray.count) / Float(255), animated: true)
        tableView.reloadData()
        StartButton.title = pinger.isStopped ? "Start" : "Stop"
    }

}


