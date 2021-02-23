//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Shivam Sharma on 16/02/21.
//  Copyright © 2021 ShivamSharma. All rights reserved.

import UIKit
import CoreLocation
import Alamofire
class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var batteryLbl: UILabel!
    
    var manager:CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLbl.text = "getting location"
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        batteryLbl.text = " Battery Level : \(String(level))"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else{
            return
        }
        locationLbl.text = "\(first.coordinate.longitude) | \(first.coordinate.latitude)"
    }
}
