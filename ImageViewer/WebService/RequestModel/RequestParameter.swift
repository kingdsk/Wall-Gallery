//
//  RequestParameter.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

///This class for create HTTP request parameter dictionary and add parameter to dictionary
///This class define all request parameter key and get value at key
class RequestParameter {
    
    ///Parameter dictionary
    private var parameterDict: [String: Any] = [:]
    
    ///Parameter dictionary key
    enum Key: String {
        case user_type
        case login_type
        case first_name
        case last_name
        case email
        case device_type
        case device_token
        case password
        case language
        case type
        case user_id
        case otp_code
        case new_password
        case confirm_password
        case latitude
        case longitude
        case address
        case old_password
        case title
        case subject
        case description
        case profile_image
        case page
        case save_type
        case parent_id
        case readstatus
        case id
        case folder_id
        case name
        case is_save_folder
        case item_id
        case is_push
        case rating
        case comment
        case price_event
        case min_distance
        case max_distance
        case price_estate
        case status
        case social_id
        case latlong
        case category_id
        case currency
        case currency_name
        case cultures
        case interests
        
        // Business (Prashant)
        case input_type
        case event_name
        case start_date
        case end_date
        case event_type
        case price_per_person
        case website
        case media
        case property_name
        case city
        case phone
        case price
        case business
        case business_id
        case business_name
        case business_type
        case price_scale
        case language_id
        case working_hours
        case action_type
        case subscription_id
        case payment_method
        case deal_id
        case real_estate_id
        case event_id
        case is_attending
        case other_description
        case country_id
        case business_category
    }
    
    init() {
    }
    
    /// Add parameter to request dictionary
    /// - Parameters:
    ///   - key: Parameter key
    ///   - value: Parameter value
    /// - Returns: Return self request model
    @discardableResult
    func add(_ key: Key, _ value: Any?) -> Self {
        if let value = value {
            self.parameterDict[key.rawValue] = value
        }
        return self
    }
    
    ///Return parameter dictionary
    var getDictionary: [String: Any] {
        self.parameterDict
    }
    
    /// Get value for key
    /// - Parameter key: Parameter key
    /// - Returns: Any value at key
    func getValue(_ key: Key) -> Any? {
        self.parameterDict[key.rawValue]
    }
}
