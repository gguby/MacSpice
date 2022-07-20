//
//  CHAlertView.swift
//  MacFreeRDP
//
//  Created by y2k on 2022/03/23.
//

import Cocoa

@objc class CHAlertView: NSObject {
    @objc static let shared = CHAlertView()

    @objc func showAlert(msg: String, window: NSWindow, successCompletion: (() -> Void)? = nil) {
        self.showAlert(msg: msg, window: window, isShowCancel: false, successCompletion: successCompletion)
    }
    
    public func showAlert<T: NSViewController>(title: String = "안내", msg: String, window: NSWindow? = nil, windowType: T.Type? = nil, isShowCancel: Bool = false, successTitle: String = "확인", cancelTitle: String = "취소", successCompletion: (() -> Void)? = nil, cancelCompletion: (() -> Void)? = nil) {
        var window = window
        if window == nil, windowType != nil {
            for info in NSApplication.shared.windows {
                if info.contentViewController is T {
                    window = info.contentViewController?.view.window
                    break
                }
            }
        }
        
        let alert = NSAlert.init()
        alert.messageText = title
        alert.informativeText = msg
        alert.addButton(withTitle: successTitle)
        if isShowCancel {
            alert.addButton(withTitle: cancelTitle)
        }
        alert.alertStyle = .warning
        
        if let window = window {
            alert.beginSheetModal(for: window) { (returnCode) in
                self.clickAlert(returnCode: returnCode, successCompletion: successCompletion, cancelCompletion: cancelCompletion)
            }
        } else {
            let returnCode = alert.runModal()
            clickAlert(returnCode: returnCode, successCompletion: successCompletion, cancelCompletion: cancelCompletion)
        }
    }
    
    private func clickAlert(returnCode: NSApplication.ModalResponse, successCompletion: (() -> Void)? = nil, cancelCompletion: (() -> Void)? = nil) {
        
        if returnCode == .alertFirstButtonReturn {
//        if returnCode.rawValue == 1000 {
            successCompletion?()
        } else {
            cancelCompletion?()
        }
        
    }
}
