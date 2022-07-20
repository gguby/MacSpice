//
//  NetworkAPI.swift
//  IosFreeRDP
//
//  Created by y2k on 2021/03/25.
//

//import UIKit
import Alamofire
import SwiftyJSON
import Reachability

class NetworkAPI: NSObject {
    public static var shared: NetworkAPI = {
        let instance = NetworkAPI()
        print("instance = \(instance)")
        return instance
    }()
    
    public static var sessionManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://192.168.162.16:31019": .disableEvaluation,
            "192.168.162.16": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10  // 타임아웃
        let manager = Alamofire.SessionManager(
            configuration: configuration,
            delegate: SessionDelegate(),
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }()
    
    func checkReachability() -> Bool {
        do {
            let reachability = try Reachability()
            if(reachability.connection == .unavailable) {
                return false
            }
        } catch {
            
        }
        return true
    }
    
    public func requestAPI(strURL: String, parameters:Parameters? = nil, httpMethod: HTTPMethod = .post, headers: HTTPHeaders? = nil, isResponseHeader: Bool = false,  success: @escaping (JSON, [AnyHashable : Any]) -> Void, failure: ((Bool) -> Void)? = nil) {
        
        if !checkReachability() {
            CHAlertView.shared.showAlert(title: "연결 에러", msg: "인터넷 연결 상태를 확인해주세요", successCompletion: {
                if let failure = failure {
                    failure(true)
                }
            })
            return
        }
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: URL = URL(string: strURL)!

        print("---> NetworkAPI: strURL: \(strURL)")
        print("---> NetworkAPI: parameters: \(String(describing: parameters))")
        print("---> NetworkAPI: headers: \(String(describing: headers))")

//        let encoding: ParameterEncoding = URLEncoding.init(arrayEncoding: .noBrackets)
        NetworkAPI.sessionManager.request(url, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
            
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch(response.result) {
            case .success(_):
                let value2 = String(data: response.data!, encoding: .utf8)
                print(value2 as Any)
                if let data = value2!.data(using: .utf8) {
                    if let json = try? JSON(data: data) {
                        success(json, response.response?.allHeaderFields ?? [:])
                        return
                    }
                }
                
                if isResponseHeader {
                    success([:], response.response?.allHeaderFields ?? [:])
                    return
                }
                
                CHAlertView.shared.showAlert(msg: "네트워크 상태가 불안하니 잠시 후에 다시 사용하시기 바랍니다.", successCompletion: {
                    if let failure = failure {
                        failure(true)
                    }
                })
                break
            case .failure(_):
//                print("Error message:\(String(describing: response.error?.errorDescription))")
                CHAlertView.shared.showAlert(msg: "네트워크 상태가 불안하니 잠시 후에 다시 사용하시기 바랍니다.", successCompletion: {
                    if let failure = failure {
                        failure(true)
                    }
                })
                break
            }
        }
    }
}
