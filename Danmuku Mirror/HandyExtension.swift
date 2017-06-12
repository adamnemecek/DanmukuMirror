//
//  HandyExtension.swift
//  DanmukuMirror
//
//  Created by ixan on 2017/1/9.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa
import AVFoundation

extension NSView {
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)!
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}

extension NSTableView {
    func reloadDataWithSelection() {
        let selectedRowIndexes = self.selectedRowIndexes
        self.reloadData()
        self.selectRowIndexes(selectedRowIndexes, byExtendingSelection: false)
    }
    
    var isLastRowVisible: Bool {
        get { return enclosingScrollView?.verticalScroller?.floatValue == 1 }
    }
}

extension AVPlayer {
    dynamic var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}


/// A special handy class for easy accessing the user defaults
class profile {
    // General
    static var room: Int {
        get { return UserDefaults.standard.integer(forKey: "dm.user.room") }
        set { UserDefaults.standard.set(newValue, forKey: "dm.user.room") }
    }
    static var cachedRoom: Int {
        get { return UserDefaults.standard.integer(forKey: "dm.cache.room") }
        set { UserDefaults.standard.set(newValue, forKey: "dm.cache.room") }
    }
    static var cachedRealRoom: Int {
        get { return UserDefaults.standard.integer(forKey: "dm.cache.realroom") }
        set { UserDefaults.standard.set(newValue, forKey: "dm.cache.realroom") }
    }
    static var cachedServer: String {
        get { return UserDefaults.standard.string(forKey: "dm.cache.server") ?? defaultServer }
        set { UserDefaults.standard.set(newValue, forKey: "dm.cache.server") }
    }
    static var defaultServer: String {
        get { return "livecmt-1.bilibili.com" }
    }
    static var cachedRoomName: String {
        get { return UserDefaults.standard.string(forKey: "dm.cache.roomname") ?? "-" }
        set { UserDefaults.standard.set(newValue, forKey: "dm.cache.roomname") }
    }
    static var cachedOwner: String {
        get { return UserDefaults.standard.string(forKey: "dm.cache.owner") ?? "-" }
        set { UserDefaults.standard.set(newValue, forKey: "dm.cache.owner") }
    }
    
}

extension UserDefaults {
    // appearance
    
    public var mainWindowAOT: Bool {
        get { return bool(forKey: "dm.mainWin.alwaysOnTop") }
        set { set(newValue, forKey: "dm.mainWin.alwaysOnTop") }
    }
    
    // color
    
    public var mainWindowUnameForegroundColor: NSColor {
        get {
            if let color = object(forKey: "dm.color.main.uname") as? NSColor {
                return color
            }
            return NSColor(calibratedRed: 0.5, green: 1, blue: 0, alpha: 1)
        }
        set { set(newValue, forKey: "dm.color.main.uname") }
    }
    
    public var mainWindowUnameTintColor: NSColor {
        get {
            if let color = object(forKey: "dm.color.main.uname.tint") as? NSColor {
                return color
            }
            return NSColor(calibratedRed: 0.5, green: 1, blue: 0, alpha: 1)
        }
        set { set(newValue, forKey: "dm.color.main.uname.tint") }
    }
    
    public var mainWindowDanmukuForegroundColor: NSColor {
        get {
            if let color = object(forKey: "dm.color.main.uname.tint") as? NSColor {
                return color
            }
            return NSColor(calibratedRed: 0.5, green: 1, blue: 0, alpha: 1)
        }
        set { set(newValue, forKey: "dm.color.main.uname.tint") }
    }
    
    // Music Station
    
    public var playlistMaxLength: Int {
        get {
            let value = integer(forKey: "dm.musicStation.playlistCount")
            if value != 0 {
                return value
            } else {
                set(10, forKey: "dm.musicStation.playlistCount")
                return 10
            }
        }
        set { set(newValue, forKey: "dm.musicStation.playlistCount") }
    }
}
