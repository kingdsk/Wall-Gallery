//
//  AppCoordinator.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 02/03/21.
//

import UIKit

// This is for handel keyboard
@_exported import IQKeyboardManagerSwift

// This is for handel optional data
@_exported import SwiftyJSON

// This is for logs
import QorumLogs

// This is for app update
import Siren

class AppCoordinator: NSObject {
    
    func basicAppSetup() {
        //Application setup
        UIApplication.shared.windows.first?.isExclusiveTouch = true
        UITextField.appearance().tintColor = UIColor.themeYellow
        UITextView.appearance().tintColor = UIColor.themeYellow
        
        let alertView = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertView.tintColor = UIColor.black
        
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        //manage login
//        if #available(iOS 13.0, *) {
//            
//        } else {
            UIApplication.shared.manageLogin()
//        }
        
        //Google sign in init
        //        GIDSignIn.sharedInstance().clientID = AppCredential.googleClientID.rawValue
        
        // AWS Image upload configration
        AWSUploadManager.shared.configure()
        
        //IQKeyboard Setup
        self.setUpIQKeyBoardManager()
        
        //Push setup
//        AppDelegate.shared.registerForNotification()
        
        //Network Observer
        ReachabilityManager.shared.startObserving()
        
        QorumLogs.enabled = true
    }
    
    private func setUpIQKeyBoardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
