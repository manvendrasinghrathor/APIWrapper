//
//  APIWrapperErrors.swift
//  ModelAPP
//
//  Created by Manvendra on 05/11/18.
//  Copyright © 2018 Manvendra. All rights reserved.
//

import Foundation
import UIKit
/// This stucture contains all the Error Message
struct ErrorMessage {
    static let kUnKnownRequest = "Undefined Model" // Only for developer
    static let kSomethingWentWrong = "Something went wrong. Please try again in sometime."
    static let kSessionExpired = "Your session has expired. Please log in again"
    static let KNoNetwork = "Network unavailable. Please connect to a Wi-Fi or cellular network."
}
/// This structure has error code for specific errors, Developer can change this code according to their requirement
struct ResponseCode {
    static let kSuccessRequest  =  (200 ... 299)
    static let kUnauthorised = 401
    static let kBadRequest = 500
}

/// The developer can modify this Model according to their requirement
public struct APIWrapperGlobalFunctions {
    static let KnownErrorCodes : [Int : String] = [ResponseCode.kUnauthorised : ErrorMessage.kSessionExpired]
    static let kErrorMessageKey = ["msg","message"]
    /// It's a custome function, To handle the Unauthorised access
   static func handleUnauthorisedAccess(){
        print("LOGOUT handler call")
    }
    /// This function return the data from Imgae
    ///
    /// - Parameters:
    ///   - image: Input Image
    ///   - compressionQuality: compression quality
    /// - Returns: data of that image
    static func dataFromImage(image : UIImage , compressionQuality : Float) -> Data? {
        return image.jpegData(compressionQuality: CGFloat(compressionQuality))
    }
}

