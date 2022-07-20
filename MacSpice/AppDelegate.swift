//
//  AppDelegate.swift
//  MacSpice
//
//  Created by y2k on 2022/07/06.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var openUrlStr: String? = nil
    var isConnected: Bool = false
    var mainWindow: NSWindow!
    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("applicationDidFinishLaunching")
        mainWindow = NSApplication.shared.windows[0]
//        mainWindow.delegate = self
        
        if let url = openUrlStr {
            startSpice(url: url)
        } else {
//            mainWindow.performClose(nil)
        }
        
//        FolderSharingManager.sharedInstance.bookmarkStart()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
    //MARK: - open
    // url scheme로 recv
    func application(_ application: NSApplication, open urls: [URL]) {
        print("url = \(urls)")
        if isConnected {
            return
        }
        isConnected = true
        
        if let url = urls.first?.absoluteString {
            if mainWindow != nil {
                startSpice(url: url)
            } else {
                self.openUrlStr = url
            }
        }
    }
    
    //MARK: - startSpice
    func startSpice(url : String) {
        let rdp = NSViewController.new(ofType: SpiceVC.self)
        mainWindow.contentViewController = rdp
        mainWindow.center()
        
        delay(0.1) {
            let dict = Util.getStringParsing(params: url)
            let host = dict["freerdp_host"]
            let rdpApi = RdpApiManager.init()
            if host == "cloudpc" {
                rdpApi.setData(dict: dict, rdp: rdp)
            } else {
                rdpApi.setDataTest(dict: dict, rdp: rdp)
            }
        }
    }
}

