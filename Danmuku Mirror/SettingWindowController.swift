//
//  SettingWindowController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/26.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class SettingWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        if toolbar.items.count > 0 {
            self.toolbar.selectedItemIdentifier = self.toolbar.items[0].itemIdentifier
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }

    @IBAction func switchTab(_ sender: NSToolbarItem) {
        self.window?.title = sender.label
        
        let viewController = storyboard?.instantiateController(withIdentifier: "SettingTab\(sender.tag)") as! NSViewController
        
        transitionContentViewController(self.contentViewController!, toViewController: viewController, animate: true, completionHandler: nil)
    }
}

extension NSWindowController {
    func transitionContentViewController(_ fromViewController: NSViewController, toViewController: NSViewController, animate: Bool, completionHandler: (() -> Void)?) {
        if animate {
            let windowOrigin = (self.window?.frame.origin)!
            let titleBarHeight = (self.window?.frame.size.height)! - (fromViewController.view.frame.size.height)
            let newContentSize = toViewController.view.frame.size
            
            let padding = fromViewController.view.frame.size.height - toViewController.view.frame.size.height
            
            let newOrigin = CGPoint(x: windowOrigin.x, y: windowOrigin.y + padding)
            let newSize = CGSize(width: newContentSize.width, height: newContentSize.height + titleBarHeight)
            let newRect = CGRect(origin: newOrigin, size: newSize)
            
            self.window?.contentViewController = nil
            
            self.window?.setFrame(newRect, display: true, animate: animate)
        }
        
        self.window?.contentViewController = toViewController
        
        if completionHandler != nil { completionHandler!() }
    }
}
