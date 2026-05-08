//
//  AppMessages.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation

//MARK: AppMessages
struct AppMessages {
    static let invalidOTP                 = "Invalid OTP"
    static let resendOTP                  = "OTP has been sent to your registered email"
    static let carrierNotAvailable        = "Carrier service not available"
    static let registerMessage            = "Are you sure you want to register in this webinar?"
    static let unregisterMessage          = "Are you sure you want to unregister from this webinar?"
    static let registerdSucess            = "You have successfully registered"
    static let unregisterdSucess          = "You have successfully unregistered"
    static let logoutMessage              = "Are you sure you want to log out?"
    static let copyURLToClipBoard         = "Copied to clipboard"
    static let deleteNotification         = "Are you sure you want to delete notification?"
    static let passwordUpdate             = "Password change successfully"
    static let profileUpdate              = "Profile updated successfully"
    static let passwordReset              = "Password reset link has been sent successfully to your email id"
    static let internetConnectionMsg      = "Please, check your internet connection"
    static let errorOccurred              = "Error occurred ! Please try again"
    static let somethingWentWrong         = "Something went wrong"
    static let imagepickerHeading         = "CHOOSE IMAGE FROM"
    static let imagepickerHeadingForVideo = "CHOOSE VIDEO FROM"
    static let mediaHeading               = "CHOOSE MEDIA FROM"
    static let imagepickerCamera          = "Camera"
    static let imagepickerGallery         = "Gallery"
    static let imagepickerCameraError     = "Camera not supported"
    static let closeBookScan              = "You will lose the scanned content. Go back to rescan?"
    static let ok                         = "Ok"
    static let cancel                     = "Cancel"
    static let set                        = "Set"
    static let yes                        = "Yes"
    static let no                         = "No"
    static let dontAllow                  = "Don't Allow"
}

struct AppStrings {
    
    //Launch Screen
    static let wallGalleryTitle = "Wall Gallery"
    static let wallgalleryDescription = "Access thousands of curated high-resoultion images from aroung the world"
    static let signInWithGoogle = "Signin with Google"
    static let loginSuccessful = "Login successful!!"
    
    // Home Screen
    static let discoverTitle             = "Discover"
    static let highResolutionTitle       = "High-resolution images"
    static let liveFeedTitle             = "Live Feed"
    static let offlineTitle              = "Offline Feed"
    static let photographerTitle         = "Photographer"
    static let backOnlineMessage         = "Back online! Loading fresh feed."
    static let offlineSnackMessage       = "You're offline. Showing cached images."
    static let noInternetNoCacheMessage  = "You're offline and no cached images are available.\nPlease connect to the internet."
    static let stillNoInternetMessage    = "Still no internet.\nPlease check your connection and try again."
    static let retryTitle                = "Retry"
    
    //Profile Screen
    static let nameTitle = "Name"
    static let emailTitle = "Email"
    static let logoutTitle = "Logout"
    static let logoutMesasge = "Are you sure you want to logout?"
    static let cancelTitle = "Cancel"
}
