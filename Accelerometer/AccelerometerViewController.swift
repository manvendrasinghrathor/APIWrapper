//
//  AccelerometerViewController.swift
//  ModelAPP
//
//  Created by KiwiTech on 21/11/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import Foundation
import CoreMotion

class AccelerometerViewController: UIViewController {
    @IBOutlet weak var xValue: UILabel!
    @IBOutlet weak var YValue: UILabel!
    @IBOutlet weak var zValue: UILabel!
    @IBOutlet weak var attitudeLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!
    @IBOutlet weak var magneticFieldLabel: UILabel!
    @IBOutlet weak var magneticAccuracyLabel: UILabel!
    let motion = CMMotionManager()
    var accelerometerTimer: Timer = Timer()
    var deviceMotionTimer: Timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    func setUpView() {
        // Make sure the accelerometer hardware is available.
        if motion.isAccelerometerAvailable ||  motion.isDeviceMotionAvailable {
            if motion.isAccelerometerAvailable { startAccelerometers() }
            if motion.isDeviceMotionAvailable { startDeviceMotion() }
        } else {
            self.showAleart()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerTimer.invalidate()
        deviceMotionTimer.invalidate()
    }
    /// Show the Aleart
    func showAleart() {
        let alert = UIAlertController(title: "Alert", message: "Allow Access for Motion", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension AccelerometerViewController {
    func startAccelerometers() {
        self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
        self.motion.startAccelerometerUpdates()
        accelerometerTimer = Timer(fire: Date(), interval: (1.0),
                                   repeats: true, block: { (_) in
                                    // Get the accelerometer data.
                                    self.accelerometerData()
        })
        // Add the timer to the current run loop.
        RunLoop.current.add(accelerometerTimer, forMode: .default)
    }
    func startDeviceMotion() {
        self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
        self.motion.showsDeviceMovementDisplay = true
        self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        deviceMotionTimer = Timer(fire: Date(), interval: (1.0/60.0),
                                  repeats: true, block: { (_) in
                                    // Get the accelerometer data.
                                    self.deviceMotionData()
        })
        // Add the timer to the current run loop.
        RunLoop.current.add(deviceMotionTimer, forMode: .default)
    }
    /// This function set value for accelerometerData
    func accelerometerData() {
        guard let data = self.motion.accelerometerData else { return }
        let accelerationX = data.acceleration.x
        let accelerationY = data.acceleration.y
        let accelerationZ = data.acceleration.z
        self.xValue.text = "\(accelerationX)"
        self.YValue.text = "\(accelerationY)"
        self.zValue.text = "\(accelerationZ)"
    }
    /// This function set value for accelerometerData
    func deviceMotionData() {
        guard let data = self.motion.deviceMotion else { return }
        let attitude = data.attitude
        let gravity = data.gravity
        let magneticField = data.magneticField.field
        let magneticAccuracy = data.magneticField.accuracy
        attitudeLabel.text = "\(attitude)"
        gravityLabel.text = "\(gravity)"
        magneticFieldLabel.text = "\(magneticField)"
        magneticAccuracyLabel.text = "\(magneticAccuracy)"
    }
}
