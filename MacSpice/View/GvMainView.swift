//
//  GvMainView.swift
//  iOSLauncher
//
//  Created by yongdae park on 2018. 6. 11..
//  Copyright © 2018년 Gloovir. All rights reserved.
//

import Cocoa
import OpenGL
/*
protocol GvNotify {
    func sessionDisconnect(reason:Int?)
}

class GvMainView : NSView {
    var renderer:GvRenderer?
    var displayLink:CADisplayLink?
    var inited = false
    var delegate: GvNotify?
    
//    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override class var layerClass: AnyClass {
        get {
            return CAOpenGLLayer.self
            //return CAOpenGLLayer.classForCoder()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initCommon()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initCommon()
    }
    
    deinit {
        displayLink?.remove(from: .current, forMode: RunLoop.Mode.default)
        displayLink = nil
    }
    
    func initCommon() {
        if inited {
            return
        }
        
        let eaglLayer:CAOpenGLLayer = self.layer as! CAOpenGLLayer
        eaglLayer.contentsScale = CGFloat(global_state.content_scale)
        
        print("content scale is \(global_state.content_scale)")
        
        eaglLayer.isOpaque = true
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: NSNumber(value:false), kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
        
        renderer = GvRenderer()
        
        displayLink = CADisplayLink(target: self, selector: #selector(drawView))
        //displayLink?.frameInterval = 1
        #if SKB
        displayLink?.preferredFramesPerSecond = 15
        #elseif ADTCAPS
        displayLink?.preferredFramesPerSecond = 15
        #elseif PSNM
        displayLink?.preferredFramesPerSecond = 15
        #elseif GYEONGGI
        displayLink?.preferredFramesPerSecond = 15
        #endif
        displayLink?.add(to: .current, forMode: RunLoop.Mode.default)
        
        inited = true
    }
    
    func stopRenderer() {
        displayLink?.remove(from: .current, forMode: RunLoop.Mode.default)
        displayLink = nil
        renderer = nil
    }
    
    @objc func drawView() {
        
        struct local {
            static var inited:Bool = false
            static var disconnCount:Int = 0
            static var disconnReason:Int = 0
        }
        
        let connToInternet = GvUtil.isConnectToInternet
        let connSpice = engine_spice_is_connected()
        let reason = engine_spice_has_disconn_reason()
        
        if local.disconnReason == 0 && reason != 0 {
            local.disconnReason = Int(reason)
        }
        
        if local.disconnCount % 100 == 0 {
            print("internet->\(connToInternet), spice->\(connSpice), disconn reason -> \(reason)")
        }
        
        if !connToInternet || connSpice == 0 {
            local.disconnCount += 1
            if (!local.inited && local.disconnCount == 150) || (local.inited && local.disconnCount == 150) { //10초가 지나면 disconnect로 변환.
                engine_spice_disconnect();
                delegate?.sessionDisconnect(reason:local.disconnReason)
                local.disconnReason = 0
                return
            }
        }
        else {
            if !inited {
                inited = true
            }
            local.disconnCount = 0
        }
        

        renderer?.reRender()

    }
    
    override func layout() {
        //print("--view frame is \(self.layer)")
        _ = renderer?.resizeFromLayer(layer: self.layer as! CAOpenGLLayer)
        drawView()
    }
}

extension GvMainView {
    func spin(on:Bool) {
        if on {
//            spinner.startAnimating()
        }
        else {
//            spinner.stopAnimating()
        }
    }
}
*/
