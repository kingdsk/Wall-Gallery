//
//  ApiKeys.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit

///API Keys
enum ApiKeys {
    case header(ApiHeaderKeysValue)
    case encrypt(EncryptionKeys)
    case respsone(ApiResponseKey)
    case statusCode(ApiStatusCode)
    
    var value: String {
        switch self {
        case .header(let key):
            return key.rawValue
        case .encrypt(let key):
            return key.rawValue
        case .respsone(let key):
            return key.rawValue
        case .statusCode(let key):
            return key.rawValue
        }
    }
}

/// Sets API key values
extension ApiKeys {
    internal enum EncryptionKeys: String {
        case secretKey = "IVk9Sc4aQLEC5htqCxXZC30zV6UG4V4x"
        case iv = "IVk9Sc4aQLEC5htq"
    }
    
    //MARK:- HeaderKeys
    internal enum ApiHeaderKeysValue: String {
        case apiKey = "API-KEY"
        case apiKeyValue = "kFxRuCA8CMqNw6TrYlrZSJjK5HqT+EUJr0ccY+rN+jc="
        // For Local:- "yTPtFMIbH4eXr11ExIyobg=="
        // For Live:- "rc8OSfIrpDekVUM7EuXypg=="
        
        case tokenKey = "TOKEN"
        
        case acceptLanguageKey = "accept-language"
        case acceptLanguageValue = "en"
        
        case contentTypeKey = "content-type"
        case contentTypeApplicationForm = "application/x-www-form-urlencoded"
        case contentTypeApplicationTextPlain = "text/plain"
        
        case appVersionKey = "app_version"
        case appVersionValue = "1.0"
        
        case appType = "app"
        case appTypeValue = "U"
    }
    
    //MARK:- API Key Constant
    internal enum ApiResponseKey: String {
        case data                               = "data"
        case message                            = "message"
        case code                               = "code"
        case userToken                          = "token"
    }
    
    //MARK:- APIStatusCodeEnum
    internal enum ApiStatusCode: String {
        ///Invalid or fail response
        case invalidOrFail              = "0"
        
        ///Sucess response
        case success                    = "1"
        
        ///Empty data record
        case emptyData                  = "2"
        
        ///Inactive account
        case inactiveAccount            = "3"
        
        ///OTP not verify
        case otpVerify                  = "4"
        
        ///Profile not completed
        case completeProfile                = "5"
        
        ///Force app update alert
        case forceUpdateApp             = "6"
        
        ///Simple app update alert
        case simpleUpdateAlert          = "7"
        
        ///User not registerd with social logins
        case socialIdNotRegister        = "14"
        
        case businessUseNotRegistered	   = "16"
        
        case individualuserNotregistered = "15"
        
        ///User session expire
        case userSessionExpire          = "-1"
        
        //update email
        case updateEmail				= "11"
        
        ///Unknown
        case unknown                    = "1000"
    }
}
