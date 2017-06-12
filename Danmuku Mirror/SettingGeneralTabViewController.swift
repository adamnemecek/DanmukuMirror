//
//  SettingGeneralTabViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/27.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class SettingGeneralTabViewController: NSViewController {

    @IBOutlet weak var roomField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        loadValues()
    }
    
    func loadValues() {
        roomField.stringValue = "\(profile.room)"
    }
    
    @IBAction func handleRoom(_ sender: NSTextField) {
        if let room = Int(sender.stringValue) {
            profile.room = room
        }
    }
}
