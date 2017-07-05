//
//  DMTableView.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/22.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class DMTableView: NSTableView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    override var allowsVibrancy: Bool {
        return true
    }
    
}
