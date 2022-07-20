//
//  GvRenderer.swift
//  iOSLauncher
//
//  Created by yongdae park on 2018. 6. 11..
//  Copyright © 2018년 Gloovir. All rights reserved.
//

import Cocoa
import OpenGL
import GLKit

/*
class GvRenderer: NSObject {
    
    var defFrameBuffer:GLuint = 0
    var colorRenderBuffer:GLuint = 0
    var glContext:NSOpenGLContext?
    var backingWidth:GLint = 0
    var backingHeight:GLint = 0;
    var glEngineInited:Bool = false
    var resChangeRequested:Bool = false
    var resChangedTS:Date?
    
    var curCalculatedMatrix:CATransform3D = CATransform3DIdentity
    
    override init() {
        super.init()
        
        initContext()
//        NSOpenGLContext.setCurrent(nil)
//        glContext = NSOpenGLContext(api: .openGLES1)!
//
//        //print("glContext is \(glContext)")
//
//        guard NSOpenGLContext.setCurrent(glContext) else {
//            print("setCurrent failed")
//            return
//        }
        
        layerInit()
        //print("[GvRenderer] init is called")
    }
    
    deinit {
        engine_free_buffer()
        glDeleteFramebuffers(1, &defFrameBuffer)
        glDeleteRenderbuffers(1, &colorRenderBuffer)
        
        if NSOpenGLContext.current() == glContext {
            NSOpenGLContext.setCurrent(nil)
        }
    }
    var change_at_once = false
    
    func initContext() {
        let attr = [
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAColorSize), 24,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAAlphaSize), 8,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFADepthSize), 24,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAStencilSize), 8,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAAllowOfflineRenderers),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAAccelerated),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFADoubleBuffer),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAMultisample),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFASampleBuffers), 1,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFASamples), 4,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAMinimumPolicy),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAOpenGLProfile),
            NSOpenGLPixelFormatAttribute(NSOpenGLProfileVersion4_1Core),
            0
        ]

        let format = NSOpenGLPixelFormat(attributes: attr)
          
        self.glContext = NSOpenGLContext(format: format!, share: nil)
        
    }
    
    func layerInit(resize layer:CAOpenGLLayer? = nil) {
        
        if defFrameBuffer != 0 {
            glDeleteFramebuffers(1, &defFrameBuffer)
            defFrameBuffer = 0
        }
        if colorRenderBuffer != 0 {
            glDeleteRenderbuffers(1, &colorRenderBuffer)
            colorRenderBuffer = 0
        }
        
        glGenFramebuffers(1, &defFrameBuffer)
        glGenRenderbuffers(1, &colorRenderBuffer)
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), defFrameBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        
        if layer != nil {
            glContext!.renderbufferStorage(Int(GL_RENDERBUFFER), from: layer!)
        }

        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &backingWidth)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &backingHeight)
        var topSafeAreaHeight: CGFloat = 0
        var bottomSafeAreaHeight: CGFloat = 0
        
/* GLV_2ND
    화면 오리엔테이션 전환 시 해상도 변경을 위한 기준 길이 변경, 폰 최소 기준 해상도 변경 720->800
*/
        let standardLength = backingWidth < backingHeight ? backingWidth : backingHeight    //짧은 쪽
        var standardLengthForContentScaleInNotchDesign = standardLength
        
//        if #available(iOS 11.0, *) {
//            let window = UIApplication.shared.windows[0]
//            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
//            topSafeAreaHeight = safeFrame.minY
//            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
//            let tempHeight = (safeFrame.maxY - safeFrame.minY)*2
//            let tempWidth  = (safeFrame.maxX - safeFrame.minX)*2
//            standardLengthForContentScaleInNotchDesign = GLint(tempWidth < tempHeight ? tempWidth : tempHeight)
//        }
        
//        if UIDevice.current.userInterfaceIdiom == .phone && standardLength > 0{
//            global_state.width = backingWidth*800/standardLength
//            global_state.height = backingHeight*800/standardLength
//
////            if change_at_once == false{
//                global_state.content_scale = 2 * 800.0 / Float(standardLengthForContentScaleInNotchDesign)
////                change_at_once = true
////            }
//
//        }else if UIDevice.current.userInterfaceIdiom == .pad && standardLength > 1024{
//            global_state.width = backingWidth*1024/standardLength
//            global_state.height = backingHeight*1024/standardLength
////            if change_at_once == false{
//                global_state.content_scale = 2 * 1024.0 / Float(standardLengthForContentScaleInNotchDesign)
////                change_at_once = true
////            }
//        }
//        else{
            global_state.width = backingWidth
            global_state.height = backingHeight
//        }

        
//        global_state.width = backingWidth
//        global_state.height = backingHeight
        resChangeRequested = false
        
        //print("[GvRenderer] layerInit \(global_state.width), \(global_state.height)...")
    }
    
    func reRender() {
        if GvMainVC.isOrientationChanged == true {
            glEngineInited = false
            GvMainVC.isOrientationChanged = false
        }
        NSOpenGLContext.setCurrent(glContext)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), defFrameBuffer)
        glViewport(0, 0, backingWidth, backingHeight)
        
        glMatrixMode(GLenum(GL_PROJECTION))
        glLoadIdentity()
        glOrthof(0, GLfloat(backingWidth), GLfloat(backingHeight), 0, 0, 1)
        
        guard global_state.width > 0, global_state.height > 0 else {
            //print("[GvRenderer] global_state \(global_state.width), \(global_state.height)...")
            return
        }
        
//        if glEngineInited == false {
            engine_init_buffer(global_state.width, global_state.height)
            engine_init_screen()
            glEngineInited = true
//        }
        
        let result = engine_draw(global_state.width, global_state.height)
        var resMismatch = false
        
        if (global_state.guest_width != 0 &&
            global_state.guest_height != 0) {
            if (global_state.guest_width != global_state.width ||
                global_state.guest_height != global_state.height) {
                resMismatch = true;
            }else{
                NotificationCenter.default.post(name: Notification.Name("completeResolutionChange"),object:self,userInfo:nil)
            }
        }
        
        //print("[GvRenderer] result \(result), \(resMismatch)...")
        
        if (result == -2 || resMismatch) {
            if (!resChangeRequested) {
                engine_spice_request_resolution(global_state.width, global_state.height);
                resChangeRequested = true;
                resChangedTS = Date()
            }
        } else if (resChangeRequested) {
            engine_spice_resolution_changed();
            resChangeRequested = false;
        }
        
        if (resChangeRequested && resChangedTS != nil) {
            let timeSinceRequest = resChangedTS!.timeIntervalSinceNow * -1000.0
            if timeSinceRequest > 5000.0 {
                resChangeRequested = false
                resChangedTS = nil
            }
        }
        
        if (result == -2) {
            NotificationCenter.default.post(name: Notification.Name("completeResolutionChange"),object:self,userInfo:nil)
            engine_draw_disconnected(global_state.width, global_state.height);
        }
        
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        glContext?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    func resizeFromLayer(layer:CAOpenGLLayer) -> Bool {
        //NSOpenGLContext.setCurrent(glContext)
        //print("resizeFromLayer")
        layerInit(resize:layer)
        if (glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE)
        {
            print("fail to create framebuffer \(glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)))")
            return true
        }
        return false
    }
}





*/
