//
//  ViewController.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var models : [String] = []
    @IBOutlet weak var modelTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignModelArray()
        // Do any additional setup after loading the view, typically from a nib.
    }
    /// This function assign all the define models in array
    func assignModelArray(){
        models.append(ModelsArray.wrapper)
    }
}
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultcell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "modelCell") ?? UITableViewCell()
        let label = defaultcell.viewWithTag(1) as? UILabel
        label?.text = models[indexPath.row]
        defaultcell.selectionStyle = .none
        return defaultcell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  models[indexPath.row] {
        case ModelsArray.wrapper:
            let vc: RequestTypeViewController =  self.controllerForClass("RequestTypeViewController",storyboard: "APIWraper") as! RequestTypeViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            print("Thank You")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension ViewController {
    func controllerForClass(_ name: String, storyboard stroryBoard:String) -> UIViewController {
        let viewController:UIViewController = UIStoryboard(name: stroryBoard as String, bundle: nil).instantiateViewController(withIdentifier: name as String) as UIViewController
        return viewController
    }
}
/// This Struct contains all the models
struct ModelsArray {
    static let wrapper = "API Wrapper"
}
