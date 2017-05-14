//
//  LocationViewController.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 28.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import MapKit

private let annotationIdentifier = "app_place"

class ServiceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer: Timer?
    var isLookupStarted = false
    
    let directions: [String] = [
        "left", "right", "forward", "behind"
    ]
    var datasource: [String] = []
    
    var targetPlace: MKAnnotation {
        return ServiceManager.shared.currentApp!
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }

    private func setupMap() {
        mapView.addAnnotation(targetPlace)
        
        let place = targetPlace.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.04,
                                    longitudeDelta: 0.04)
        mapView.setRegion(MKCoordinateRegion(center: place, span: span), animated: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func actionToggleLookup(_ sender: Any) {
        isLookupStarted ? stopLookup() : startLookup()
    }
    
    private func startLookup() {
        isLookupStarted = true
        lookupButton.setTitle("Stop Lookup", for: [])
        activityIndicator.startAnimating()
        start()
    }
    
    private func stopLookup() {
        isLookupStarted = false
        lookupButton.setTitle("Start Lookup", for: [])
        activityIndicator.stopAnimating()
        stop()
    }
    
    private func start() {
        datasource.insert("Start lookup devices", at: 0)
        tableView.reloadData()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            let direction = self.directions[random(max: self.directions.count - 1)]
            let steps = random(max: 100)
            self.datasource.insert("Target place is \(direction) from your in \(steps) steps", at: 0)
            self.addInfo()
        }
    }
    
    private func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func addInfo() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
}

// MARK: - MKMapViewDelegate

extension ServiceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        let pin = annotationView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        
        pin.canShowCallout = true
        pin.annotation = annotation
        pin.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        pin.image = #imageLiteral(resourceName: "ic_map_pin_big")
        
        return pin
    }
}

// MARK: - UITableViewDataSource

extension ServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
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

