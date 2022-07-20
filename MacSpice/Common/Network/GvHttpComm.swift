//
//  GvHttpComm.swift
//  iOSLauncher
//
//  Created by yongdae park on 2018. 8. 6..
//  Copyright © 2018년 Gloovir. All rights reserved.
//

import Alamofire
import SwiftyJSON
//import SwiftProtobuf

class GvHttpComm : NSObject {
    static var DEF_APIGW_URL:String = "http://1.255.151.203:31003"
    static var DEF_LOGSVR_URL:String = "http://1.255.151.197:11004"
    static var DEF_APIGW_TOKEN:String = "062s08Y9Yjpw293lZ6it37z33e34E9SN38d0"
    static var DEF_VPCID:String = "06c1a912-a12f-11e8-b568-0800200c9a66"
    
    static var DEF_TOKEN_UPDATE_DUR:TimeInterval = (9*60)
    static var TOKEN_EXPIRE_DUR:Int = (10*60)
    
    static private var scheTimer:Timer?
    static private var lastTokenUpdated:Int = Util.getCurTsMs()
    
    //need update before use
    static var apigwUrl:String?
    static var vpcId:String?
    static var apigwToken:String?
    static var logsvrUrl:String?
    static var viewerType:String?
    
    static private func makeUUID() -> String {
        return Util.getDeviceUUID()
    }

    static private func defApigwHdr(useJson:Bool = true) -> HTTPHeaders {
        var ret: HTTPHeaders = [
            "X-CloudPC-Request-ID": makeUUID(),
            "Authorization": apigwToken ?? DEF_APIGW_TOKEN,
            "X-CloudPC-Request-Poc": "POCVM"
        ]
        if useJson {
            ret["Content-Type"] = "application/json"
        }
        return ret
    }
    
    //개발용으로만 사용되어야 함, USER Portal을 사용할 수 없는 환경일 때 필요.
    static func getTokenDirect() {
        
        let url = "http://1.255.151.135:31019/v1/gw/authentications/"
        let hdrs = defApigwHdr()
        let params:[String:Any] = [
            "acct_conn_id" : "user20",
            "passwd" : "1111",
            "usr_tnt_grp_id" : "SEOUL"
        ]
        
        NetworkAPI.sessionManager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: hdrs)
            .responseJSON { response in
                
                if let responseCode = response.response?.statusCode {
                    print("responsecode: \(responseCode)")
                }
                
                guard let responseCode = response.response?.statusCode, responseCode == 200 else {
                    //fail to get token..
                    return
                }
                
                if let hdrs = response.response?.allHeaderFields {
                    print("hdr: \(hdrs)")
                    if let auth = hdrs["Authorization"] {
                        apigwToken = auth as? String
                        print("authorization: \(String(describing: apigwToken))")
                    }
                }
        }
    }
    
    static func apigwGetConnInfo(completion: @escaping (_ result:Bool, _ data:JSON?) -> Void) {
        if apigwUrl == nil {
            apigwUrl = DEF_APIGW_URL
        }
        
        if vpcId == nil {
            vpcId = DEF_VPCID
        }
        
        /* GLV_2ND
            api 게이트웨이 프로토콜 변경 지원
        */
        if(viewerType == nil) {
            let url = (apigwUrl ?? "") + "/v1/cb/connections/vpcs"
            let hdrs = defApigwHdr()
            let params:[String:Any] = ["vpc_id" : vpcId ?? ""]

            NetworkAPI.shared.requestAPI(strURL: url, parameters: params, httpMethod: .post, headers: hdrs, success: { (json, _) in
                print("conn info\n\(json)")
                guard json["data"].exists() else {
                    if json["error"].exists() {
                        let code = json["error"]["code"].string ?? ""
                        let reason = json["error"]["reason"].string ?? ""
                        print("[ERROR] code: \(code), reason: \(reason)")
                    }
                    completion(false, json["data"])
                    return
                }

                completion(true, json["data"])
            })
        } else {
            let url = (apigwUrl ?? "") + "/sm/v1/cloudpc/vpcs/\(vpcId ?? "")/connection"
            let uuid = Util.getDeviceUUID()
            let ip = Util.ipAddress() ?? "0.0.0.0"
            let hdrs: HTTPHeaders = [
                "X-CloudPC-Request-ID": makeUUID(),
                "Authorization": apigwToken ?? DEF_APIGW_TOKEN,
                "X-Client-Type": "ios",
                "X-Client-Sid": uuid,
                "X-Client-Ip": ip
            ]
            let params:[String:Any] = [
                "vpc_id" : vpcId ?? ""
            ]

            NetworkAPI.shared.requestAPI(strURL: url, parameters: params, httpMethod: .post, headers: hdrs, success: { (json, _) in
                print("conn info\n\(json)")
                guard json["retObj"].exists() else {
                    print("Ret Code : \(json["retCode"].string ?? ""), msg : \(json["retMsg"].string ?? "")")
                    completion(false, json["data"])
                    return
                }
                completion(true, json["retObj"]["data"])
            }, failure: {_ in
                completion(false, nil)
            })
        }
    }
    
    @objc static func updateToken(vc:NSViewController) {
        if apigwUrl == nil {
            apigwUrl = DEF_APIGW_URL
        }

        let url = apigwUrl! + "/v1/refreshToken"
        let hdrs = defApigwHdr(useJson: false)

        var respSuccess = false

        NetworkAPI.shared.requestAPI(strURL: url, parameters: nil, httpMethod: .get, headers: hdrs, isResponseHeader: true, success: { (json, header) in
            
            print("hdr: \(header)")
            if header.keys.contains("Authorization") {
                let auth = header["Authorization"] as! String
                print("authorization update: \(auth)")
                apigwToken = auth
                lastTokenUpdated = Util.getCurTsMs()
                respSuccess = true
            } else {
                print("could not update token!!!")
            }

            scheTimer?.invalidate()
            scheTimer = nil

            if respSuccess { //update 성공.
                self.apigwUpdateToken(vc)
            } else if Util.getCurTsMs() - lastTokenUpdated < TOKEN_EXPIRE_DUR {
                //아래 코드가 계속 문제가 있어서 일단은 update를 한번만 시도하는 걸로 수정.
                //self.apigwUpdateToken(vc, afterSec:10)
            } else { //token expired
                //todo: 토큰이 만료되었습니다..
                /*
                GvUtil.errMsgOk("연결 에러", "서버 연결 에러로 종료합니다.", vc: vc) {
                    () in

                    vc.dismiss(animated: false, completion: nil)
                }
                */

            }
        })
    }
    
    static func apigwUpdateToken(_ mainVC:NSViewController? = nil, afterSec:TimeInterval = DEF_TOKEN_UPDATE_DUR) { //9분마다 업데이트 시도
        scheTimer = Timer.scheduledTimer(timeInterval: afterSec, target: self, selector: #selector(self.updateToken), userInfo: mainVC, repeats: false)
    }
    
    static func apigwUpdateCancelToken() {
        if scheTimer != nil {
            scheTimer!.invalidate()
            scheTimer = nil
        }
    }
    
    static func apigwGetPolicy(policyId:String, completion: @escaping (_ result:Bool, _ data:JSON?) -> Void) {
        if apigwUrl == nil {
            apigwUrl = DEF_APIGW_URL
        }
        
        let url = apigwUrl! + "/v1/operation/policys/\(policyId)/cert/vpc/"
        let hdrs = defApigwHdr(useJson: false)
        
        NetworkAPI.shared.requestAPI(strURL: url, parameters: nil, httpMethod: .get, headers: hdrs, success: { (json, _) in
            print("[api] apigwGetPolicy = \(json)")
            
            completion(true, json["data"])
        }, failure: {_ in
            completion(false, nil)
        })
    }
    
    
    //MARK: - logManger
//    static private func CONV_EVT(_ e:LogManager.Event) -> LogMessage_Event {
//        return LogMessage_Event(rawValue: Int32(e.rawValue)) ?? LogMessage_Event.eventTypeNull //default는 info
//    }
//
//    static private func CONV_EVTTYPE(_ e:LogManager.EventType) -> LogMessage_EventType {
//        return LogMessage_EventType(rawValue: Int32(e.rawValue)) ?? LogMessage_EventType.eventNull //default는 info
//    }
//
//    static private func CONV_LEVEL(_ l:LogManager.Level) -> LogMessage_Level {
//        return LogMessage_Level(rawValue: Int32(l.rawValue)) ?? LogMessage_Level.info //default는 info
//    }
//
//    static private func getProtoBufBinaryData(msg:[String:Any]) -> Data? {
//        let climsg = ClientMessage()
//        climsg.sndTimestamp = msg["sndTimestamp"] as! Int64
//        climsg.vdiKey = vpcId ?? DEF_VPCID // msg["vdiKey"] as! String
//
//        for log in msg["logMessage"] as! [LogManager.LogMsg] {
//            let logmsg = LogMessage()
//            logmsg.crtTimestamp = log.timestamp
//            logmsg.event = CONV_EVT(log.event)
//            logmsg.eventType = CONV_EVTTYPE(log.type)
//            logmsg.level = CONV_LEVEL(log.level)
//            logmsg.hostOs = "iOS Client"
//            logmsg.clientVersion = Util.getShortVerString()
//            logmsg.uuid = Util.getDeviceUUID()
//            logmsg.etc = ""
//            climsg.logMessageArray.add(logmsg)
//        }
//        climsg.resourceMessageArray = []
//
//        if let binaryData = climsg.data() {
//            return binaryData
//        }
//        return nil
//    }
//
//    static func logsvrSendLog(msg:[String:Any], completion: ((_ result:Bool, _ data:JSON?) -> Void)? = nil) {
//
//        if logsvrUrl == nil {
//            //테스트 용도로 설정함.
//            logsvrUrl = DEF_LOGSVR_URL
//        }
//
//        guard let sendData = getProtoBufBinaryData(msg:msg) else {
//            print("prepare of serialized protobuf data failed")
//            return
//        }
//
//        //GLV_2ND : support new log server URL.
//        let url = logsvrUrl! + (viewerType == nil ? "/v1/log-collector/logmessage" : "log-collector/logmessage")
//
//        var request:URLRequest = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = HTTPMethod.post.rawValue
//
//        print("url : \(url)")
//        print("token : \(String(describing: apigwToken))")
//
//        request.setValue(makeUUID(), forHTTPHeaderField: "X-CloudPC-Request-ID")
//        request.setValue(apigwToken ?? DEF_APIGW_TOKEN, forHTTPHeaderField: "Authorization")
//        request.setValue("application/x-protobuf", forHTTPHeaderField: "Content-Type")
//        request.setValue("POCVM", forHTTPHeaderField: "X-CloudPC-Request-Poc")
//
//        request.httpBody = sendData
//
//        NetworkAPI.sessionManager.request(request).responseJSON { response in
//            if let responseCode = response.response?.statusCode {
//                print("responsecode of log message: \(responseCode)")
//            }
//        }
//    }
}











