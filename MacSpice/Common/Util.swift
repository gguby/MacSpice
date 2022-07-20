//
//  Util.swift
//  MacFreeRDP
//
//  Created by y2k on 2022/03/03.
//

import Foundation

public typealias BoolClosure   = ((Bool) -> Void)


public func delay(_ delay:Double = 0.0, closure:@escaping ()-> Void) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

public func print(_ object: Any...) {
    #if DEBUG
    for item in object {
        Swift.print(item)
    }
    #endif
}

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}


//MARK: - Util
public final class Util {
    
    class func moveToDownloadPage(_ urlstr:String?) -> Bool {
        let appStorePage = urlstr ?? "https://www.google.com"
        if let url = URL(string: appStorePage) {
//            NSWorkspace.shared.open(url)
            return true
        }
        return false
    }
    
    @objc class func getStringParsing(params: String) -> Dictionary<String, String> {
        var dict: Dictionary<String, String> = [:]
        let str = params.replacingOccurrences(of: "&amp;", with: "&")
        let components = URLComponents(string: str)

        if let host = components?.host {
            dict["freerdp_host"] = host
        }
        
        let items = components?.queryItems ?? []
        for item in items {
            dict[item.name] = item.value ?? ""
        }
        return dict
    }
    
    class func getCurTsMs() -> Int { //curtimestamp(ms)
        return Int(Date().timeIntervalSince1970 * 1000)
    }
    
    class func getDeviceUUID() -> String {
        let dev = IOServiceMatching("IOPlatformExpertDevice")
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        if let ser: CFTypeRef = serialNumberAsCFString?.takeUnretainedValue() {
            if let result = ser as? String {
                return result
            }
        }
        return "testMacOS"
    }
    
    class func getCurUTCTimeStampSec() -> Int32 {
        return Int32(Date().timeIntervalSince1970)
    }
    
    class func getCurUTCTimeStampMs() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    class func getShortVerStringBuild() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else { return "" }
        
        let versionAndBuild: String = "\(version), build : \(build)"
        return versionAndBuild
    }
    
    class func getShortVerString() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        
        let versionAndBuild: String = "\(version)"
        return versionAndBuild
    }
    
    class func versionUpdateCheck(curVer: String, targetVer: String) -> Bool {
        if curVer.compare(targetVer, options: .numeric) == .orderedDescending {
            return true
        }
        return false
    }
}

//MARK: - 기기 ip 주소 가져오기
/* GLV_2ND
기기 ip 주소 가져오기
*/
extension Util {
    private struct InterfaceNames {
        static let wifi = ["en0"]
        static let wired = ["en2", "en3", "en4"]
        static let cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        static let supported = wifi + wired + cellular
    }
    
    class func ipAddress() -> String? {
        var ipAddress: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            var pointer = ifaddr
            
            while pointer != nil {
                defer { pointer = pointer?.pointee.ifa_next }
                
                guard
                    let interface = pointer?.pointee,
                    interface.ifa_addr.pointee.sa_family == UInt8(AF_INET),
                    let interfaceName = interface.ifa_name,
                    let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8),
                    InterfaceNames.supported.contains(interfaceNameFormatted)
                    else { continue }
                
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                
                getnameinfo(interface.ifa_addr,
                            socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST)
                
                guard
                    let formattedIpAddress = String(cString: hostname, encoding: .utf8),
                    !formattedIpAddress.isEmpty
                    else { continue }
                
                ipAddress = formattedIpAddress
                break
            }
            
            pointer = ifaddr
            
            while ipAddress == nil && pointer != nil {
                defer { pointer = pointer?.pointee.ifa_next }
                
                guard
                    let interface = pointer?.pointee,
                    interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) || interface.ifa_addr.pointee.sa_family == UInt8(AF_INET6),
                    let interfaceName = interface.ifa_name,
                    let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8),
                    InterfaceNames.supported.contains(interfaceNameFormatted)
                    else { continue }
                
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                
                getnameinfo(interface.ifa_addr,
                            socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST)
                
                guard
                    let formattedIpAddress = String(cString: hostname, encoding: .utf8),
                    !formattedIpAddress.isEmpty
                    else { continue }
                
                ipAddress = formattedIpAddress
                break
            }
            
            freeifaddrs(ifaddr)
        }
        
        if let splitIp = ipAddress?.split(separator: "%")[0] {
            return String(splitIp);
        }
        
        return ipAddress
    }
}
