//
//  AccessorySplitViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/17.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class AccessorySplitViewController: NSViewController {

    override func loadView() {
        let v = NSView(frame: NSMakeRect(0, 0, 50, 50))
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
//        view.backgroundColor = NSColor.blue
    }
}
