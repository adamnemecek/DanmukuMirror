//
//  StandaloneDanmukuWindowTitlebarAccessoryViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/22.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class StandaloneDanmukuWindowTitlebarAccessoryViewController: NSTitlebarAccessoryViewController {
    
    override func loadView() {
        let v = NSView(frame: NSMakeRect(0, 0, 50, 50))
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // subviews
    
    let quickSettingsButton: NSButton = {
        let btn = NSButton(frame: NSMakeRect(0, 0, 30, 30))
        btn.setButtonType(.momentaryPushIn)
        btn.isBordered = false
        btn.image = NSImage(imageLiteralResourceName: "NSActionTemplate")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // setup
    
    func setupViews() {
        view.addSubview(quickSettingsButton)
        
        quickSettingsButton.superConstraint(.trailing, .equal, to: view, .trailing, multiplier: 1, constant: -6)
        quickSettingsButton.superConstraint(.centerY, .equal, to: view, .centerY, multiplier: 1, constant: 0)
    }
    
}
