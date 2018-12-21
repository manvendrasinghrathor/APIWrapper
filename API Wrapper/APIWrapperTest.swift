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
    static func getAPIModel(email: String) -> APIRequestModel {
        let param = APIParameter(parameters: ["user[email]": email])
        let getModel = APIRequestModel(url: "https://qa.allective.com/api/v2/verify_email?user[email]", type: .get, parameters: param)
        return getModel
    }
    /// Post API Model
    ///
    /// - Parameters:
    ///   - deviceToken: deviceToken
    ///   - email: email id of user
    ///   - password: password entered
    /// - Returns: Post API Model
    static func postAPIModel(deviceToken: String? = "", email: String, password: String) -> APIRequestModel {
        let keys = ["name", "email", "password","location", "bio", "profile_image", "device_token", "device_type"]
        let values = [ "Rotation App","gfprotationapp@gmail.com","kiwi@2018","","","","ca4a3473c730a37c9b7172e09825df9a6269499f41d05c5962213fc785c133cb","iso"]
        let param = APIParameter(keys: keys, values: values)
        let getModel = APIRequestModel(url: "http://54.87.110.198/api/V1/auth/signup", type: .post, parameters: param,headers: ["accept": "application/json"])
        return getModel
    }
}
/// Testing Model for API Wrapper
struct APIWrapperTest {
    /// Tetsing function for get api
    static func callGetAPI() {
        let model = APIModels.getAPIModel(email: "d.mem1@yopmail.com")
        var  apiWrapper: APIWrapper = APIWrapper(request: model)
        apiWrapper.isDebugOn = true
        apiWrapper.requestAPI(success: { (object) in
            print(object)
        }, failed: { (error) in
            print(error)
        })
    }
    /// Tetsing function for post api
    static func callPostAPI() {
        let model = APIModels.postAPIModel(email: "d.mem1@yopmail.com", password: "1234")
        var  apiWrapper: APIWrapper = APIWrapper(request: model)
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
        requestModel.parameters = peramters
        requestModel.multiPartData = APIMultiPartFormData()
        var  apiWrapper: APIWrapper = APIWrapper(request: requestModel)
        apiWrapper.isDebugOn = true
        apiWrapper.requestAPI(success: { (object) in
            print(object)
        }, failed: { (error) in
            print(error)
        })
    }
}
