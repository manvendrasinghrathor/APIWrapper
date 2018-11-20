//
//  APIWrapperModel.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import Foundation
import Alamofire
/// model used to request a API
struct APIRequestModel {
    var url : String = ""
    var type : HTTPMethod = HTTPMethod.get
    var Parameters : APIParameter?
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders?
    var multiPartData : APIMultiPartFormData?
    /// In init function of APIRequestModel the API URL is compulsory object all other are optional
    /// To upload file, APIMultiPartFormData is required
    /// - Parameters:
    ///   - url: API request url
    ///   - type: API request type
    ///   - Parameters: APIParameter
    ///   - encoding: encoding description
    ///   - headers: headers description
    ///   - multipartdata: multipartdata object
    init(url: String) {
        self.url = url
    }
    init(url: String, type: HTTPMethod? = HTTPMethod.get) {
        self.url = url
        self.type = type ?? HTTPMethod.get
    }
    init(url: String, type: HTTPMethod? = HTTPMethod.get, Parameters: APIParameter) {
        self.url = url
        self.type = type ?? HTTPMethod.get
        self.Parameters = Parameters
    }
    init(url: String, type: HTTPMethod? = HTTPMethod.get, Parameters: APIParameter? = nil, encoding : ParameterEncoding? = URLEncoding.default,headers: HTTPHeaders? = nil) {
        self.url = url
        self.type = type ?? HTTPMethod.get
        self.Parameters = Parameters
        self.encoding = encoding ?? URLEncoding.default
        self.headers = headers
    }
    init(url: String, type: HTTPMethod? = HTTPMethod.get, Parameters: APIParameter? = nil, encoding : ParameterEncoding? = URLEncoding.default,headers: HTTPHeaders? = nil, uploadFileUrls : [String]? = nil, multiPartData : APIMultiPartFormData? = nil) {
        self.url = url
        self.type = type ?? HTTPMethod.get
        self.Parameters = Parameters
        self.encoding = encoding ?? URLEncoding.default
        self.headers = headers
        self.multiPartData = multiPartData
    }

}
/// model used to create parameters for APIRequestModel
struct APIParameter {
    var keys : [String] = []
    var values : [Any] = []
    var parameters : [String : Any] = [String : Any]()
    /// Can pass keys and values in seperate array
    /// Or can pass parameters directly
    /// - Parameters:
    ///   - keys: Parameter key
    ///   - values: corresponding values
    ///   - parameters: complete Parameter
    init(keys: [String], values: [Any]) {
        self.keys = keys
        self.values = values
    }
    init(parameters : [String : Any]) {
        self.parameters = parameters
        self.createParam()
    }
    /// This function generate key value for API request
    mutating func createParam(){
        let minValue = min((self.keys ).count, (self.values ).count)
        for index in 0..<minValue {
            let key = self.keys[index]
            self.parameters[key] = self.values[index]
        }
    }
}
/// Model used to create mulipart data for requuest model
struct APIMultiPartFormData {
    var uploadFile : [Any]?
    var fileNames : [String]?
    var serverKeys : [String]?
    var mimeTypes : [String]?
    var ImageQuality : Float?
    var multipartformData : [MultiPartFormData]?
    /// Can provide the array of MultiPartFormData object or can upload upload file , file name, server key and mime type separately
    /// If the keys are same for file Names,server Keys and mimeTypes then only single object is required in corresponding array
    /// - Parameters:
    ///   - uploadFile: file's of type Data,Images or drive urls
    ///   - fileNames: fileNames description
    ///   - serverKeys: serverKeys description
    ///   - mimeTypes: mimeTypes description
    ///   - ImageQuality: ImageQuality description
    init(multipartformData : [MultiPartFormData]) {
         self.multipartformData = multipartformData
    }
    init(uploadFile :[Any]? = nil,fileNames : [String]? = nil ,serverKeys : [String]? = nil,mimeTypes: [String]? = nil) {
        self.uploadFile = uploadFile
        self.fileNames = fileNames
        self.serverKeys = serverKeys
        self.mimeTypes = mimeTypes        
    }
    init(uploadFile :[Any]? = nil,fileNames : [String]? = nil ,serverKeys : [String]? = nil,mimeTypes: [String]? = nil , ImageQuality : Float? = 0.1) {
        self.uploadFile = uploadFile
        self.fileNames = fileNames
        self.serverKeys = serverKeys
        self.mimeTypes = mimeTypes
        self.ImageQuality = ImageQuality
    }
    init(multipartformData : [MultiPartFormData]? = nil,uploadFile :[Any]? = nil,fileNames : [String]? = nil ,serverKeys : [String]? = nil,mimeTypes: [String]? = nil , ImageQuality : Float? = 0.1) {
        self.uploadFile = uploadFile
        self.fileNames = fileNames
        self.serverKeys = serverKeys
        self.mimeTypes = mimeTypes
        self.ImageQuality = ImageQuality
        self.multipartformData = multipartformData
    }
}
// MultiPartFormData model
struct MultiPartFormData {
    var uploadFile : Data = Data()
    var fileName : String = ""
    var serverKey : String = ""
    var mimeTypes : String = ""
    /// MultiPartFormData data model
    ///
    /// - Parameters:
    ///   - uploadFile: upload data file
    ///   - fileName: fileName description
    ///   - serverKey: serverKey description
    ///   - mimeTypes: mimeTypes description
    init(uploadFile : Data , fileName : String, serverKey : String ,mimeTypes : String ) {
        self.uploadFile = uploadFile
        self.fileName = fileName
        self.serverKey = serverKey
        self.mimeTypes = mimeTypes
    }
}
