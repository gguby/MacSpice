//
//  RdpApiManager.swift
//  MacFreeRDP
//
//  Created by y2k on 2022/03/30.
//

import Cocoa
import SwiftyJSON

class RdpApiManager: NSObject {
//    static let shared = RdpApiManager()
    
    var settingConnect: ConnectSettingModel = ConnectSettingModel.init()
    var isFirstReconnect:Bool = false
    var vcRDP: SpiceVC? = nil
    
    //MARK: - setData
    func setData(dict: Dictionary<String, String>, rdp: SpiceVC) {
        settingConnect = ConnectSettingModel.init()
        
        vcRDP = rdp
        GvHttpComm.apigwUrl = dict["apigw_url"] ?? nil
        GvHttpComm.apigwToken = dict["apigw_token"] ?? nil
        GvHttpComm.vpcId = dict["vpc_id"] ?? nil
        GvHttpComm.viewerType = dict["type"] ?? nil
        
        if GvHttpComm.viewerType == nil {
            getConnInfoLegacy()
        } else {
            getConnInfo()
        }
    }
    
//    skbvdirdp://aa?ip=61.75.82.31&port=52055
    func setDataTest(dict: Dictionary<String, String>, rdp: SpiceVC) {
        
        vcRDP = rdp
        if let ip = dict["ip"], let port = Int(dict["port"] ?? "") {
            let user = dict["user"] ?? ""
            let password = dict["password"] ?? ""
            settingConnect = ConnectSettingModel.init(remoteIp: ip, remotePort: port , userName: user, password: password)
        } else {
            settingConnect = ConnectSettingModel.init(remoteIp: "61.75.82.31", remotePort: 52055, userName: "inu_04", password: "dlsn00!")
        }
        makeConnectionToSvr()
    }
    
    func exitRDP() {
        if let rdp = vcRDP {
            rdp.view.window?.performClose(nil)
        }
    }
    
    //MARK: - move
    func makeConnectionToSvr() {
        if let vcRDP = vcRDP {
            vcRDP.setData(_setting: settingConnect)
        }
    }
    
    //MARK: - request
    /* GLV_2ND
    변경된 api 게이트웨이 프로토콜 지원
     */
    func getConnInfo() {
//        CHIndicatorView.show()
        GvHttpComm.apigwGetConnInfo() { (result, data) in

            if result == false {
                if self.isFirstReconnect == false {
                    self.getConnInfoLegacy()
                    self.isFirstReconnect = true
                } else {
                    // 데이터 값에 따라 에러 코드를 명시
                    // spice에서 아예 접속 실패 - (C000)
                    // http status code(200이 아닐경우) 오류 - (C+http status code 그대로 노출, ex: (C500, C400, C404))
                    // GvUtil.errMsgOk("연결 에러", "서버와의 연결에 장애가 발생했습니다. 다시 시도하세요.", vc: self)
                }
//                CHIndicatorView.hide()
                return
            }

            guard let data = data else {
//                CHIndicatorView.hide()
                CHAlertView.shared.showAlert(title: "연결 에러", msg: "서버와의 연결에 장애가 발생했습니다.\n다시 시도하세요.", successCompletion: {
                    self.exitRDP()
                })
                return
            }
            
            let rdpIp:String = data["connect_address"].string ?? ""
            let rdpPort:Int = data["connect_port"].int ?? 0
            let rdpUser:String = data["rdp_user_account"].string ?? ""
            var rdpUserPwd:String = data["join_key"].string ?? ""
            let rdp_domain:String = data["rdp_domain"].string ?? ""
            let rdgw:[String : SwiftyJSON.JSON]? = data["rdgw"].dictionary ?? nil
            let proxy:[String : SwiftyJSON.JSON]? = data["proxy"].dictionary ?? nil
            self.settingConnect.rdpIp = rdpIp
            self.settingConnect.rdpPort = rdpPort
            self.settingConnect.rdpUser = rdpUser    // "Administrator" "DevTest" //rdpUser   // "gyeonggido"     // username
//            rdpUserPwd = "cloudpc!234"  // 임시 하드코딩
//            rdpUserPwd = Jasypt.jasyptDecryption(rdpUserPwd)
            print("[rdp] decryption rdpUserPwd = \(rdpUserPwd)")
            self.settingConnect.rdpUserPwd = rdpUserPwd // "skb!12345"
            self.settingConnect.rdpDomain = rdp_domain
            
            if let proxy = proxy {
                self.settingConnect.rdpProxyAddress = proxy["address"]?.string ?? ""
                self.settingConnect.rdpProxyPort = Int(proxy["port"]?.string ?? "") ?? 0
                var token = GvHttpComm.apigwToken ?? ""
                token = token.replacingOccurrences(of: "Bearer ", with: "")
                token = token.replacingOccurrences(of: " ", with: "")
                self.settingConnect.rdpProxyToken = token
            } else {
                self.settingConnect.rdpProxyAddress = ""
                self.settingConnect.rdpProxyPort = 0
                self.settingConnect.rdpProxyToken = ""
            }
            
            if let rdgw = rdgw {
                self.settingConnect.rdpGatewayAddress = rdgw["address"]?.string ?? ""
                self.settingConnect.rdpGatewayPort = Int(rdgw["port"]?.string ?? "") ?? 0
                self.settingConnect.rdpGatewayAccount = rdgw["account"]?.string ?? ""
                self.settingConnect.rdpGatewayPwd = rdgw["pwd"]?.string ?? ""
                self.settingConnect.rdpGatewayDomain = rdgw["domain"]?.string ?? ""
            } else {
                self.settingConnect.rdpGatewayAddress = ""
                self.settingConnect.rdpGatewayPort = 0
                self.settingConnect.rdpGatewayAccount = ""
                self.settingConnect.rdpGatewayPwd = ""
                self.settingConnect.rdpGatewayDomain = ""
            }
            
            print("[rdp] data = \(data)")
            print("[rdp] ip = \(rdpIp)")
            print("[rdp] port = \(rdpPort)")
            print("[rdp] proxy = \(String(describing: proxy))")
            print("[rdp] token = \(String(describing: GvHttpComm.apigwToken))")
            print("[rdp] vpcId = \(String(describing: GvHttpComm.vpcId))")
            print("[rdp] apigwUrl = \(String(describing: GvHttpComm.apigwUrl))")
            
            
            let ip:String = data["connect_address"].string ?? ""
            let port:Int = data["connect_port"].int ?? 0

            let ip2:String = data["connect_ext_address"].string ?? ""
            let port2:Int = data["connect_ext_port"].int ?? 0

            let ca_cert:String = data["cert_info"].string ?? ""
            let ca_subject:String = data["host_subject"].string ?? ""
            let spice_token:String = data["token"].string ?? ""

            if ip == "" || port == 0 {
//                CHIndicatorView.hide()
                CHAlertView.shared.showAlert(title: "연결 에러", msg: "서버와의 연결에 장애가 발생했습니다.\n다시 시도하세요.", successCompletion: {
                    self.exitRDP()
                })
                return
            }

            let use_tls:Bool = data["tls_connect"].string == "true"

            self.settingConnect.remoteIp = []
            self.settingConnect.remoteIp.append(ip)
            if ip2 != "" {
                self.settingConnect.remoteIp.append(ip2)
            }

            if use_tls {
                self.settingConnect.remoteTlsPort = []
                self.settingConnect.remoteTlsPort.append(port)
                if port2 != 0 {
                    self.settingConnect.remoteTlsPort.append(port2)
                }
                self.settingConnect.remotePort = []
            } else {
                self.settingConnect.remoteTlsPort = []
                self.settingConnect.remotePort = []
                self.settingConnect.remotePort.append(port)
                if port2 != 0 {
                    self.settingConnect.remotePort.append(port2)
                }
            }
            self.settingConnect.ca_cert = ca_cert
            self.settingConnect.ca_subject = ca_subject
            self.settingConnect.spice_token = spice_token
            
            GvHttpComm.logsvrUrl = data["log_access_url"].string ?? ""
//            LogManager.shared.logStack(level: .INFO, event: .SYSTEM, type: .SYSTEM_START)
            
            if GvHttpComm.viewerType != nil {
                //get push
                let push_addr = data["connect_push_address"].string
                let push_port = data["connect_push_port"].int ?? 0

                if let push_addr = push_addr {
                    self.settingConnect.pushAddr = "\(push_addr):\(push_port)"
                }

                let pi = data["secu_plcy_info"]
                if let dataArray = pi["pcly_cert"].array {
//                    var netCode = "U005LOC"
//                    if let connNet = data["conn_net_cd"].string {
//                        if connNet == "U005EXT" {
//                            netCode = "U005EXT"
//                        }
//                    }

                    for pl in dataArray {
                        self.settingConnect.enableUrlRedir = pl["url_rdrt_auth_cd"].string == "U012PO"
                        print("*** enableUrlRedir is set to \(self.settingConnect.enableUrlRedir)")
                        if self.settingConnect.enableUrlRedir == true {
//                            engine_spice_set_url_redir(1)
                        }

                        var logOutInterval = pl["viwr_expr_mi_cnt"].intValue as Int

                        if logOutInterval < 5 {
                            logOutInterval = 5
                        } else if logOutInterval > 180 {
                            logOutInterval = 180
                        }
                        self.settingConnect.autoLogOutInterval = logOutInterval
                        print("*** logout interval is set to \(self.settingConnect.autoLogOutInterval)")
                        break
                    }
                }
            } else {
                //get policy id
                if let policyId = data["secu_plcy_id"].string {
                    var netCode = "U005LOC"
                    if let connNet = data["conn_net_cd"].string {
                        if connNet == "U005EXT" {
                            netCode = "U005EXT"
                        }
                    }

                    GvHttpComm.apigwGetPolicy(policyId: policyId) {
                        (r, data) in
                        guard r, let data = data else {
//                            CHIndicatorView.hide()
                            print("!!! fail to get policy id")
                            return
                        }

                        if let dataArray = data["pcly_cert"].array {
                            for pl in dataArray {
                                if pl["conn_net_cd"].string == netCode {
                                    self.settingConnect.enableUrlRedir = pl["url_rdrt_auth_cd"].string == "U012PO"
                                    print("*** enableUrlRedir is set to \(self.settingConnect.enableUrlRedir)")
                                    if self.settingConnect.enableUrlRedir == true {
//                                        engine_spice_set_url_redir(1)
                                    }
                                    break
                                }
                            }
                        }
                        print("policy data is \(data)")
                    }
                }

                if let policyIdVto = data["secu_plcy_id_vto"].string {
                    var netCode = "U005LOC"
                    if let connNet = data["conn_net_cd"].string {
                        if connNet == "U005EXT" {
                            netCode = "U005EXT"
                        }
                    }

                    GvHttpComm.apigwGetPolicy(policyId: policyIdVto) {
                        (r, data) in
                        guard r, let data = data else {
//                            CHIndicatorView.hide()
                            print("!!! fail to get policy id")
                            return
                        }

                        var logOutInterval = 5

                        if let dataArray = data["pcly_cert"].array {
                            for pl in dataArray {
                                if pl["conn_net_cd"].string == netCode {
                                    logOutInterval = pl["viwr_expr_mi_cnt"].intValue as Int
                                    print("*** enableUrlRedir is set to \(self.settingConnect.enableUrlRedir)")
                                    break
                                }
                            }
                        }
                        print("logOutInterval : \(logOutInterval)")

                        if logOutInterval < 5 {
                            logOutInterval = 5
                        }else if logOutInterval > 180 {
                            logOutInterval = 180
                        }
                        self.settingConnect.autoLogOutInterval = logOutInterval
                        print("vto policy data is \(data)")
                    }
                }
            }

            //get current version.
            if self.checkVersion(data: data) {
                return
            }
            self.makeConnectionToSvr()
        }
    }
    
    /* GLV_2ND
     api 게이트웨이 프로토콜 변경 전 연결 지원
     */
    func getConnInfoLegacy() {
//        CHIndicatorView.show()
        GvHttpComm.apigwGetConnInfo() { (result, data) in
            
            if result == false {
                if self.isFirstReconnect == false {
                    self.getConnInfo()
                    self.isFirstReconnect = true
                } else {
                    // 데이터 값에 따라 에러 코드를 명시
                    // spice에서 아예 접속 실패 - (C000)
                    // http status code(200이 아닐경우) 오류 - (C+http status code 그대로 노출, ex: (C500, C400, C404))
                    // GvUtil.errMsgOk("연결 에러", "서버와의 연결에 장애가 발생했습니다. 다시 시도하세요.", vc: self)
                }
                return
            }

            guard let data = data else {
//                CHIndicatorView.hide()
                CHAlertView.shared.showAlert(title: "연결 에러", msg: "서버와의 연결에 장애가 발생했습니다. 다시 시도하세요.", successCompletion: {
                    self.exitRDP()
                })
                return
            }

            let ip:String = data["connect_address"].string ?? ""
            let port:Int = data["connect_port"].int ?? 0

            let ip2:String = data["connect_ext_address"].string ?? ""
            let port2:Int = data["connect_ext_port"].int ?? 0

            let ca_cert:String = data["cert_info"].string ?? ""
            let ca_subject:String = data["host_subject"].string ?? ""
            let spice_token:String = data["token"].string ?? ""

            if ip == "" || port == 0 {
//                CHIndicatorView.hide()
                CHAlertView.shared.showAlert(title: "연결 에러", msg: "서버와의 연결에 장애가 발생했습니다. 다시 시도하세요.", successCompletion: {
                    self.exitRDP()
                })
                return
            }

            let use_tls:Bool = data["tls_connect"].string == "true"

            self.settingConnect.remoteIp = []
            self.settingConnect.remoteIp.append(ip2)
            self.settingConnect.remoteIp.append(ip)

            if use_tls {
                self.settingConnect.remoteTlsPort = []
                self.settingConnect.remoteTlsPort.append(port2)
                self.settingConnect.remoteTlsPort.append(port)
                self.settingConnect.remotePort = []
            } else {
                self.settingConnect.remoteTlsPort = []
                self.settingConnect.remotePort = []
                self.settingConnect.remotePort.append(port2)
                self.settingConnect.remotePort.append(port)
            }

            self.settingConnect.ca_cert = ca_cert
            self.settingConnect.ca_subject = ca_subject
            self.settingConnect.spice_token = spice_token
            
            GvHttpComm.logsvrUrl = data["log_access_url"].string ?? ""
//            LogManager.shared.logStack(level: .INFO, event: .SYSTEM, type: .SYSTEM_START)
            
            //get policy id
            if let policyId = data["secu_plcy_id"].string {
                var netCode = "U005LOC"
                if let connNet = data["conn_net_cd"].string {
                    if connNet == "U005EXT" {
                        netCode = "U005EXT"
                    }
                }

                GvHttpComm.apigwGetPolicy(policyId: policyId) {
                    (r, data) in
                    guard r, let data = data else {
//                        CHIndicatorView.hide()
                        print("!!! fail to get policy id")
                        return
                    }

                    if let dataArray = data["pcly_cert"].array {
                        for pl in dataArray {
                            if pl["conn_net_cd"].string == netCode {
                                self.settingConnect.enableUrlRedir = pl["url_rdrt_auth_cd"].string == "U012PO"
                                print("*** enableUrlRedir is set to \(self.settingConnect.enableUrlRedir)")
                                if self.settingConnect.enableUrlRedir == true {
//                                    engine_spice_set_url_redir(1)
                                }
                                break
                            }
                        }
                    }

                    print("policy data is \(data)")
                }

            }

            if let policyIdVto = data["secu_plcy_id_vto"].string {
                var netCode = "U005LOC"
                if let connNet = data["conn_net_cd"].string {
                    if connNet == "U005EXT" {
                        netCode = "U005EXT"
                    }
                }

                GvHttpComm.apigwGetPolicy(policyId: policyIdVto) {
                    (r, data) in
                    guard r, let data = data else {
//                        CHIndicatorView.hide()
                        print("!!! fail to get policy id")
                        return
                    }

                    var logOutInterval = 5

                    if let dataArray = data["pcly_cert"].array {
                        for pl in dataArray {
                            if pl["conn_net_cd"].string == netCode {
                                self.settingConnect.enableUrlRedir = pl["url_rdrt_auth_cd"].string == "U012PO"
                                logOutInterval = pl["viwr_expr_mi_cnt"].intValue as Int
                                print("*** enableUrlRedir is set to \(self.settingConnect.enableUrlRedir)")
                                break
                            }
                        }
                    }
                    print("logOutInterval : \(logOutInterval)")

                    if logOutInterval < 5 {
                        logOutInterval = 5
                    }else if logOutInterval > 180 {
                        logOutInterval = 180
                    }
                    self.settingConnect.autoLogOutInterval = logOutInterval
                    print("vto policy data is \(data)")
                }
            }

            //get current version.
            if self.checkVersion(data: data) {
                return
            }
            self.makeConnectionToSvr()
        }
    }
    
    //MARK: - version
    func checkVersion(data: JSON) -> Bool {
        
        //get current version.
        for d in data["viewer_info"].array! {
            guard d["ui_file_div_nm"].string!.range(of: "mac") != nil else {
                continue
            }

            if(GvHttpComm.viewerType != nil) {
                if d["usg_yn"].string != "Y" {
                    continue
                }
            }

            let latest_ver = d["ver"].string ?? ""
            let force_ver = d["forc_upd_ver"].string ?? ""
            let cur_ver = Util.getShortVerString()
            let mob_url: String? = d["mob_url"].string
            print("[rdp] cur_ver = \(cur_ver)")
            print("[rdp] latest_ver = \(latest_ver)")
            
            print("[rdp] check \(cur_ver.verStrToInt()), \(latest_ver.verStrToInt())")

            if Util.versionUpdateCheck(curVer: cur_ver, targetVer: latest_ver) {
                if Util.versionUpdateCheck(curVer: cur_ver, targetVer: force_ver) {     // force update
                    CHAlertView.shared.showAlert(title: "SW 업그레이드", msg: "현재 버전 \(cur_ver)에서 최신 버전 \(latest_ver)으로 업그레이드하시겠습니까?", successTitle: "확인", cancelTitle: "종료", successCompletion: {
                        if Util.moveToDownloadPage(mob_url) == false {
                            CHAlertView.shared.showAlert(title: "연결 에러", msg: "업그레이드 페이지에 연결할 수 없습니다.", successCompletion: {
                                self.exitRDP()
                            })
                        } else {
                            self.exitRDP()
                        }
                    }, cancelCompletion: {
                        self.exitRDP()
                    })
                } else {
                    CHAlertView.shared.showAlert(title: "SW 업그레이드", msg: "현재 버전 \(cur_ver)에서 최신 버전 \(latest_ver)으로 업그레이드하시겠습니까?", isShowCancel: true, successTitle: "확인", cancelTitle: "취소", successCompletion: {
                        if Util.moveToDownloadPage(mob_url) == false {
                            CHAlertView.shared.showAlert(title: "연결 에러", msg: "업그레이드 페이지에 연결할 수 없습니다.", successCompletion: {
                                self.exitRDP()
                            })
                        } else {
                            self.exitRDP()
                        }
                    }, cancelCompletion: {
                        self.makeConnectionToSvr()
                    })
                }
                return true
            }
        }
        return false
    }
}
