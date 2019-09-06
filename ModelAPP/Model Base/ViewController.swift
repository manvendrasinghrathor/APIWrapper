//
//  ViewController.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var models: [String] = []
    @IBOutlet weak var modelTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignModelArray()
        // Do any additional setup after loading the view, typically from a nib.
    }
    /// This function assign all the define models in array
    func assignModelArray() {
        models.append(ModelsArray.MVVM)
        models.append(ModelsArray.APIWrapper)
        models.append(ModelsArray.Accelerometer)
        models.append(ModelsArray.Speedometer)
        models.append(ModelsArray.CoreLocation)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultcell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "modelCell") ?? UITableViewCell()
        let label = defaultcell.viewWithTag(1) as? UILabel
        label?.text = models[indexPath.row]
        defaultcell.selectionStyle = .none
        return defaultcell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  models[indexPath.row] {
        case ModelsArray.APIWrapper:
            let viewContlr = self.controllerForClass("RequestTypeViewController", storyboard: "APIWraper") as? RequestTypeViewController
            self.navigationController?.pushViewController(viewContlr ?? RequestTypeViewController(), animated: true)
        case ModelsArray.Accelerometer:
            let viewController: AccelerometerViewController = AccelerometerViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        case ModelsArray.Speedometer:
            let viewController: SpeedometerViewController = SpeedometerViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        case ModelsArray.CoreLocation:
            let viewController: CoreLocationViewController = CoreLocationViewController()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(viewController, animated: true)
        case ModelsArray.MVVM:
            let viewController: LoginController = LoginController()
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            print("Thank You")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension ViewController {
    func controllerForClass(_ name: String, storyboard stroryBoard: String) -> UIViewController {
        let viewController = UIStoryboard(name: stroryBoard as String, bundle: nil).instantiateViewController(withIdentifier: name as String) as UIViewController
        return viewController
    }
}
/// This Struct contains all the models
struct ModelsArray {
    static let MVVM = "MVVM"
    static let APIWrapper = "API Wrapper"
    static let Accelerometer = "Accelerometer"
    static let Speedometer = "Speedometer"
    static let CoreLocation = "CoreLocation"
}
