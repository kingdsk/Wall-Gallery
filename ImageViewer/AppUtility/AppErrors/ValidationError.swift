//
//  ValidationError.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 03/03/21.
//

import Foundation

extension AppError.Enums {
    enum ValidationError {
        case enterValidEmail
        case enterEmail
        case enterPassword
        case enterName
        case enterValidName
        case enterMinName
        case enterMobileNumber
        case enterMinMobileNumber
        case enterCountryCode
        case enterConfirmPassword
        case passwordMismatch
        case enterMinPassword
        case enterNewPassword
        case enterCurrentPassword
        case enterMinNewPassword
        case enterOTP
        case validOTP
        case custom(errorDescription: String?)
    }
}

extension AppError.Enums.ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .enterValidEmail: return "Please enter valid email"
        case .enterEmail: return "Please enter email"
        case .enterPassword: return "Please enter password"
        case .enterName: return "Please enter name"
        case .enterValidName: return "Please enter valid name"
        case .enterMinName: return "Please enter minimum of two characters in name"
        case .enterMobileNumber: return "Please enter mobile number"
        case .enterMinMobileNumber: return "Please enter minimum 8 and maximum 11 digit for mobile number"
        case .enterCountryCode: return "Please select country code"
        case .enterConfirmPassword: return "Please enter confirm password"
        case .passwordMismatch: return "Password mismatch"
        case .enterMinPassword: return "Please enter minimum of 8 characters for create password"
        case .enterNewPassword: return "Please enter new password"
        case .enterCurrentPassword: return "Please enter current password"
        case .enterMinNewPassword: return "Please enter minimum of 8 characters for new password."
        case .enterOTP: return "Please enter OTP"
        case .validOTP: return "Please enter valid OTP"
        case .custom(let errorDescription): return errorDescription
        }
    }
}
