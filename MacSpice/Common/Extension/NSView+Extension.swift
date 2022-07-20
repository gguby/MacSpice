//
//  NSView+Extension.swift
//  MacFreeRDP
//
//  Created by y2k on 2022/04/14.
//

import Cocoa

extension NSView {
    
    @IBInspectable public var borderColor: NSColor? {
        get {
            return layer?.borderColor != nil ? NSColor(cgColor: layer!.borderColor!) : nil
        }
        set {
            layer?.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer!.borderWidth
        }
        set {
            self.layer?.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer!.cornerRadius
        }
        set {
            layer?.cornerRadius = newValue
            layer?.masksToBounds = newValue > 0
        }
    }
    
}
