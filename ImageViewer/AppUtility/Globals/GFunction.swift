//
//  GFunction.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation
import MessageUI
import Siren

@objc class GFunction: UIViewController {
    
    ///Shared instance
    static let shared: GFunction = GFunction()
    
    //------------------------------------------------------
    //MARK: - Date
    
    /// Return date after add hours and minute to current date
    ///
    /// - Parameters:
    ///   - hour: Hour for add in current date
    ///   - minute: Minute for add in current date
    ///
    /// - Returns: Return current date after adding given hour and minute
    func setMinMaxDate(hour: Int, minute: Int) -> Date {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components1 = gregorian.components(NSCalendar.Unit(rawValue: UInt(NSIntegerMax)), from: Date())
        components1.hour = hour
        components1.minute = minute
        return gregorian.date(from: components1)!
    }
    
    //------------------------------------------------------
    
    //------------------------------------------------------
    //MARK: - sharing
    
    /// Open share sheet controller
    ///
    /// - Parameters:
    ///   - vc: View controller
    ///   - link: Any link or string for sharing
    func share(vc : UIViewController, link : String) {
        //        let url = NSURL(string: link)!
        let controller = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        vc.present(controller, animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    //MARK: - Backspace
    
    /// To check if input string is backspace or not
    ///
    /// - Parameters:
    ///   - inputString: String to check is backspace or not
    /// - Returns: Return true if string is backspace else false
    func isBackspace(_ inputString : String) -> Bool {
        let  char = inputString.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        } else {
            return false
        }
    }
    
    //------------------------------------------------------
    //MARK: App Update Alert
    
    /// To show alert for app update
    ///
    /// - Parameters:
    ///   - update: App update results data
    func appUpdateAvailable(_ update : UpdateResults) {
        debugPrint("Update available")
        if let appName = Bundle.main.displayName {
            let text = "A new version of " + appName + " is available. Please update to version " + update.model.version + " now."
            let alertControl = UIAlertController(title: "Update Available", message: text, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(AppCredential.appStoreID.rawValue)"),
                   UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Next Time", style: .default) { (action) in
                
            }
            
            alertControl.addAction(cancelAction)
            alertControl.addAction(updateAction)
            if let topVC = UIApplication.topViewController(){
                topVC.present(alertControl, animated: true, completion: nil)
            }
        }
    }
    
    //------------------------------------------------------
    //MARK: Open system call pad
    
    /// Open system call dilog
    /// - Parameter number: Call number string
    func makeCall(_ number: String = "1234567890") {
        var phoneNumber : String = "telprompt://\(number)"
        phoneNumber = self.makeValidNumber(phoneNumber)
        
        if let url = URL(string: phoneNumber), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            Alert.shared.showSnackBar(AppMessages.carrierNotAvailable)
        }
    }
    
    /// Validate phone number
    /// - Parameter phoneNumber: Call number string
    /// - Returns: Return proper valid number string
    private func makeValidNumber(_ phoneNumber : String) -> String {
        var number : String = phoneNumber
        number = number.replacingOccurrences(of: "+", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        number = number.trimmingCharacters(in: .whitespacesAndNewlines)
        return number
    }
    
    //------------------------------------------------------
    //MARK: Send mail
    
    /// Open mail app with predefine with given mail id, body and subject
    /// - Parameters:
    ///   - mail: Mail id which is to send
    ///   - body: Mail body
    ///   - subject: Mail subject
    func sendMail(to mail: String, with body: String, subject: String) {
        //Open mail app if avaialbe else open it open in browser.
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([mail])
            mailController.setMessageBody(body, isHTML: true)
            mailController.setSubject(subject)
            if let topVC = UIApplication.topViewController() {
                topVC.present(mailController, animated: true)
            }
        } else {
            let subject = subject
            let coded = "mailto:\(mail)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: coded!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    //------------------------------------------------------
    //MARK: Google map redirection
    
    /// Open google map redirection app
    /// - Parameters:
    ///   - lat: Latitude
    ///   - long: longitude
    func openGoogleMap(_ lat: String, _ long: String) {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(lat),\(long)&zoom=18&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
            
        } else {
            let url = URL(string: "https://maps.google.com/?q=@\(lat),\(long)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
            print("Can't use comgooglemaps://")
        }
    }
}

//MARK:- MFMailComposeViewControllerDelegate Delegate
extension GFunction: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
