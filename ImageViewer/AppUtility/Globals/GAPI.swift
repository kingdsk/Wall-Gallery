//
//  GAPI.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 10/10/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation

///Gloabl API for used API in whole project
class GlobalAPI : NSObject {
    
    ///Shared instance
    static let shared : GlobalAPI = GlobalAPI()
    
    
    /**
     This api for update device data.
     
     ### End point
     device
     
     ### Method
     POST
     
     ### Required parameters
     device_type (A or I), device_token
     */
//    func apiUpdateDeviceData() {
//        
//        let requestParam = RequestParameter()
//            .add(.device_token, DeviceManager.shared.deviceToken)
//            .add(.device_type, DeviceManager.shared.deviceType)
//        
//        ApiManager.shared.makeRequest(endPoint: .user(.device), methodType: .post, parameter: requestParam.dictionaryValue, withLoader: false){ (result) in
//            
//            switch result {
//            case .success(let apiData):
//                
//                switch apiData.apiCode {
//                
//                case .success:
//                    print("Update device data successfully.....")
//                    
//                default: break
//                }
//                
//            case .failure(let error):
//                print("the error \(error)")
//            }
//        }
//    }
}
