//
//  ViewController.swift
//  PingingApp
//
//  Created by Martynq on 09/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit

class IpListViewController: UITableViewController, UpdateIpListDelegate {
    @IBOutlet weak var StartButton: UIBarButtonItem!
    @IBOutlet weak var ProgressView: UIProgressView!
    
    private var pinger : Pinger = Pinger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ipGetter = IpGetter()
        let ipAddress = ipGetter.getIPAddress()
        pinger.generateIpAddresses(startingAddress: ipAddress)
        IpStorage.delegate = self
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IpStorage.ipObjArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IpItemCell", for: indexPath)
        
        if IpStorage.ipObjArray.count > 0 {
            cell.textLabel?.text = (IpStorage.ipObjArray[indexPath.row].ipAddress)
            let image = IpStorage.ipObjArray[indexPath.row].reachable ? UIImage(systemName: "sun.min") : UIImage(systemName: "zzz")
            cell.accessoryView = UIImageView(image: image)
        }
        else{
            cell.textLabel?.text = "lalala"
        }
        
        return cell
    }
    @IBAction func SortTapped(_ sender: UIBarButtonItem) {
        tableView.reloadData()
        print("VISO YRA \(IpStorage.ipObjArray.count)" )
        let alert = UIAlertController(title: "Sort type", message: "Select your sorting type", preferredStyle: .actionSheet)

        let sortByIpAsc = UIAlertAction(title: "Sort by IP (asc)", style: .default) { (_) in
            IpStorage.ipObjArray.sort {$0.ipNumber < $1.ipNumber}
            self.tableView.reloadData()
        }
        
        let sortByReachabilityAsc = UIAlertAction(title: "Sort by reachability (asc)", style: .default) { (_) in
            IpStorage.ipObjArray.sort {$0.reachable && !$1.reachable}
            self.tableView.reloadData()
        }
        
        let sortByIpDesc = UIAlertAction(title: "Sort by IP (desc)", style: .default) { (_) in
            IpStorage.ipObjArray.sort {$0.ipNumber > $1.ipNumber}
            self.tableView.reloadData()
        }
        
        let sortByReachabilityDesc = UIAlertAction(title: "Sort by reachability (desc)", style: .default) { (_) in
            IpStorage.ipObjArray.sort {!$0.reachable && $1.reachable}
            self.tableView.reloadData()
        }
        
        alert.addAction(sortByIpAsc)
        alert.addAction(sortByIpDesc)
        alert.addAction(sortByReachabilityAsc)
        alert.addAction(sortByReachabilityDesc)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startPinging(_ sender: UIBarButtonItem) {
        if pinger.isStopped{
            pinger.startPinging()
            StartButton.title = "Stop"
        }
        else{
            StartButton.title = "Start"
            pinger.isStopped = true
        }
    }
    
    func updateUI() {
        print("UPDATE UI********")
        ProgressView.setProgress(Float(IpStorage.ipObjArray.count) / Float(255), animated: true)
        tableView.reloadData()
        StartButton.title = pinger.isStopped ? "Start" : "Stop"
    }
    
}
