//
//  APIWrapperErrors.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
/// This stucture contains all the Error Message
struct ErrorMessage {
    static let kUnKnownRequest = "Undefined Model" // Only for developer
    static let kSomethingWentWrong = "Something went wrong. Please try again in sometime."
    static let KNoNetwork = "Network unavailable. Please connect to a Wi-Fi or cellular network."
    static let kBadRequest =  "Please check the inputs then try again."
    static let kUnauthorised = "Your session has expired. Please log in again."
    static let Forbidden = "You don't have permission for this request."
    static let NotFound = "The request you are looking for is unavailable."
    static let InternalServerError = "Currently, the server is down. Please try after some time."
    static let NotImplemented = "Currently, Server can't accept these request. Please change the request."
}
/// This structure has error code for specific errors, Developer can change this code according to their requirement
struct ResponseCode {
    static let kSuccessRequest  =  (200 ... 299)
    static let kBadRequest = 400
    static let kUnauthorised  = 401
    static let Forbidden = 403
    static let NotFound = 404
    static let InternalServerError = 500
    static let NotImplemented = 501
}
/// The developer can modify this Model according to their requirement
public struct APIWrapperGlobalFunctions {
    static let KnownErrorCodes: [Int: String] = [
        ResponseCode.kBadRequest: ErrorMessage.kBadRequest,
        ResponseCode.kUnauthorised: ErrorMessage.kUnauthorised,
        ResponseCode.Forbidden: ErrorMessage.Forbidden,
        ResponseCode.NotFound: ErrorMessage.NotFound,
        ResponseCode.InternalServerError: ErrorMessage.InternalServerError,
        ResponseCode.NotImplemented: ErrorMessage.NotImplemented]
    static let kErrorMessageKey = ["message", "msg","error"]
    /// It's a custome function, To handle the Unauthorised access
   static func handleUnauthorisedAccess() {
        print("LOGOUT handler call")
    }
    /// This function return the data from Imgae
    ///
    /// - Parameters:
    ///   - image: Input Image
    ///   - compressionQuality: compression quality
    /// - Returns: data of that image
    static func dataFromImage(image: UIImage, compressionQuality: Float) -> Data? {
        return image.jpegData(compressionQuality: CGFloat(compressionQuality))
    }
    /// This function check network connectivity
    ///
    /// - Returns: true if network is connected
   static func isNetworkConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    static func noNetworkError() -> ErrorResponse {
        return ErrorResponse(errorList: [ErrorMessage.KNoNetwork],
                             errorCode: ResponseCode.kBadRequest)
    }
    static func internalServerError(_ error: String? = nil) -> ErrorResponse {
        return ErrorResponse(errorList: [error ?? ErrorMessage.kSomethingWentWrong],
                             errorCode: ResponseCode.InternalServerError)
    }
}

