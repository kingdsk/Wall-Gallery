//
//  AppCoordinator.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 02/03/21.
//

import UIKit



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
        
        //Push setup
//        AppDelegate.shared.registerForNotification()
        
        //Network Observer
        ReachabilityManager.shared.startObserving()
    }
}
