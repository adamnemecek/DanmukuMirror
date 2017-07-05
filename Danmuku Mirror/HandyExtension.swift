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
    var layerBackgroundColor: NSColor? {
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
    
    func anchor(to: NSView, top: Bool, bottom: Bool, leading: Bool, trailing: Bool) {
        self.topAnchor.constraint(equalTo: to.topAnchor).isActive = top
        self.bottomAnchor.constraint(equalTo: to.bottomAnchor).isActive = bottom
        self.leadingAnchor.constraint(equalTo: to.leadingAnchor).isActive = leading
        self.trailingAnchor.constraint(equalTo: to.trailingAnchor).isActive = trailing
    }
    
    /// Add autolayout constraint to current view
    func constraint(_ attr: NSLayoutConstraint.Attribute, _ relatedBy: NSLayoutConstraint.Relation, to item: Any?, _ attribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: attr, relatedBy: relatedBy, toItem: item, attribute: attribute, multiplier: multiplier, constant: constant))
    }
    
    /// Add autolayout constraint to superview (if any)
    func superConstraint(_ attr: NSLayoutConstraint.Attribute, _ relatedBy: NSLayoutConstraint.Relation, to item: Any?, _ attribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) {
        if let superview = self.superview {
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: attr, relatedBy: relatedBy, toItem: item, attribute: attribute, multiplier: multiplier, constant: constant))
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
    @objc dynamic var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension NSAttributedString {
    func height(forWidth: CGFloat) -> CGFloat {
        let textWidth = ceil(self.size().width)
        let rows: CGFloat = ceil(textWidth / forWidth)
        let height = rows * 17
        
        return height
        
//        if self.size().width <= forWidth {
//            // return default height for a single line
//            let layoutManager = NSLayoutManager()
//            var font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
//            
//            if let attributedFont = self.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? NSFont {
//                font = attributedFont
//            }
//            
//            return layoutManager.defaultLineHeight(for: font)
//            
//        } else {
//            let containerSize = NSMakeSize(forWidth, CGFloat(Float.greatestFiniteMagnitude))
//            let textContainer = NSTextContainer(containerSize: containerSize)
//            let textStorage = NSTextStorage(attributedString: self)
//            let layoutManager = NSLayoutManager()
//            
//            layoutManager.addTextContainer(textContainer)
//            textStorage.addLayoutManager(layoutManager)
//            layoutManager.hyphenationFactor = 0
//            
//            layoutManager.glyphRange(for: textContainer)
//            return layoutManager.usedRect(for: textContainer).size.height
//        }
    }
}

/// A special handy class for easy accessing the user defaults
class profile {
    // General
    static var room: Int {
//        get { return UserDefaults.standard.integer(forKey: "dm.user.room") }
        get { return 139 }
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
