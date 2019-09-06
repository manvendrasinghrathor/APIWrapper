//
//  LoginModel.swift
//  ModelAPP
//
//  Created by KiwiTech on 05/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
struct UserModel: Codable {
    let email: String?
    let password: String?
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
