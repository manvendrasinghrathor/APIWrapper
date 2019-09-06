//
//  LoginViewModel.swift
//  ModelAPP
//
//  Created by KiwiTech on 05/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
protocol LoginViewModel {
    func getUserData(email: String, password: String)
    func checkValidation() -> Bool
    func callAPI()
}
class LoginViewModelClass: LoginViewModel {
    var user: UserModel?
    func getUserData(email: String, password: String) {
        user = UserModel(email: email, password: password)
    }
    func checkValidation() -> Bool {
        if user == nil {
            return false
        }
        if user?.email == "" {
            return false
        }
        return true
    }
    func callAPI() {
        print("Call API")
    }
}
