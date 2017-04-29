//
//  LocationViewController.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 28.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startLookupButton: UIButton!
    @IBOutlet weak var stopLookupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var rowsCount: Int = 0
    
    let directions: [String] = [
        "left", "right", "forward", "behind"
    ]
    
    var timer: Timer?
    
    var datasource: [String] = []
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Services"
    }

    // MARK: - Actions
    
    @IBAction func actionStartLookup(_ sender: Any) {
        self.startLookupButton.isEnabled = false
        self.stopLookupButton.isEnabled = true
        self.activityIndicator.startAnimating()
        self.start()
    }
    @IBAction func actionStopLookup(_ sender: Any) {
        self.stopLookupButton.isEnabled = false
        self.startLookupButton.isEnabled = true
        self.activityIndicator.stopAnimating()
        self.stop()
    }
    
    
    func start() {
        datasource.insert("Start lookup devices", at: 0)
        rowsCount += 1
        tableView.reloadData()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            let direction = self.directions[random(max: self.directions.count - 1)]
            let steps = random(max: 100)
            self.datasource.insert("Target place is \(direction) from your in \(steps) steps", at: 0)
            self.rowsCount += 1
            self.addInfo()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func addInfo() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
}


extension ServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "beacon_cell")!

        cell.textLabel?.text = self.datasource[indexPath.row]
        return cell
    }
}

func random(max: Int) -> Int {
    return  Int(arc4random_uniform(UInt32(max))) + 1
}

