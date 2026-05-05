//
//  GExtension+UINavigationController.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UINavigationController : UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.modalPresentationStyle = .overFullScreen
    }

    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationItem.setHidesBackButton(true, animated: true)
        clearNavigation()
        setLargeNavigation()
    }
    
    func clearNavigation(font: UIFont = UIFont.customFont(ofType: .medium, withSize: 16.0), textColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), navigationColor: UIColor = .clear, largeTitleColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font : font]
        
        self.navigationBar.backgroundColor = navigationColor
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.isOpaque = true
        self.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setValue(true, forKey: "hidesShadow")
        
        if let statusBarView = UIApplication.shared.statusBarUIView {
            statusBarView.backgroundColor = navigationColor
        }
        
        //add shdow
        self.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        self.navigationBar.layer.shadowRadius = 5.0
        self.navigationBar.layer.shadowOpacity = 0.6
        self.navigationBar.layer.masksToBounds = false
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: largeTitleColor, NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 30.0)]
    }
    
    func setThemeNavigation() {
        clearNavigation(textColor: .white, navigationColor: #colorLiteral(red: 0.2156862745, green: 0.3882352941, blue: 0.9490196078, alpha: 1))
    }
    
    func setLargeNavigation (_ isLarge : Bool = false) {
        if isLarge {
            self.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
            
        } else {
            self.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 {
            return false
        }
        if let topVC = UIApplication.topViewController() {
            for vc in kDisablePopBackVCS{
                if topVC.isKind(of: vc as! AnyClass){
                    return false
                }
            }
        }
        return true
    }
}
