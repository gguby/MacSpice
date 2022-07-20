//
//  String+Extension.swift
//  MacFreeRDP
//
//  Created by y2k on 2022/04/11.
//

import Cocoa

extension String {
    func verStrToInt() -> Int {
        let nums = self.components(separatedBy: ".")
        var res = 0
        
        for n in nums {
            res += (Int(n) ?? 0) * 100
        }
        return res
    }
}
