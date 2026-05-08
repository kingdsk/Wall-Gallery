//
//  GExtension+UIViewController.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import SafariServices
import AVKit

extension UIViewController {
    ///Life Cycle.
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.modalPresentationStyle = .overFullScreen
    }
    
    ///Return status bar height.
    public var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    ///Return top bar height : Navigation bar height + status bar height
    var topbarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
    
    ///Return storyboard identifier
    class var storyboardID : String {
        return "\(self)"
    }
    
    /**
     To get storyboard view controller instantiate
     
     - Parameter appStoryboard: Pass storyboard
     - Returns: View controller
     
     */
    static func instantiate(fromAppStoryboard appStoryboard: UIStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    /**
     To pop / back view controller
     
     - Parameter sender: AnyObject
     */
    
    @IBAction func popViewController(sender : AnyObject) {
        //        Vibration.medium.vibrate()
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     To dismiss view controller
     
     - Parameter sender: AnyObject
     */
    
    @IBAction func dismissViewController(sender : AnyObject) {
        //        Vibration.medium.vibrate()
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     To back root  view controller
     
     - Parameter sender: AnyObject
     */
    @IBAction func popToRootViewController(sender : AnyObject) {
        //        Vibration.medium.vibrate()
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension UIViewController: SFSafariViewControllerDelegate {
    /**
     To open url in safari controller
     
     - Parameter url: Any web url
     */
    func openURL(_ url : String) {
        
        var url = url.url()
        if !(["http", "https"].contains(url.scheme?.lowercased())) {
            let appendedLink = "http://\(url)"
            
            url = appendedLink.url()
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        UIApplication.topViewController()?.present(safariVC, animated: true, completion: nil)
        
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    /**
     To play youtube video in player view controller.
     
     - Parameter urlString: Video url string
     */
    func playYoutubeVideo(with urlString: String) {
        //First get video id from link and make playbel youtube link
        guard let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension UIViewController {

    func showSnackbar(message: String,
                      emoji: String    = "📡",
                      duration: Double = 2.5) {
        guard view.viewWithTag(9991) == nil else { return }

        let snack                = UILabel()
        snack.tag                = 9991
        snack.text               = "  \(emoji)  \(message)  "
        snack.textColor          = .white
        snack.backgroundColor    = UIColor.black.withAlphaComponent(0.85)
        snack.textAlignment      = .center
        snack.font               = UIFont.systemFont(ofSize: 13, weight: .medium)
        snack.layer.cornerRadius = 20
        snack.clipsToBounds      = true
        snack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(snack)

        NSLayoutConstraint.activate([
            snack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            snack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            snack.heightAnchor.constraint(equalToConstant: 40),
            snack.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40)
        ])

        snack.alpha = 0
        UIView.animate(withDuration: 0.3) {
            snack.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: duration) {
                snack.alpha = 0
            } completion: { _ in
                snack.removeFromSuperview()
            }
        }
    }
}
