//
//  AppCredential.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation

//MARK: App Creadential
enum AppCredential: String {
    case facebookAppID          = "123456"
    case googleClientID         = ".apps.googleusercontent.com/"
    case googleBrowserKey       = "2mrA"
    case googleKey              = "KqwqVes"
    case bundelID               = "com.demo.app"
    case appStoreID             = "123456789"
    case shareapp               = "https://apps.apple.com/in/app/"
    case secretKey				= "0GRzoIjh2p0eT_UeuogAgiKjDzpRPYSJBVC-u-UFNsc"
    static var appStoreLink: String {
        return "itms-apps://itunes.apple.com/app/" + AppCredential.appStoreID.rawValue
    }
}
