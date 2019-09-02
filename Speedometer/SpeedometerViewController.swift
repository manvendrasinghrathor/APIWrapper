//
//  SpeedometerViewController.swift
//  ModelAPP
//
//  Created by KiwiTech on 22/11/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import CoreMotion

class SpeedometerViewController: UIViewController {
    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var spped: UILabel!
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var activityTypeLabel: UILabel!
    private let activityManager = CMMotionActivityManager()
    private let pedoMeter = CMPedometer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runLoop()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func runLoop() {
//      let speedometerTimer = Timer(fire: Date(), interval: (1.0/60.0),
//                            repeats: true, block: { (_) in
                                self.stepCounting()
//        })
//        RunLoop.current.add(speedometerTimer, forMode: .default)
    }
    func stepCounting() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        if !(CMMotionActivityManager.isActivityAvailable()) { return }
        if !(CMPedometer.isStepCountingAvailable()) { return }
        let fromDate = Date.yesterday
        self.pedoMeter.startUpdates(from: fromDate) { (data: CMPedometerData?, _) in
            self.setMotionDataInUI(data: data)
        }
    }
    func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            self?.setActivityDataInUI(activity: activity)
        }
    }
    func setActivityDataInUI(activity: CMMotionActivity) {
        DispatchQueue.main.async {
            if activity.walking {
                self.activityTypeLabel.text = "Walking"
            } else if activity.stationary {
                self.activityTypeLabel.text = "Stationary"
            } else if activity.running {
                self.activityTypeLabel.text = "Running"
            } else if activity.automotive {
                self.activityTypeLabel.text = "Automotive"
            } else if activity.cycling {
                self.activityTypeLabel.text = "Cycling"
            } else if activity.unknown {
                self.activityTypeLabel.text = ""
            }
        }
    }
    func setMotionDataInUI(data: CMPedometerData?) {
        print(data ?? "")
        let step = data?.numberOfSteps ?? 0
        if step != 0 {
            DispatchQueue.main.async {
                self.steps.text = "\(step) Steps"
            }
        }
        if let speed = data?.distance {
            DispatchQueue.main.async {
                self.distance.text = "\(Double(truncating: speed).rounded(toPlaces: 2)) meters"
            }
        }
        DispatchQueue.main.async {
            if let speed = data?.currentPace {
                self.spped.text = "\(self.convertSPMtoKPH(speed: Double(truncating: speed))) km/h"
            } else {
                self.spped.text = "0 km/h"
            }
        }
        if let speed = data?.averageActivePace {
            DispatchQueue.main.async {
                self.avgSpeed.text = "\(self.convertSPMtoKPH(speed: Double(truncating: speed))) km/h"
            }
        }
    }
    func convertSPMtoKPH(speed: Double) -> Double {
        let mps = 1/speed
        let kph = mps*3.6
        let finalSpeed = kph.rounded(toPlaces: 2)
        return finalSpeed
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
