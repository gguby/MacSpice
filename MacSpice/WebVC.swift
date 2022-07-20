//
//  WebVC.swift
//  MacSpice
//
//  Created by y2k on 2022/07/15.
//

import Cocoa
import WebKit

class WebVC: NSViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var strUrl: String = "http://www.naver.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    //MARK: -
    func initView() {
        
//        let systemVersion = UIDevice.current.systemVersion

        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
//        webView.isOpaque = false
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12.0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.2 Mobile/15E148 Safari/604.1"
//        ios : "Mozilla/5.0 (iPhone; CPU iPhone OS 12.0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.2 Mobile/15E148 Safari/604.1"
//        mac : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko)"
        delay {
            self.request(urlStr: self.strUrl)
            self.view.window?.setContentSize(NSMakeSize(CGFloat(1366), CGFloat(768)))
        }
    }
    
    //MARK: -
    func request(urlStr: String) {
//        if !NetworkAPI.shared.checkReachability() {
//            CHAlertView.shared.showAlert(title: "연결 에러", msg: "인터넷 연결 상태를 확인해주세요", successCompletion: {
//                self.returnToUrlVc()
//            })
//            return
//        }
        
        var urlstr = urlStr.trimmingCharacters(in: CharacterSet.whitespaces)
        if !urlstr.hasPrefix("http") {
            urlstr = "http://" + urlstr
        }
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            if let webView = self.webView {
                webView.load(request)
                return
            }
        }
        
//        CHAlertView.shared.showAlert(title: "연결 에러", msg: "인터넷 연결 상태와 URI를 확인해주세요", successCompletion: {
//            self.returnToUrlVc()
//        })
    }
}

//MARK: -
extension WebVC: WKUIDelegate {
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("URLAuthenticationChallenge2")
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("runJavaScriptAlertPanelWithMessage")
        
        CHAlertView.shared.showAlert(msg: message, window: view.window!, successCompletion:  {
            completionHandler()
        })
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage")
        
        CHAlertView.shared.showAlert(msg: message, window: view.window!, isShowCancel: true, successCompletion: {
            completionHandler(true)
        }, cancelCompletion: {
            completionHandler(false)
        })
        
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("window.open() = \(webView)")
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("window.close() = \(webView)")
    }
}

//MARK: -
extension WebVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
//        CHIndicatorView.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none'")
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none'")
//        CHIndicatorView.hide()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decidePolicyFor = \(String(describing: navigationAction.request.url))")
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        print("url = \(url), scheme = \(url.scheme ?? ""), host = \(url.host ?? "")")
        
        decisionHandler(.allow)
    }
    
}
