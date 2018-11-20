//
//  RequestTypeViewController.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import UIKit

class RequestTypeViewController: UIViewController  {
    var httpType : [String] = []
    @IBOutlet weak var apiTypeView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignModelArray()
    }
    /// This function assign all the define RequestMethod in array
    func assignModelArray(){
        httpType.append(RequestMethod.get.rawValue)
        httpType.append(RequestMethod.post.rawValue)
        httpType.append(RequestMethod.Upload.rawValue)
    }
}
extension RequestTypeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return httpType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultcell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell()
        let label = defaultcell.viewWithTag(1) as? UILabel
        label?.text = httpType[indexPath.row]
        defaultcell.selectionStyle = .none
        return defaultcell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch httpType[indexPath.row] {
        case RequestMethod.Upload.rawValue: break
        case RequestMethod.post.rawValue: APIWrapperTest.callPostAPI()
        default: APIWrapperTest.callGetAPI() }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
enum RequestMethod: String {
    case get     = "GET"
    case post    = "POST"
    case Upload     = "Upload"
}
