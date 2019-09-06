//
//  LoginController.swift
//  ModelAPP
//
//  Created by KiwiTech on 05/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class LoginController: UIViewController {
    var dataSource: LoginViewModel?
    override func viewDidLoad() {
        dataSource = LoginViewModelClass()
        saveUserData()
    }
    func saveUserData() {
        dataSource?.getUserData(email: "Mps", password: "Tes")
       print(dataSource?.checkValidation())
    }
}
//controller UI view
// view
