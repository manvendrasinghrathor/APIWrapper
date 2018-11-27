//
//  CoreLocationViewController.swift
//  ModelAPP
//
//  Created by KiwiTech on 26/11/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftLog
class CoreLocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lastSpeedlabel: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.setUpLocationManager()
        cretaLogFile()
    }
    func cretaLogFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            try FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
            Log.logger.name = "SpeedLog"
            Log.logger.maxFileSize = 8192
            Log.logger.maxFileCount = 8
            Log.logger.directory = "\(String(describing: documentsPath))"
            Log.logger.printToConsole = true
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lastSpeed = ""
        var speedString = ""
        if let speed = locationManager.location?.speed, speed > 0 {
            let kmSpeed: Double = (speed*3.6).rounded(toPlaces: 2)
            speedLabel.text = "\(kmSpeed) kmph"
            speedString = "\(kmSpeed)"
        } else {
            speedLabel.text = "0 kmph"
            speedString = "-"
        }
        if let speed = locations.last?.speed, speed > 0 {
            let kmSpeed: Double = (speed*3.6).rounded(toPlaces: 2)
            lastSpeedlabel.text = "\(kmSpeed) kmph"
            lastSpeed = "\(kmSpeed)"
        } else {
            lastSpeedlabel.text = "0 kmph"
            lastSpeed = "-"
        }
        self.recordSpeed(type: "LAST", value: lastSpeed)
        self.recordSpeed(type: "SPEED", value: speedString)
    }
    func recordSpeed(type: String, value: String ) {
        logw("\(type): \(value)")
    }
}
//class Log {
//    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS" // Use your own
//    static var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = dateFormat
//        formatter.locale = Locale.current
//        formatter.timeZone = TimeZone.current
//        return formatter
//    }
//    class func error( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column,  funcName: String = #function) {
//        print("\(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
//    }
//    private class func sourceFileName(filePath: String) -> String {
//        let components = filePath.components(separatedBy: "/")
//        return components.isEmpty ? "" : components.last!
//    }
//}
//extension Date {
//    func toString() -> String {
//        return Log.dateFormatter.string(from: self as Date)
//    }
//}
