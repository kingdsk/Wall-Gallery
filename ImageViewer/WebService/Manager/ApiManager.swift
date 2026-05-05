//
//  NewApiManager.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import Foundation
import UIKit
import Moya
import Alamofire

//------------------------------------------------------

//MARK:- API Manager

///Manage and create all type API reqeust.
class ApiManager : TargetType {
    
    var path: String = ""
    
    static var shared = ApiManager()
    
    let provider = MoyaProvider<ApiManager>()
    
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    var requests : [(endPoint : ApiEndPoints , cancellable : Moya.Cancellable)] = []
    
    var headers: [String : String]?
    
    ///Return base url according environment
    var environmentBaseURL : String {
        return APIEnvironment.getUrl(state: NetworkManager.environment).baseurl
    }
    
    // MARK: - baseURL
    var baseURL: URL {
        guard let url  = URL(string: environmentBaseURL) else{
            fatalError("base url could not be configured")
        }
        return url
    }
    
    var method: Moya.Method = .post
    
    // MARK: - parameterEncoding
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    // MARK: - task
    var task: Task {
        let jsonData = try? JSONSerialization.data(withJSONObject: self.parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let encryptedData  : String = jsonString.encryptData()
        
        if method == .get {
            return .requestPlain
        }
        
        return .requestParameters(parameters: [:], encoding: self.method == . post ? encryptedData as ParameterEncoding : URLEncoding.default)
    }
    
    ///Request parameters
    var parameters: [String: Any] = [:]
    
    let debugCryptoLib = CryptLib()
    
    /// Set API headers
    func setHeaders()  {
        var headersToSend : [String : String] = [:]
        headersToSend[ApiKeys.header(.apiKey).value] = ApiKeys.header(.apiKeyValue).value
        //        headersToSend[ApiKeys.header(.KHeaderLanguage).value] = Bundle.main.kCurrentAppLanguage.headerValue
        headersToSend[ApiKeys.header(.contentTypeKey).value] = ApiKeys.header(.contentTypeApplicationTextPlain).value
//        headersToSend[ApiKeys.header(.acceptLanguageKey).value] = ApiKeys.header(.acceptLanguageValue).value.encryptData()
        var selecteLanguage = String()
        headersToSend[ApiKeys.header(.acceptLanguageKey).value] = selecteLanguage
        headersToSend[ApiKeys.header(.appVersionKey).value] = ApiKeys.header(.appVersionValue).value
        headersToSend[ApiKeys.header(.appType).value] = ApiKeys.header(.appTypeValue).value.encryptData()
//        headersToSend[ApiKeys.header(.apiKey).value] = ApiKeys.header(.apiKeyValue).value
//        //        headersToSend[ApiKeys.header(.KHeaderLanguage).value] = Bundle.main.kCurrentAppLanguage.headerValue
//        headersToSend[ApiKeys.header(.contentTypeKey).value] = ApiKeys.header(.contentTypeApplicationTextPlain).value
//        headersToSend[ApiKeys.header(.acceptLanguageKey).value] = ApiKeys.header(.acceptLanguageValue).value
        
        // Pass user login token
//        if AppDelegate.shared.currentUserType == .visitor{
//            if let token = UserModelMember.accessToken, !token.isEmpty {
//                debugPrint("USER LOGIN TOKEN : \(token)")
//                headersToSend[ApiKeys.header(.tokenKey).value] = "\(token)".encryptData()
//            }
//        }else{
            if let token = UserModel.accessToken, !token.isEmpty {
                debugPrint("USER LOGIN TOKEN : \(token)")
                headersToSend[ApiKeys.header(.tokenKey).value] = "\(token)".encryptData()
            }
        
        //
        if self.method == .put {
            headersToSend[ApiKeys.header(.contentTypeKey).value] = ApiKeys.header(.contentTypeApplicationForm).value
        }
        
        self.headers = headersToSend
        print(JSON(self.headers!).dictionaryValue)
    }
    
    /// Make HTTP request with json responce.
    /// - Parameters:
    ///   - endPoint: API URL end point
    ///   - methodType: HTTP method type
    ///   - parameter: HTTP request parameter
    ///   - isErrorAlert: Flag for showing error alert. Default true.
    ///   - isLoader: Flag for showing loader. Default true.
    ///   - isDebug: Falg for print debug info. Default true.
    ///   - completion: Get response of the request with data result.
    func makeRequest(endPoint: ApiEndPoints,
                     methodType: HTTPMethod = .post,
                     parameter: Dictionary<String,Any>?,
                     withErrorAlert isErrorAlert : Bool = true,
                     withLoader isLoader: Bool = true,
                     withdebugLog isDebug: Bool = true,
                     withBlock completion: ((Swift.Result<DataResult,Error>) -> Void)?) {
        
        
        //Assign Value to Moya Parameters
        self.path = endPoint.methodName
        self.parameters = parameter ?? [:]
        self.method = methodType
        
        setHeaders()
        
        if isLoader {
            self.addLoader()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        if isDebug {
            self.manageDebugRequest(parameters: self.parameters)
        }
        
        ///Create request
        let request = provider.request(self) { [weak self] (result) in
            guard let self = self else { return }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if isLoader {
                self.removeLoader()
            }
            
            switch result {
            case .success(let response):
                if response.statusCode == 401 {
                    self.logout()
                    completion?(.failure(ApiCustomError.sessionExpire))
                }
                
                do {
                    guard let res = try response.mapJSON() as? String else {
                        return
                    }
                    
                    var code = ApiKeys.ApiStatusCode.invalidOrFail
                    
                    let resDic  = JSON(res.decryptData().convertToDictionary() as Any)
                    
                    if isDebug {
                        self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                    }
                    
                    
                    if let codeint = ApiKeys.ApiStatusCode.init(rawValue: JSON(resDic["code"].intValue).stringValue) {
                        code = codeint
                    }
                    
                    let responseData = DataResult(data: resDic[ApiKeys.respsone(.data).value],
                                                  httpCode: response.statusCode,
                                                  apiCode: code,
                                                  message: resDic[ApiKeys.respsone(.message).value].stringValue,
                                                  response: resDic)
                    
                    completion?(.success(responseData))
                    
                } catch let error {
                    completion?(.failure(ApiCustomError.invalidData))
                    self.manageErrors(apiName: endPoint.methodName, error: error, isShowAlert: false)
                }
                break
                
            case .failure(let error):
                
                if (error as NSError).code == NSURLErrorCancelled {
                    // Manage cancellation here
                    self.manageErrors(apiName: endPoint.methodName, error: error, isShowAlert: false)
                    completion?(.failure(error))
                    return
                }
                
                self.manageErrors(apiName: endPoint.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(error))
                break
                
            }
            
        }
        
        requests.append((endPoint,request))
    }
    
    /// Make HTTP request with given model responce.
    /// - Parameters:
    ///   - endPoint: API URL end point
    ///   - modelType: Data model
    ///   - methodType: HTTP method type
    ///   - parameter: HTTP request parameter
    ///   - isErrorAlert: Flag for showing error alert. Default true.
    ///   - isLoader: Flag for showing loader. Default true.
    ///   - isDebug: Falg for print debug info. Default true.
    ///   - completion: Get response of the request with data result.
    func makeRequestWithModel<T: Mappable>(endPoint: ApiEndPoints,
                                           modelType: T.Type,
                                           methodType: HTTPMethod = .post,
                                           responseModelType: ResponseModelType = .dictonary,
                                           parameter: Dictionary<String,Any>?,
                                           withErrorAlert isErrorAlert: Bool = true,
                                           withLoader isLoader: Bool = true,
                                           withdebugLog isDebug: Bool = true,
                                           withBlock completion: ((Swift.Result<DataResultModel<T>,Error>) -> Void)?)  {
        
        
        //Assign Value to Moya Parameters
        self.path = endPoint.methodName
        self.parameters = parameter ?? [:]
        self.method = methodType
        
        setHeaders()
        
        if isLoader {
            self.addLoader()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        if isDebug {
            self.manageDebugRequest(parameters: self.parameters)
        }
        
        ///Create request
        let request = provider.request(self) { [weak self] (result) in
            
            guard let self = self else { return }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if isLoader {
                self.removeLoader()
            }
            
            switch result {
            case .success(let response):
                
                if response.statusCode == 401 {
                    self.logout()
                    return
                }
                
                do {
                    guard let res = try response.mapJSON() as? String else {
                        return
                    }
                    
                    var code = ApiKeys.ApiStatusCode.invalidOrFail
                    
                    let resDic  = JSON(res.decryptData().convertToDictionary() as Any)
                    
                    if isDebug {
                        self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                    }
                    
                    if let codeint = ApiKeys.ApiStatusCode.init(rawValue: resDic[ApiKeys.respsone(.code).value].stringValue) {
                        code = codeint
                    }
                    
                    var responseData = DataResultModel<T>.init()
                    
                    switch responseModelType {
                    
                    case .dictonary:
                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value])
                        break
                    case .array:
                        //                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value]["result"]) // If response["data"] is not array type then
                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value]) // if data has direct array value use this
                        break
                    }
                    
                    responseData.message = resDic[ApiKeys.respsone(.message).value].stringValue
                    responseData.apiCode = code
                    responseData.httpCode = response.statusCode
                    responseData.response = resDic
                    completion?(.success(responseData))
                    
                } catch let error {
                    self.manageErrors(apiName: endPoint.methodName, error: error, isShowAlert: false)
                }
                break
                
            case .failure(let error):
                
                if isLoader {
                    self.removeLoader()
                }
                
                if (error as NSError).code == NSURLErrorCancelled || (error as MoyaError)._code == 6{
                    // Manage cancellation here
                    self.manageErrors(apiName: endPoint.methodName, error: error, isShowAlert: false)
                    completion?(.failure(error))
                    return
                }
                
                self.manageErrors(apiName: endPoint.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(error))
                break
            }
        }
        requests.append((endPoint,request))
    }
    
    /// Cancel all HTTP request task
    /// - Parameter url: API end point
    func cancelAllTask(url: ApiEndPoints) {
        provider.session.session.getAllTasks { (tasks) in
            let task = tasks.filter{ $0.currentRequest?.url?.absoluteString == self.baseURL.absoluteString + url.methodName}
            _ =  task.map ({(taskToCancel : URLSessionTask) in
                print("Cancel API")
                taskToCancel.cancel()
            })
        }
    }
}
