//
//  StandaloneDanmukuWindowController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/17.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class StandaloneDanmukuWindowController: NSWindowController {
    
    convenience init() {
        let vc = StandaloneDanmukuRootViewController()
        self.init(window: NSWindow(contentViewController: vc))
        
        additionSetup()
    }
    
    let titlebarAccessaryViewController: StandaloneDanmukuWindowTitlebarAccessoryViewController = {
        let vc = StandaloneDanmukuWindowTitlebarAccessoryViewController()
        vc.layoutAttribute = .right
        return vc
    }()
    
    func additionSetup() {
        
        // place window to right edge of screen
        
        let newW : CGFloat = 260
        let newH : CGFloat = (NSScreen.main?.frame.height)!
        let newX = (NSScreen.main?.frame.width)! - newW
        let newY = (NSScreen.main?.frame.height)!
        
        window?.setFrame(NSMakeRect(newX, newY, newW, newH), display: true)
        
        // window always on ton
        
        window?.level = .floating
        
        // dark appearance
        
        window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        
        // hide window title
        
        window?.titleVisibility = .hidden
        
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        // setting window size range
        
        window?.minSize = NSSize(width: 200, height: 400)
        
        // titlebar accessory view controller
        
        window?.addTitlebarAccessoryViewController(titlebarAccessaryViewController)
        
    }
}
