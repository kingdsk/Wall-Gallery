//
//  AppConstants.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 23/12/20.
//

import Foundation

///Phone pattern for showing mobile number in this formate
let kPhonePattern = "(###) ###-####"

///Character for replacing phone pattern
let kPhonePatternReplaceChar: Character = "#"

///Array of view controller which is we need to disable pop gesture back funcationality
let kDisablePopBackVCS: [AnyObject] = []

///Get current time zone
var kTimeZone: String {
    return TimeZone.current.identifier
}

///Get html string with device data
var kGetAppDetailsString: String {
    """
    <br><br><br>
    ----------------------
    <br>
    Device: \(DeviceManager.shared.modelName)
    <br>
    iOS Version: \(DeviceManager.shared.osVersion)
    <br>
    App Version: \(Bundle.main.displayFullVersion)
    <br>
    ----------------------
    """
}

//MARK: PrefixPostfix
struct PrefixPostfix {
    static let currencySymbol = "$"
    static let durationPostfix = "Min"
    static let currencyName = "Dollar"
    static let distanceUnit = "KM"
    static let percentage = "%"
}
