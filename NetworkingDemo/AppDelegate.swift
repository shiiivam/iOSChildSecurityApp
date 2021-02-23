//
//  AppDelegate.swift
//  NetworkingDemo
//
//  Created by Shivam Sharma on 16/02/21.
//  Copyright © 2021 ShivamSharma. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var timer = Timer()
    var longtt:String!
    var latt:String!
    
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        var n = 2 //seconds
        
        var timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        var n = 2 //seconds
        
        var timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
        
    func getLocationCoordinates(){
        var manager: CLLocationManager?
            manager = CLLocationManager()
            manager?.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                manager?.delegate = self
                manager?.desiredAccuracy = kCLLocationAccuracyBest
                manager?.startUpdatingLocation()
                manager?.allowsBackgroundLocationUpdates = true
            }
        }
        
    func sendData(){
        let battlevel = UIDevice.current.batteryLevel
        let urlString = "https://httpbin.org/post"
            //getLocationCoordinates()
        let batteryAndLocation: Parameters =  [
            "batteryLevel": "\(battlevel)",
            "latitude": "\(latt ?? "")",
            "longitude": "\(longtt ?? "")"
            ]
        print("Current Battery Level : \(battlevel)")
        
            
    AF.request(URL.init(string: urlString)!, method: .post, parameters: batteryAndLocation, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            print("API Responseresponse: \(response)")
            switch response.result{
                case .success(_):
                    if response.value != nil
                        {
                            print("Data sent successfully")
                        }
                        break
                case .failure(let error):
                            print(error)
                        break
                        }
            }
        }
    func scheduledTimer(){
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateLocationAndBattery), userInfo: nil, repeats: true)
            }
    @objc func updateLocationAndBattery(){
        DispatchQueue.global(qos: .background).async {
           self.sendData()
           DispatchQueue.main.async{
           self.getLocationCoordinates()
            }
        }
//        DispatchQueue.main.async{
//                  self.getLocationCoordinates()
//        }
    }
    
    // MARK: - Core Data stack

   lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NetworkingDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    @objc func getLocation()
    {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        guard let first = locations.first else{
            return
        }
        print("The location is: Loongitude: \(first.coordinate.longitude) , Latitude : \(first.coordinate.latitude)")
        longtt = String(first.coordinate.longitude)
        latt = String(first.coordinate.latitude)
        sendData()
        
    }
}
