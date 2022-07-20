//
//  SpiceView.swift
//  MacSpice
//
//  Created by y2k on 2022/07/18.
//

import Cocoa

class SpiceView: NSView {
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initView()
    }
    
    deinit {
    }
    
    func initView() {
//        self.layer = Gvre
        
        drawAll()
    }
    
    //MARK: - draw
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        drawAll()
    }
    
    func drawAll() {
        
        delay() {
//            self.drawSpice()
        }
    }
    
    func drawSpice() {
//        var defFrameBuffer:GLuint = 0
//        glGenFramebuffers(1, &defFrameBuffer)
//
//        glEnable(1)
//        glEnable(UInt32(GL_TEXTURE_2D));
//        glEnable(UInt32(GL_BLEND));
        global_state.width = 1024
        global_state.height = 768
        
        engine_init_buffer(global_state.width, global_state.height) // 초기화
        engine_init_screen()
        
        let result = engine_draw(global_state.width, global_state.height)   // draw
        if result == -2 {
            
        }
    }
    
}
