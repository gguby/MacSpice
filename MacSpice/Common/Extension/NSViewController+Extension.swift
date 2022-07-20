//
//  NSViewController+Extension.swift
//  MacFreeRDP
//
//  Created by y2k on 2022/03/02.
//

import Foundation
import Cocoa

extension NSViewController {
    class func new<T: NSViewController>(ofType type: T.Type) -> T {
        let storyboard: NSStoryboard = NSStoryboard.init(name: String(describing: (T.self)), bundle: nil)
        let page = storyboard.instantiateController(withIdentifier: String(describing: (T.self))) as! T
        return page
    }
}
