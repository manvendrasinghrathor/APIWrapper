//
//  APIWrapperTest.swift
//  ModelAPP
//
//  Created by Manvendra on 11/20/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import Foundation

/// API models used in the Application
struct APIModels {
    /// Get API Model
    ///
    /// - Parameter email: email id of user
    /// - Returns: Get API Model
    static func GetAPIModel(email : String) -> APIRequestModel {
        let param = APIParameter(parameters: ["user[email]" : email])
        let getModel = APIRequestModel(url: "https://qa.allective.com/api/v2/verify_email?user[email]", type: .get, Parameters: param)
        return getModel
    }
    /// Post API Model
    ///
    /// - Parameters:
    ///   - deviceToken: deviceToken
    ///   - email: email id of user
    ///   - password: password entered
    /// - Returns: Post API Model
    static func PostAPIModel(deviceToken : String? = "", email : String,password : String) -> APIRequestModel {
        let keys = ["user[device_token]","user[email]","user[code]"]
        let values = [deviceToken ?? "",email,password]
        let param = APIParameter(keys: keys, values: values)
        let getModel = APIRequestModel(url: "https://staging.allective.com/api/v2/sessions", type: .post, Parameters: param)
        return getModel
    }
}
/// Testing Model for API Wrapper
struct APIWrapperTest {
    /// Tetsing function for get api
    static func callGetAPI() {
        let model = APIModels.GetAPIModel(email: "d.mem1@yopmail.com")
        var  apiWrapper : APIWrapper = APIWrapper(request: model)
        apiWrapper.isDebugOn = true
        apiWrapper.requestAPI(success: { (object) in
            print(object)
        }, failed: { (error) in
            print(error)
        })
    }
    /// Tetsing function for post api
    static func callPostAPI() {
        let model = APIModels.PostAPIModel(email: "d.mem1@yopmail.com", password: "1234")
        var  apiWrapper : APIWrapper = APIWrapper(request: model)
        apiWrapper.isDebugOn = true
        apiWrapper.requestAPI(success: { (object) in
            print(object)
        }, failed: { (error) in
            print(error)
        })
    }
    /// Tetsing function for upload api
    static func callUploadAPI() {
        var requestModel = APIRequestModel(url: "https://qa.allective.com/api/v2/verify_email?user[email]", type: .get)
        let peramters = APIParameter(keys: ["user[email]"], values: ["d.mem1@yopmail.com"])
        requestModel.Parameters = peramters
        requestModel.multiPartData = APIMultiPartFormData()
        var  apiWrapper : APIWrapper = APIWrapper(request: requestModel)
        apiWrapper.isDebugOn = true
        apiWrapper.requestAPI(success: { (object) in
            print(object)
        }, failed: { (error) in
            print(error)
        })
    }
}
