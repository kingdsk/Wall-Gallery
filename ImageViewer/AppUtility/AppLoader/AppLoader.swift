//
//  AppLoader.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit
import Lottie

class AppLoader {
    
    //MARK: Shared Instance
    static let shared: AppLoader = AppLoader()
    
    //MARK: Class Variables
    private let viewBGLoder: UIView = UIView()
    private var loaderAnimation: LottieAnimationView = LottieAnimationView(name: "loader_animation")
    
    //MARK: Class Funcation
    
    /**
     Add app loader
     */
    func addLoader() {
        removeLoader()
        self.viewBGLoder.frame = UIScreen.main.bounds
        self.viewBGLoder.tag = 1307966
        self.viewBGLoder.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.loaderAnimation.backgroundColor = .clear
        self.loaderAnimation.loopMode = .loop
        self.loaderAnimation.frame = CGRect(x: (ScreenSize.width/2)-50, y: (ScreenSize.height/2)-50, width: 100, height: 100)
        self.loaderAnimation.backgroundBehavior = .pauseAndRestore
        self.loaderAnimation.play()
        
        self.viewBGLoder.addSubview(self.loaderAnimation)
        UIApplication.shared.windows.first?.addSubview(self.viewBGLoder)
        UIApplication.shared.windows.first?.isUserInteractionEnabled = false
    }
    
    /**
     Remove app loader
     */
    func removeLoader() {
        UIApplication.shared.windows.first?.isUserInteractionEnabled = true
        self.loaderAnimation.stop()
        self.loaderAnimation.removeFromSuperview()
        self.viewBGLoder.removeFromSuperview()
        UIApplication.shared.windows.first?.viewWithTag(1307966)?.removeFromSuperview()
    }
}
