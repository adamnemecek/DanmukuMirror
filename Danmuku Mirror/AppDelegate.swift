//
//  AppDelegate.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/15.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
//    var statusItem = NSStatusBar.system().statusItem(withLength: 60)
    @IBOutlet weak var menu: MainMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setups()
        
    }
    
    func setups() {
        
        // load UserDefaults
        
        // statusItem setup
        if let button = statusItem.button {
            button.title = "lol"
            button.image = NSImage(named: "NSQuickLookTemplate")
//            button.alternateTitle = "lol"
        }
        
        // menu setup
        menu.delegate = menu
        DanmukuHandler.shared.delegates.addDelegate(menu)
        statusItem.menu = menu
        
    }

    func applicationWillTerminate(_ aNotification: Notification) { }

}
