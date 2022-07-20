//
//  SocketManager.swift
//  IosFreeRDP
//
//  Created by y2k on 2021/05/24.
//

//import UIKit
import SwiftSocket

class SocketManager: NSObject {
    public static var shared: SocketManager = {
        let instance = SocketManager()
        return instance
    }()

    
    func checkConnect(ip: String, port: Int) -> Bool {
        var ip = ip
        ip = ip.replacingOccurrences(of: "https://", with: "")
        ip = ip.replacingOccurrences(of: "http://", with: "")
        print("[rdp] checkConnect = \(ip), port = \(port)")
        let client = TCPClient(address: ip, port: Int32(port))
        switch client.connect(timeout: 3) {
          case .success:
            print("[rdp] success")
            return true
          case .failure(_):
            print("[rdp] fail")
            return false
        }
    }
}
