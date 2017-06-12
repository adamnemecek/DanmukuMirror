//
//  DanmukuWindowController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/20.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class DanmukuWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        let newW : CGFloat = 210
        let newH : CGFloat = (NSScreen.main()?.frame.height)!
        let newX = (NSScreen.main()?.frame.width)! - newW
        let newY = (NSScreen.main()?.frame.height)!
        
        self.window?.setFrame(NSMakeRect(newX, newY, newW, newH), display: true)
        self.window?.level = Int(CGWindowLevelKey.floatingWindow.rawValue)

        self.window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.window?.titleVisibility = .hidden
        
        if let accessoryViewController = storyboard?.instantiateController(withIdentifier: "AccessoryViewController") as? AccessoryViewController {
            print("added")
            accessoryViewController.layoutAttribute = .right
            window?.addTitlebarAccessoryViewController(accessoryViewController)
        }
        
//        window?.viewsNeedDisplay = true

//        self.window?.delegate = self
    }

}
