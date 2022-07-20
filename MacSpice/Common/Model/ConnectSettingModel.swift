//
//  SettingManager.swift
//  IosFreeRDP
//
//  Created by y2k on 2021/03/30.
//

import Cocoa

@objc class FolderSharingModel: NSObject, Codable {
    @objc var key: String = ""
    @objc var path: String = ""
    @objc var indexBookmark: Int = 0
    
    
    @objc init(key: String, path: String, index: Int = 0) {
        self.key = key
        self.path = path
        self.indexBookmark = index
    }
    
//    enum CodingKeys: String, CodingKey {
//    case key
//    case path
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(self.key, forKey: "key")
//        coder.encode(self.path, forKey: "path")
//    }
//
//    required init?(coder: NSCoder) {
//        self.key = coder.decodeObject(forKey: "key") as! String
//        self.path = coder.decodeObject(forKey: "path") as! String
//    }
}

@objc class ConnectSettingModel: NSObject {
    
    @objc var desktopWidth: Int = 1366       // default값, 1024     1366        640
    @objc var desktopHeight: Int = 768       // default값, 768      768         480
    @objc var desktopMinSize: NSSize = NSMakeSize(800, 600);
    @objc var isFullscreen: Bool = false    // 전체화면 여부
    
    @objc var isFolderSharing: Bool = true  // 폴더공유 여부
    @objc var arrayFolderSharing: [FolderSharingModel] = []
    
    @objc var rdpIp: String = ""
    @objc var rdpPort: Int = 0
    @objc var rdpUser: String = ""
    @objc var rdpUserPwd: String = ""
    @objc var rdpDomain: String = ""
    @objc var rdpIsProxy: Bool = false
    @objc var rdpProxyAddress: String = ""
    @objc var rdpProxyPort: Int = 0
    @objc var rdpProxyToken: String = ""
    @objc var rdpIsGateway: Bool = false
    @objc var rdpGatewayAddress: String = ""
    @objc var rdpGatewayPort: Int = 0
    @objc var rdpGatewayPwd: String = ""
    @objc var rdpGatewayAccount: String = ""
    @objc var rdpGatewayDomain: String = ""
    
    
    var remoteIp:[String] = []
    var remotePort:[Int] = [] //default is -1
    var remoteTlsPort:[Int] = []
    
    var ca_cert:String = "-1"
    var ca_subject:String = "-1"
    var spice_token:String = "-1"
    
    var enableAudio = true
    var enableUrlRedir = false
    var autoLogOutInterval:Int = 5 // minimum is 5min
    
    var pushAddr:String? = nil
    
    var userName: String? = nil
    var password: String? = nil

    var curAddrIndex = 0;
    var curRemoteIp:String {
        get {
            return self.remoteIp[self.curAddrIndex];
        }
    }
    var curRemoteTlsPort:Int {
        get {
            if self.remoteTlsPort.isEmpty {
                return -1
            }
            return self.remoteTlsPort[self.curAddrIndex];
        }
    }
    var curRemotePort:Int {
        get {
            if self.remotePort.isEmpty {
                return -1
            }
            return self.remotePort[self.curAddrIndex];
        }
    }

    
    override init() {}
    
    @objc init(remoteIp: String, remotePort: Int, userName: String? = nil, password: String? = nil) {
        self.rdpIp = remoteIp
        self.rdpPort = remotePort
        if let userName = userName {
            self.rdpUser = userName
        }
        if let password = password {
            self.rdpUserPwd = password
        }
    }
    
    @objc func aaaa() {
        
    }
}
