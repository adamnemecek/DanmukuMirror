//
//  DanmukuListViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/17.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class DanmukuListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, DanmukuPoolDelegate {

    override func loadView() {
        let v = NSView(frame: NSMakeRect(0, 0, 50, 50))
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        DanmukuPool.shared.delegates.addDelegate(self)
    }
    
    // subviews
    
    let danmukuListTableView: NSTableView = {
        let tv = NSTableView(frame: NSMakeRect(0, 0, 50, 50))
        let tc = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "danmukuColumn"))
        tv.addTableColumn(tc)
        tv.backgroundColor = NSColor.clear
        tv.headerView = nil
        tv.rowSizeStyle = .custom
        tv.usesAutomaticRowHeights = true
        tv.selectionHighlightStyle = .none
        return tv
    }()
    
    let danmukuListEnclosingScrollView: NSScrollView = {
        let sv = NSScrollView(frame: NSMakeRect(0, 0, 50, 50))
        sv.drawsBackground = false
        sv.borderType = .noBorder
        sv.automaticallyAdjustsContentInsets = false
        sv.contentView.postsBoundsChangedNotifications = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let scrollToBottomButton: NSButton = {
        let btn = NSButton(frame: NSMakeRect(0, 0, 28, 28))
        btn.setButtonType(.toggle)
        btn.image = NSImage.init(imageLiteralResourceName: "NSRefreshTemplate")
        btn.isBordered = false
        return btn
    }()
    
    let bottomInuptContainer: NSView = {
        let v = NSView(frame: NSMakeRect(0, 0, 50, 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let divider: NSView = {
        let v = NSView(frame: NSMakeRect(0, 0, 50, 50))
        v.layerBackgroundColor = NSColor.white.withAlphaComponent(0.12)
        v.alphaValue = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let textField: DMTextField = {
        let tf = DMTextField(frame: NSMakeRect(6, 6, 200, 24))
        tf.placeholderString = "请输入弹幕DA☆ZE～"
        tf.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        tf.bezelStyle = .roundedBezel
        tf.layerBackgroundColor = NSColor.clear
        tf.focusRingType = .none
        tf.setContentHuggingPriority(.fittingSizeCompression, for: .vertical)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isEnabled = false // not yet ready
        return tf
    }()
    
    // setup
    
    func setup() {
        view.wantsLayer = true
        view.layer?.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(boundDidChange(notification:)), name: NSView.boundsDidChangeNotification, object: danmukuListEnclosingScrollView.contentView)
        // add subviews
        
        danmukuListEnclosingScrollView.documentView = danmukuListTableView
        
        bottomInuptContainer.addSubview(divider)
        bottomInuptContainer.addSubview(textField)
        bottomInuptContainer.addSubview(scrollToBottomButton)
        view.addSubview(danmukuListEnclosingScrollView)
        view.addSubview(bottomInuptContainer)
        
        // set constraints
        
        divider.superConstraint(.top, .equal, to: bottomInuptContainer, .top, multiplier: 1, constant: 0)
        divider.superConstraint(.height, .equal, to: nil, .height, multiplier: 1, constant: 1)
        divider.superConstraint(.leading, .equal, to: bottomInuptContainer, .leading, multiplier: 1, constant: 0)
        divider.superConstraint(.trailing, .equal, to: bottomInuptContainer, .trailing, multiplier: 1, constant: 0)
        
        bottomInuptContainer.superConstraint(.height, .equal, to: nil, .height, multiplier: 1, constant: 29)
        bottomInuptContainer.superConstraint(.bottom, .equal, to: view, .bottom, multiplier: 1, constant: 0)
        bottomInuptContainer.superConstraint(.leading, .equal, to: view, .leading, multiplier: 1, constant: 0)
        bottomInuptContainer.superConstraint(.trailing, .equal, to: view, .trailing, multiplier: 1, constant: 0)
        
        danmukuListEnclosingScrollView.superConstraint(.top, .equal, to: view, .top, multiplier: 1, constant: 0)
        danmukuListEnclosingScrollView.superConstraint(.bottom, .equal, to: bottomInuptContainer, .top, multiplier: 1, constant: 0)
        danmukuListEnclosingScrollView.superConstraint(.leading, .equal, to: view, .leading, multiplier: 1, constant: 0)
        danmukuListEnclosingScrollView.superConstraint(.trailing, .equal, to: view, .trailing, multiplier: 1, constant: 0)
        
        textField.superConstraint(.height, .equal, to: nil, .height, multiplier: 1, constant: 22)
        textField.superConstraint(.bottom, .equal, to: bottomInuptContainer, .bottom, multiplier: 1, constant: -3)
        textField.superConstraint(.leading, .equal, to: bottomInuptContainer, .leading, multiplier: 1, constant: 28)
        textField.superConstraint(.trailing, .equal, to: bottomInuptContainer, .trailing, multiplier: 1, constant: -5)
        
        scrollToBottomButton.superConstraint(.width, .equal, to: nil, .width, multiplier: 1, constant: 28)
        scrollToBottomButton.superConstraint(.height, .equal, to: nil, .height, multiplier: 1, constant: 28)
        scrollToBottomButton.superConstraint(.leading, .equal, to: bottomInuptContainer, .leading, multiplier: 1, constant: 0)
        scrollToBottomButton.superConstraint(.bottom, .equal, to: bottomInuptContainer, .bottom, multiplier: 1, constant: 0)
        
        // misc setting
        
        danmukuListTableView.delegate = self
        danmukuListTableView.dataSource = self
    }
    
    // viewModel
    
//    var danmukuViewModel = DanmukuPool()
    
    // actions

    
    
    @objc func boundDidChange(notification: Notification) {
        if let clipView = notification.object as? NSClipView {
            // show or hide divider
            if clipView.documentVisibleRect.size.height < clipView.documentRect.size.height || clipView.bounds.origin.y < 0 {
                // show
                if divider.alphaValue < 1 {
                    NSAnimationContext.beginGrouping()
                    NSAnimationContext.current.allowsImplicitAnimation = true
                    NSAnimationContext.current.duration = 0.33
                    divider.animator().alphaValue = 1
                    NSAnimationContext.endGrouping()
                }
            } else {
                // hide
                if divider.alphaValue >= 1 {
                    NSAnimationContext.beginGrouping()
                    NSAnimationContext.current.allowsImplicitAnimation = true
                    NSAnimationContext.current.duration = 0.39
                    divider.animator().alphaValue = 0
                    NSAnimationContext.endGrouping()
                }
            }
        }
    }
    
    // table view delegate / datasource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return DanmukuPool.shared.danmukus.count
//        return 8
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: StandaloneDanmukuTableCellView?
        if let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "standaloneDanmukuCell"), owner: self) as? StandaloneDanmukuTableCellView {
            cellView = view
        } else {
            cellView = StandaloneDanmukuTableCellView(frame: NSMakeRect(0, 0, 50, 50))
            cellView?.identifier = NSUserInterfaceItemIdentifier(rawValue: "standaloneDanmukuCell")
        }
        
        cellView?.wrappingLabel.attributedStringValue = DanmukuPool.shared.danmukuAttributedString(at: row)
        cellView?.wrappingLabel.preferredMaxLayoutWidth = tableColumn!.width - 12
        
        return cellView
    }
    
    func tableViewColumnDidResize(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView {
            tableView.reloadData()
        }
    }
    
    func didAddDanmuku(to pool: DanmukuPool, danmukus: [Danmuku]) {
        print(#function)
        danmukuListTableView.reloadDataWithSelection()
        danmukuListTableView.scrollRowToVisible(danmukuListTableView.numberOfRows - 1)
    }
}

