//
//  StandaloneDanmukuRootViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/17.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class StandaloneDanmukuRootViewController: NSSplitViewController {
    
    override func loadView() {
        let vev = NSVisualEffectView(frame: NSMakeRect(0, 0, 50, 50))
        vev.blendingMode = .behindWindow
        vev.material = .appearanceBased
        vev.state = .active
        vev.translatesAutoresizingMaskIntoConstraints = false
        vev.addSubview(splitView)
        view = vev
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitView.isVertical = false
        splitView.dividerStyle = .thin
        splitView.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    // subviews
    var danmukuListSplitViewItem: NSSplitViewItem = {
        let vc = DanmukuListViewController()
        let svi = NSSplitViewItem(viewController: vc)
        svi.canCollapse = false
//        svi.holdingPriority = 250
        return svi
    }()
    
    var accessorySplitViewItem: NSSplitViewItem = {
        let vc = AccessorySplitViewController()
        let svi = NSSplitViewItem(viewController: vc)
        svi.canCollapse = true
//        svi.holdingPriority = 270
        return svi
    }()
    
    // setup subviews
    
    func setupViews() {
        
        addSplitViewItem(accessorySplitViewItem)
        addSplitViewItem(danmukuListSplitViewItem)
        
        view.widthAnchor.constraint(equalTo: splitView.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: splitView.heightAnchor).isActive = true
        
        accessorySplitViewItem.viewController.view.translatesAutoresizingMaskIntoConstraints = false
        accessorySplitViewItem.viewController.view.heightAnchor.constraint(equalToConstant: 128).isActive = true

    }
}
