//
//  APIWrapper.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import Foundation
import Alamofire
/// To request API devop creat object of this wrapper, Init the object with APIRequestModel
/// Developer can on the API debug mode by isDebugOn = true , default it's Off
struct APIWrapper {
    var isDebugOn: Bool = false
    var requestModel: APIRequestModel = APIRequestModel(url: "")
    init(request: APIRequestModel) {
        self.requestModel = request
    }
    /// This is the only function that developer will call after creating the APIRequestModel
    /// This function internally calls API according to the API Request Model and return the output
    /// - Parameters:
    ///   - success: This block will call when API has a response. developer can fetch the response directly from object
    ///   - failed: This block will call when there is an error while getting the response. The error is a collection of String, there is at least one error present in that Array
    func requestAPI(success:@escaping (AnyObject) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        // Check for Network connection
        if !APIWrapperGlobalFunctions.isNetworkConnected() {
             failed(APIWrapperGlobalFunctions.noNetworkError())
            return
        }
        self.printRequestModel()
        // Call internal function fro API calling
        self.request(success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
    }
    /// This function is used to Upload the files from
    ///
    /// - Parameters:
    ///   - progressValue: this call back return thr % of data uploaded
    ///   - success: success when uploading will finish
    ///   - failed: in case of any error this call back call with collection of error
    func requestAPI(progressValue:@escaping(Double) -> Void, success:@escaping (AnyObject) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        // Check for Network connection
        if !APIWrapperGlobalFunctions.isNetworkConnected() {
            failed(APIWrapperGlobalFunctions.noNetworkError())
            return
        }
        self.printRequestModel()
        // Call internal function fro API calling
        self.upload(progressValue: { (progress) in
            progressValue(progress)
        }, success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
    }
    /// This function is used to download the file from url
    ///
    /// - Parameters:
    ///   - progressValue: this call back return thr % of data uploaded
    ///   - success: success when uploading will finish
    ///   - failed: in case of any error this call back call with collection of error
    func downloadFiles(progressValue:@escaping(Double) -> Void, success:@escaping (URL) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        // Check for Network connection
        if !APIWrapperGlobalFunctions.isNetworkConnected() {
            failed(APIWrapperGlobalFunctions.noNetworkError())
            return
        }
        let urlString = requestModel.url
        let url = URL.init(string: urlString)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(url?.lastPathComponent ?? "")
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        self.printRequestModel()
        Alamofire.download(urlString, to: destination).downloadProgress(queue: DispatchQueue.main) { (progress) in
            progressValue(progress.fractionCompleted)
            }.response { (response) in
                self.debugPrint(object: "API Response for url => \(self.requestModel.url )" as AnyObject)
                self.debugPrint(object: response as AnyObject)
                if let destinationUrl = response.destinationURL {
                    success(destinationUrl)
                } else {
                    failed(APIWrapperGlobalFunctions.internalServerError(
                        response.error?.localizedDescription))
                }
        }
    }
}
// MARK: - RequestAPI
extension APIWrapper {
    /// This function call request API using Amlofire
    ///
    /// - Parameters:
    ///   - success: When there is valid data response
    ///   - failed: failed if any error occur
    private func request(success:@escaping (AnyObject) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        let params = requestModel.parameters?.parameters ?? [:]
        Alamofire.request(requestModel.url, method: requestModel.type, parameters: params, encoding: requestModel.encoding, headers: requestModel.headers).responseJSON { (response) -> Void in
            self.handleResponse(response: response, success: { (responseValue) in
                success(responseValue)
            }, failed: { (error) in
                failed(error)
            })
        }
    }
}
// MARK: - UploadAPI
extension APIWrapper {
    /// This function call request API using Amlofire
    ///
    /// - Parameters:
    ///   - progressValue: this call back return thr % of data uploaded
    ///   - success: When there is valid data response
    ///   - failed: failed if any error occur
    private func upload(progressValue:@escaping(Double) -> Void, success:@escaping (AnyObject) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        if !self.checkInputDataFiles() {
            failed(APIWrapperGlobalFunctions.internalServerError())
            self.debugPrint(object: ErrorMessage.kUnKnownRequest as AnyObject)
            return
        }
        guard let url = URL(string: requestModel.url) else {
            failed(APIWrapperGlobalFunctions.internalServerError())
            self.debugPrint(object: ErrorMessage.kUnKnownRequest as AnyObject)
            return
        }
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = requestModel.type.rawValue
        requestUrl.allHTTPHeaderFields = requestModel.headers
        Alamofire.upload(
            multipartFormData: { multipartformData in
                let   multiPartData = self.creatMultiformDataSet()
                for muliPart in multiPartData {
                    multipartformData.append(muliPart.uploadFile, withName: muliPart.fileName, fileName: muliPart.serverKey, mimeType: muliPart.mimeTypes)
                }
                // add Parameters in multipartdata
                if let parametersDict = self.requestModel.parameters?.parameters {
                    for (key, value) in parametersDict {
                        let newValue = "\(value as AnyObject)"
                        let valueData =  newValue.data(using: String.Encoding(rawValue: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)) ?? Data()
                        multipartformData.append(valueData, withName: key)
                    }
                }
        },
            with: requestUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        upload.uploadProgress { progress in
                            let percentUpload: Double = Double(progress.completedUnitCount/progress.totalUnitCount)
                            self.debugPrint(object: percentUpload as AnyObject)
                            progressValue(percentUpload)
                        }
                        self.handleResponse(response: response, success: { (responseValue) in
                            success(responseValue)
                        }, failed: { (error) in
                            failed(error)
                        })
                    }
                case .failure(let error):
                    self.debugPrint(object: error as AnyObject)
                    failed(APIWrapperGlobalFunctions.internalServerError())
                }
        })
    }
    /// This function check the input upload file count
    ///
    /// - Returns: true if input model is in correct formate
    private func checkInputDataFiles() -> Bool {
        let minimumFileCount = requestModel.multiPartData?.uploadFile?.count ?? 0
        if minimumFileCount != 0 { // There is some file to upload
            if (requestModel.multiPartData?.fileNames?.count ?? 0) == 0 { // atlest one file name should be there
                return false
            } else if (requestModel.multiPartData?.serverKeys?.count ?? 0) == 0 { // atlest one server Keys should be there
                return false
            } else if (requestModel.multiPartData?.mimeTypes?.count ?? 0) == 0 { // atlest one mime Types should be there
                return false
            } else {
                return true // desired input
            }
        } else {
            return true // Nothing to upload
        }
    }
    /// This function create multiform data using Input Model
    ///
    /// - Returns: final object of multipartFormData
    private func creatMultiformDataSet() -> [MultiPartFormData] {
        var multipartData: [MultiPartFormData] = [MultiPartFormData]()
        if let multipartformData = requestModel.multiPartData?.multipartformData {
            multipartData.append(contentsOf: multipartformData)
        }
        guard let uploadFile = requestModel.multiPartData?.uploadFile else {
            return multipartData
        }
        for (index, file) in uploadFile.enumerated() {
            var data: Data?
            var fileName: String = self.getFileName(index: index)
            if file is UIImage {
                let image = file as? UIImage ?? UIImage()
                if fileName == "" {
                    fileName = image.accessibilityIdentifier ?? ""
                }
                data = APIWrapperGlobalFunctions.dataFromImage(image: image, compressionQuality: requestModel.multiPartData?.imageQuality ?? 0.1 )
            } else if file is Data {
                data = file as? Data
            } else if let fileUrl =  file as? String {
                let url = URL(fileURLWithPath: fileUrl)
                if fileName == "" {
                    fileName = self.getFileName(file: url)
                }
                data = self.fetchDataFromFileUrl(fileUrl: url)
            }
            if let filedata = data {
                multipartData.append(self.createMultipartObject(data: filedata, index: index, filename: fileName))
            }
        }
        return multipartData
    }
    func createMultipartObject (data: Data, index: Int, filename: String) -> MultiPartFormData {
        let key = self.getServerName(index: index)
        let mimeName = self.getMimeType(index: index)
        return MultiPartFormData(uploadFile: data, fileName: filename, serverKey: key, mimeTypes: mimeName)
    }
    func fetchDataFromFileUrl(fileUrl: URL) -> Data? {
        if let image    = UIImage(contentsOfFile: fileUrl.path) {
            return APIWrapperGlobalFunctions.dataFromImage(image: image, compressionQuality: requestModel.multiPartData?.imageQuality ?? 0.1 )
        } else {
            do {
                let filedata: Data  = try Data(contentsOf: fileUrl as URL)
                return filedata
            } catch {
                debugPrint(object: "Exception \(error.localizedDescription)" as AnyObject)
                return nil
            }
        }
    }
    /// Function fetch the file name from the file
    ///
    /// - Parameter file: input file
    /// - Returns: file name
    private func getFileName(file: URL?) -> String {
        return file?.absoluteURL.lastPathComponent ?? ""
    }
    /// This function return the Mime type from Mime array of object
    /// If mime name is comman for all the it's return the 1st one
    /// - Parameters:
    ///   - index: data set index
    /// - Returns: mime name
    private func getMimeType(index: Int) -> String {
        let mimes =  self.requestModel.multiPartData?.mimeTypes ?? []
        if index < mimes.count && mimes[index] != "" {
            return mimes[index]
        }
        return mimes[0]
    }
    /// This function return the file name
    /// If name is not given for that index it return blank
    /// - Parameters:
    ///   - index: data set index
    /// - Returns: name
    private func getFileName(index: Int) -> String {
        let serverKey = self.requestModel.multiPartData?.serverKeys ?? []
        if index < serverKey.count && serverKey[index] != "" {
            return serverKey[index]
        } else {
        }
        return ""
    }
    /// This function return the name from  inputObject
    /// If name is comman for all the it's created "<name>[index]" for that index
    /// - Parameters:
    ///   - index: data set index
    /// - Returns: name
    private func getServerName(index: Int) -> String {
        let serverKey = self.requestModel.multiPartData?.serverKeys ?? []
        if index < serverKey.count && serverKey[index] != "" {
            return serverKey[index]
        }
        return "\(serverKey)[\(index)]"
    }
}
// MARK: - Error handling
extension APIWrapper {
    /// This fucnction handle API response off all request
    ///
    /// - Parameters:
    ///   - response: API DataResponse
    ///   - success: Success closer
    ///   - failed: failed closer
    private func handleResponse(response: DataResponse<Any>, success: @escaping (AnyObject) -> Void, failed: @escaping (ErrorResponse) -> Void) {
        debugPrint(object: "API Response for url => \(self.requestModel.url )" as AnyObject)
        self.debugPrint(object: response as AnyObject)
        switch response.result {
        case .success:
            self.handleSuccess(response: response, success: { (responseValue) in
                success(responseValue)
            }, failed: { (error) in
                failed(error)
            })
        case .failure:
            self.debugPrint(object: response.error as AnyObject)
            self.handleErrror(responseData: response, failed: { (error) in
                failed(error)
            })
        }
    }
    /// This funciton handdle the error Success of API
    ///
    /// - Parameters:
    ///   - response: DataResponse from the API
    ///   - success: Success closer
    private func handleSuccess(response: DataResponse<Any>, success: @escaping (AnyObject) -> Void, failed: @escaping (ErrorResponse) -> Void) {
        let responseCode = response.response?.statusCode ?? ResponseCode.kBadRequest
        if ResponseCode.kSuccessRequest.contains(responseCode) {
            success(response.result.value as AnyObject)
        } else {
            self.handleErrror(responseData: response, failed: { (error) in
                failed(error)
            })
        }
    }
    /// This funciton handdle the error response of API
    ///
    /// - Parameters:
    ///   - response: DataResponse from the API
    ///   - failed: Error closer
    private func handleErrror(responseData: DataResponse<Any>, failed: @escaping (ErrorResponse) -> Void) {
        let statusCode = responseData.response?.statusCode ?? ResponseCode.kBadRequest
        var errorMessage = [ErrorMessage.kSomethingWentWrong]
        // Check For Logout
        if checkUnauthorisedAccess(errorCode: statusCode) {
            errorMessage = [ErrorMessage.kUnauthorised]
            APIWrapperGlobalFunctions.handleUnauthorisedAccess()
        } else {
            ///  API request error
            if responseData.error != nil {
                errorMessage = [self.createErrorForFailure(errorCode: statusCode)]
            } else { // DB related error
                errorMessage = self.createErrorForSuccess(responseData: responseData)
            }
        }
        failed(ErrorResponse(
            errorList: errorMessage, errorCode: statusCode,
            errorObject: responseData.result.value as? [String: AnyObject]))
    }
    /// This function check the error code for Unauthorised access
    ///
    /// - Parameter errorCode: API response code
    /// - Returns: true if Unauthorised access else false
    private func checkUnauthorisedAccess(errorCode: Int) -> Bool {
        if errorCode == ResponseCode.kUnauthorised {
            return true
        } else {
            return false
        }
    }
    /// This function return error message in case of API Success
    ///
    /// - Parameter responseData: API responseData
    /// - Returns: error Message
    private  func createErrorForSuccess(responseData: DataResponse<Any>) -> [String] {
        if let reponseValue = responseData.result.value as? [String: AnyObject] {
            return self.fetchErrorFromResponse(reponse: reponseValue)
        } else {
            return [ErrorMessage.kSomethingWentWrong]
        }
    }
    /// This function fetch error from response body
    ///
    /// - Parameter reponse: reponse body as [String : AnyObject]
    /// - Returns: Error String
    private func fetchErrorFromResponse(reponse: [String: AnyObject]) -> [String] {
        var errorValue: AnyObject?
        for messageKey in APIWrapperGlobalFunctions.kErrorMessageKey {
            if let error = reponse[messageKey] {
                errorValue = error
                break
            }
        }
        guard let error = errorValue else {
            return  [ErrorMessage.kSomethingWentWrong]
        }
        if error is String && (error as? String) != ""{
            return [error as? String ?? ErrorMessage.kSomethingWentWrong]
        } else {
            return self.fetchErrorStringFromMulipleErrors(errorDic: error)
        }
    }
    /// This function fetch single error message from multiple errors
    ///
    /// - Parameter errorDic: Error object
    /// - Returns: error Message
    private func fetchErrorStringFromMulipleErrors(errorDic: AnyObject) -> [String] {
        var finalErrors: [String]?
        if errorDic is NSDictionary {
            let errorValueArray = (errorDic as? NSDictionary ?? NSDictionary()).allValues
            if errorValueArray.count != 0 {
                if errorValueArray is [String] {
                    finalErrors = errorValueArray as? [String]
                } else {
                    for items in errorValueArray where items is [String] {
                            if (items as? [String] ?? []).count != 0 && (items as? [String] ?? [])[0] != "" {
                                finalErrors?.append((items as? [String] ?? [])[0])
                            }
                    }
                }
            }
        } else if errorDic is [String] {
            if (errorDic as? [String] ??  [""]).count != 0 {
                finalErrors  = errorDic as? [String]
            }
        }
        finalErrors = finalErrors?.filter { $0 != "" } // remove blank object
        if finalErrors?.count != 0 {
            return finalErrors ?? [ErrorMessage.kSomethingWentWrong]
        }
        return [ErrorMessage.kSomethingWentWrong]
    }
    /// This function return error message in case of API Failure
    ///
    /// - Parameter errorCode: API error code
    /// - Returns: error Message
    private func createErrorForFailure(errorCode: Int) -> String {
        let allKnownErrorCode =  APIWrapperGlobalFunctions.KnownErrorCodes.keys
        if allKnownErrorCode.contains(errorCode) {
            return  APIWrapperGlobalFunctions.KnownErrorCodes[errorCode] ?? ErrorMessage.kSomethingWentWrong
        }
        return ErrorMessage.kSomethingWentWrong
    }
    /// This fucniton print the log if debuging mode is ON
    ///
    /// - Parameter object: print Object
    private func debugPrint(object: AnyObject) {
        if self.isDebugOn {
            print(object)
        }
    }
    /// This function print the request model
    private func printRequestModel() {
        debugPrint(object: "Request Model" as AnyObject)
        debugPrint(object: "URL=> \(requestModel.url)" as AnyObject)
        debugPrint(object: "TYPE=> \(requestModel.type)" as AnyObject)
        debugPrint(object: "PARAMS=> \(String(describing: requestModel.parameters?.parameters))" as AnyObject)
        debugPrint(object: "HEADER=> \(String(describing: requestModel.headers))" as AnyObject)
    }
}
