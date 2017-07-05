//
//  MainMenu.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/15.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu, NSMenuDelegate {
    
    // MARK: - IBActions
    
    var standanoneDanmukuWindowController: StandaloneDanmukuWindowController?
    
    @IBAction func toggleConnect(_ sender: NSMenuItem) {
        if DanmukuHandler.shared.isDisconnected {
            DanmukuHandler.shared.start()
            sender.title = "断开"
        } else {
            DanmukuHandler.shared.stop()
            sender.title = "连接"
        }
    }
    
    @IBAction func showStandAloneWindow(_ sender: NSMenuItem) {
        if standanoneDanmukuWindowController == nil {
            standanoneDanmukuWindowController = StandaloneDanmukuWindowController()
        }
        
        if standanoneDanmukuWindowController!.window!.isVisible {
            standanoneDanmukuWindowController?.close()
            sender.state = NSControl.StateValue.offState
        } else {
            standanoneDanmukuWindowController?.showWindow(self)
            sender.state = NSControl.StateValue.onState
        }
    }
    
    // quit
    @IBAction func quitAction(_ sender: NSMenuItem) {
        if !(DanmukuHandler.shared.isDisconnected) {
            DanmukuHandler.shared.stop()
        }
        NSApplication.shared.terminate(self)
    }
    
    // MARK: - Delegate
    
    func menuWillOpen(_ menu: NSMenu) {
        
        // TODO: toggle advenced menu by tag
        
        let isOptionClick = ((NSApp.currentEvent)?.modifierFlags)!.contains(.option)
        
        for item in self.items {
            item.isHidden = isOptionClick ? false : (item.tag == 1)
        }
        
        self.item(at: 5)?.isHidden = DanmukuHandler.shared.isDisconnected
        
        let roomName = profile.cachedRoomName
        let owner = profile.cachedOwner
        let room = profile.cachedRoom
        let realroom = profile.cachedRealRoom
        self.item(at: 1)?.title = "标题: \(roomName)"
        self.item(at: 2)?.title = "播主: \(owner)"
        self.item(at: 3)?.title = "房号: \(room)"
        self.item(at: 4)?.title = "映射: \(realroom)"
        
    }
    
}

extension MainMenu: DanmukuHandlerDelegate {
    func statusDidChange(status: ConnectStatus) {
        switch status {
        case .disconnected:
            self.item(at: 0)?.title = "状态: 未连接"
        case .connnecting:
            self.item(at: 0)?.title = "状态: 正在连接..."
        case .connected:
            self.item(at: 0)?.title = "状态: 已连接"
        }
    }
    
    func didReceviedOnlineCount(_ online: Int) {
        DispatchQueue.main.async {
            self.item(at: 5)?.title = "在线: \(online)"
        }
    }
}
