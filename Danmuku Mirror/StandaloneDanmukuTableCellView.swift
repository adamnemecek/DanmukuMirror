//
//  StandaloneDanmukuTableCellView.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/19.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class StandaloneDanmukuTableCellView: NSTableCellView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var wrappingLabel: NSTextField = {
        let tf = NSTextField(frame: NSMakeRect(0, 0, 50, 50))
        tf.isBordered = false
        tf.isEditable = false
        tf.drawsBackground = false
        tf.isSelectable = true
        
//        tf.backgroundColor = NSColor.blue
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    func setupViews() {
        addSubview(wrappingLabel)
        
        constraint(.top, .equal, to: wrappingLabel, .top, multiplier: 1, constant: 0)
        constraint(.bottom, .equal, to: wrappingLabel, .bottom, multiplier: 1, constant: 0)
        constraint(.leading, .equal, to: wrappingLabel, .leading, multiplier: 1, constant: -6)
        constraint(.trailing, .equal, to: wrappingLabel, .trailing, multiplier: 1, constant: 6)
    }
    
    override var allowsVibrancy: Bool {
        return true
    }
}
