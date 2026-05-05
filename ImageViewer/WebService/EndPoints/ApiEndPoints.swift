//
//  ApiEndPoints.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit

/// ApiEndPoints - This will be main api points
enum ApiEndPoints {
    case auth(Authentication)
    case user(User)
    case service(Service)
    case businessUser(BusinessUser)
    case imageUpload(ImageUpload,[UIImage],String)
    case videoUpload(ImageUpload,[URL],String)
    case serviceProvider(ServiceProvider)
    
    /// API methods name.
    var methodName : String {
        switch self {
        case .auth(let auth):
            return "auth/" + auth.rawValue
        case .user(let user):
            return "user/" +  user.rawValue
        case .service(let service):
            return "service/" + service.rawValue
        case .businessUser(let businessUser):
            return "business_user/" + businessUser.rawValue
        case .imageUpload(let imageUpload,_,_):
            return "imageupload/" + imageUpload.rawValue
        case .videoUpload(let videoUpload,_,_):
            return "imageupload/" + videoUpload.rawValue
        case .serviceProvider(let serviceProvider):
            return "service_provider/" + serviceProvider.rawValue
        
        }
    }
}
enum Authentication: String {
    case signup					= "signup"
    case userDetails				= "user_detail"
    case verifyOtp					= "verify_otp"
    case resend_otp				= "resend_otp"
    case login					= "login"
    case forgot_password			= "forgot_password"
    case reset_password				= "reset_password"
    case change_password			= "change_password"
    case logOut					= "logout"
    case deleteAccount				= "delete_account"
    case contactUs					= "contactus"
    case updateDeviceInfo			= "update_device_info"
    case editProfile				= "edit_profile"
    case updateLocation				= "update_location"
    case countryList				= "country_list"
}

// Business (Prashant)
enum BusinessUser: String {
    case inputEvent                = "input_event"
    case inputBusiness            	= "input_business"
    case inputRealEstate           	= "input_real_estate"
    case inputDeals               	= "input_deal"
    case addSubscription           	= "add_subscription"
    case subscriptionList          	= "subscription_list"
    case userSubscriptionList      	= "user_subscription_list"
    case chooseAction             	= "choose_action"
    case addedBusinessList        	= "added_business_list"
    case totalPostLeft             = "total_postleft"
}
/// User Endpoints
enum User: String {
    case saved					= "saved"
    case updatedeviceinfo			= "update_device_info"
    case saveList					= "save_list"
    case folder_list              	= "folder_list"
    case addFolder                	= "input_folder"
    case moveToFolder				= "move"
    case addReview                	= "add_review"
    case folderSavedDetails			= "folder_save_deatils"
    case attendEvent				= "attend_event"
    case businessListUser			= "business_list_user"
    case recent_category			= "recent_category"
}

enum Home: String {

    case addwalletcredits         	= "addwalletcredits"
}

/// Service Endpoints
enum Service: String {
    case eventList					= "event_list"
    case dealList					= "deal_list"
    case realEstatelist				= "real_estate_list"
    case businessList				= "business_list"
    case notificationListing			= "notification_listing"
    case clearNotification			= "clear_notification"
    case eventDetails				= "event_details"
    case dealsDetails				= "deals_details"
    case realestateDetails			= "realestate_details"
    case businessDealList			= "business_deal_list"
    
    // Business (Prashant)
    case masterCategory           	= "master_category"
    case businessDetails           	= "business_details"
    case sendNotification          	= "send_notification"
    case notificationCount         	= "notification_count"
}

/// ImageUpload Endpoints
enum ImageUpload: String{
    case userprofileimageupload 		= "userprofileimageupload"
    case spprofileimageupload 		= "spprofileimageupload"
    case adspostmediaupload 			= "adspostmediaupload"
}


// Service Provider endpoints
enum ServiceProvider: String{
    case login 					= "login"
    case forgotpin 				= "forgotpin"
    case signup 					= "signup"
    case resend_otp 				= "resend_otp"
    case verify_otp 				= "verify_otp"
    case completeprofile 			= "completeprofile"
    case editprofile 				= "editprofile"
    case changepin 				= "changepin"
    case updatelocation 			= "updatelocation"
    case updatedeviceinfo 			= "updatedeviceinfo"
    case logout 					= "logout"
    case getspdetails 				= "getspdetails"
    case setprices 				= "setprices"
    case setavailability 			= "setavailability"
    case addpostads 				= "addpostads"
    case updatepostads 				= "updatepostads"
    case myadpostlist 				= "myadpostlist"
    case getadpostdetails 			= "getadpostdetails"
    case removeadspost 				= "removeadspost"
    case buysubscription 			= "buysubscription"
    case renewsubscription 			= "renewsubscription"
    case addwalletcredits 			= "addwalletcredits"
    case mypromotions 				= "mypromotions"
    case promotiondetails 			= "promotiondetails"
    case getpromotionavailabledates 	= "getpromotionavailabledates"
    case getpromotionbookeddates 		= "getpromotionbookeddates"
    case myadpostcount  			= "myadpostcount"
}
