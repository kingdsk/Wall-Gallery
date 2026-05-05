//
//  GExtension+UIApplication.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIApplication {
    /**
     Sets home screen
     */
    func setHome() {
        if let homeNavigation = UIStoryboard.home.instantiateViewController(withIdentifier: "NavHome") as? UINavigationController {
            self.setRootController(for: homeNavigation)
        }
    }
    
    /**
     Sets login screen
     */
    func setLogin() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavLogin") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    /**
     Sets tutorial screen
     */
    private func setTutorial() {
        let tutorailVC = UIViewController()
        self.setRootController(for: tutorailVC)
    }
    
    /// Logout user from app and clear all user data from user default
    func logoutAppUser() {
        UserModel.removeCurrentUser()
        // Clear all the user default data from the app, expect remember me data
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != UserDefaults.Keys.authorization && key != UserDefaults.Keys.deviceToken {
                defaults.removeObject(forKey: key)
            }
        }
        
        UserDefaults.standard.synchronize()
        UIApplication.shared.setLogin()
    }
    
    private func setRootController(for rootController: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            // Set the new rootViewController of the window.
            
            window.rootViewController = rootController
            window.makeKeyAndVisible()
            
            // A mask of options indicating how you want to perform the animations.
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            
            // The duration of the transition animation, measured in seconds.
            let duration: TimeInterval = 0.3
            
            // Creates a transition animation.
            // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { completed in
                // Do something on completion here
            })
        }
    }
    
    /**
     Manage user redirection after login, logout and signup
     */
    func manageLogin() {
        // This return is for temp developement
        if UserDefaultsConfig.isAuthorization {
            self.setHome()
        } else {
            self.setLogin()
        }
    }
    
    /// To get top of the view controller
    /// - Parameter controller: Any controller which is need to find top view controller
    /// - Returns: Optional top view controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    /**
     Get safe area insets
     */
    class var safeArea : UIEdgeInsets {
        if UIApplication.shared.windows.count > 0{
            if #available(iOS 11.0, *) {
                return UIApplication.shared.windows[0].safeAreaInsets
            } else {
                return UIEdgeInsets.zero
                // Fallback on earlier versions
            }
        }
        return UIEdgeInsets.zero
    }
    
    /**
     Return true if device has notch
     */
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

extension UIApplication {
    /**
     Get status bar view
     */
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            if let statusBar = self.windows.first?.viewWithTag(tag) {
                self.windows.first?.bringSubviewToFront(statusBar)
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
                statusBarView.tag = tag
                
                self.windows.first?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
