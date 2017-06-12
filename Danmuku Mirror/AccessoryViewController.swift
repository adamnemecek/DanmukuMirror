//
//  AccessoryViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/2/2.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class AccessoryViewController: NSTitlebarAccessoryViewController {

    let moreMenu = NSMenu()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }
    
    let viewMenuItem: NSMenuItem = {
        let item = NSMenuItem(title: "视图", action: nil, keyEquivalent: "")
        return item
    }()
    
    
    func setupMenu() {
        moreMenu.addItem(viewMenuItem)
        moreMenu.addItem(NSMenuItem(title: "  插件", action: #selector(toggleMusicStation), keyEquivalent: ""))
        moreMenu.addItem(NSMenuItem(title: "  杂项", action: nil, keyEquivalent: ""))
        moreMenu.addItem(NSMenuItem(title: "  弹幕", action: nil, keyEquivalent: ""))
        moreMenu.addItem(NSMenuItem.separator())
        moreMenu.addItem(NSMenuItem(title: "窗口置顶", action: #selector(toggleAlwaysOnTop), keyEquivalent: ""))
    }
    
    @IBAction func moreMenu(_ sender: NSButton) {
        let position = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - sender.frame.width)
        moreMenu.popUp(positioning: nil, at: position, in: sender.superview)
    }
    
    func toggleMusicStation() {
        
    }
    
    func toggleAlwaysOnTop() {
        UserDefaults.standard.mainWindowAOT = !(UserDefaults.standard.mainWindowAOT)
        
        // TODO: KVO on DanmukuWindowController
    }
}
