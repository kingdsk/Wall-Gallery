//
//  UserModel.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import Foundation
import SwiftyJSON

//User model
class UserModel: Mappable {
    
    var accessToken : String!
    var countryCode : String!
    var createdAt : String!
    var deletedAt : String!
    var email : String!
    var id : Int!
    var isLoggedIn : String!
    var mobileNumber : String!
    var name : String!
    var profilePhoto : String!
    var role : String!
    var signupType : String!
    var socialId : String!
    var status : String!
    var updatedAt : String!
    
    var mobileNumberWithCountry: String {
        "+" + JSON(self.countryCode as Any).stringValue.replacingOccurrences(of: "+", with: "") + " - " + JSON(self.mobileNumber as Any).stringValue
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON) {
        if json.isEmpty{
            return
        }
        accessToken = json["access_token"].stringValue
        countryCode = json["country_code"].stringValue
        createdAt = json["created_at"].stringValue
        deletedAt = json["deleted_at"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        isLoggedIn = json["is_logged_in"].stringValue
        mobileNumber = json["mobile_number"].stringValue
        name = json["name"].stringValue
        profilePhoto = json["profile_photo"].stringValue
        role = json["role"].stringValue
        signupType = json["signup_type"].stringValue
        socialId = json["social_id"].stringValue
        status = json["status"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if accessToken != nil{
            dictionary["access_token"] = accessToken
        }
        if countryCode != nil{
            dictionary["country_code"] = countryCode
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deletedAt != nil{
            dictionary["deleted_at"] = deletedAt
        }
        if email != nil{
            dictionary["email"] = email
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isLoggedIn != nil{
            dictionary["is_logged_in"] = isLoggedIn
        }
        if mobileNumber != nil{
            dictionary["mobile_number"] = mobileNumber
        }
        if name != nil{
            dictionary["name"] = name
        }
        if profilePhoto != nil{
            dictionary["profile_photo"] = profilePhoto
        }
        if role != nil{
            dictionary["role"] = role
        }
        if signupType != nil{
            dictionary["signup_type"] = signupType
        }
        if socialId != nil{
            dictionary["social_id"] = socialId
        }
        if status != nil{
            dictionary["status"] = status
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
}



extension UserModel {
    /**
     Return true if user is gurst user
     */
    static var isGuestUser : Bool {
        return !(UserModel.isUserLoggedIn && UserModel.isVerifiedUser)
    }
    
    /**
     Return true if user loggedin
     */
    static var isUserLoggedIn : Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.currentUser) != nil
    }
    
    /**
     Return true if verified by OTP
     */
    static var isVerifiedUser : Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.authorization) != nil
    }
    
    /**
     Return current loggedin user data and set data
     */
    static var currentUser : UserModel? {
        set{
            guard let unwarrapedKey = newValue else {
                return
            }
            UserDefaults.standard.set(unwarrapedKey.toDictionary(), forKey: UserDefaults.Keys.currentUser)
            UserDefaults.standard.synchronize()
            
        } get {
            guard let userDict =  UserDefaults.standard.object(forKey: UserDefaults.Keys.currentUser) else {
                return nil
            }
            return UserModel(fromJson: JSON(userDict))
        }
    }
    
    /**
     Return and sets login user token for session management
     */
    static var accessToken: String? {
        set{
            guard let unwrappedKey = newValue else{
                return
            }
            UserDefaults.standard.set(unwrappedKey, forKey: UserDefaults.Keys.accessToken)
            UserDefaults.standard.synchronize()
            
        } get {
            return UserDefaults.standard.value(forKey: UserDefaults.Keys.accessToken) as? String
        }
    }
    
    /**
     Remove all current user login data
     */
    class func removeCurrentUser(){
        if UserDefaults.standard.value(forKey: UserDefaults.Keys.currentUser) != nil {
            UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.currentUser)
            UserDefaults.standard.synchronize()
        }
    }
}

//Device data model
class Device {
    
    var deviceToken : String!
    var deviceType : String!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        userId = json["user_id"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}

//Data model for save user login credential for remember me
struct RememberMeData: Codable {
    let email: String!
    let password: String
}
