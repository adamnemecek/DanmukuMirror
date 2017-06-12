//
//  AboutWindowController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/17.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window?.titlebarAppearsTransparent = true
        self.window?.titleVisibility = .hidden
        
//        self.window?.standardWindowButton(.zoomButton)?.isEnabled = false
        self.window?.standardWindowButton(.miniaturizeButton)?.isEnabled = false
        
        self.window?.isMovableByWindowBackground = true
        
        _ = self.window?.styleMask.update(with: .fullSizeContentView)
        
        NSApp.activate(ignoringOtherApps: true)
        self.window?.makeKeyAndOrderFront(self)
        
    }

    
}
