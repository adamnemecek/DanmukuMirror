//
//  DanmukuViewModel.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/19.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

protocol DanmukuPoolDelegate: class {
    func didAddDanmuku(to pool: DanmukuPool, danmukus: [Danmuku])
}

extension DanmukuPoolDelegate {
    func didAddDanmuku(to pool: DanmukuPool, danmukus: [Danmuku]) {}
}

class DanmukuPool {
    
    static let shared = DanmukuPool()
    let delegates = MulticastDelegate<DanmukuPoolDelegate>()
    
    var danmukus = [Danmuku]()
    
    func danmukuAttributedString(at row: Int) -> NSAttributedString {
        
        if let danmuku = danmukus[row] as? RegularDanmuku {
            
            let attributedString = NSMutableAttributedString()
            
            let name = danmuku.userName
            let nameAttributes = [NSAttributedStringKey.foregroundColor: NSColor.green]
            let attributedUserName = NSAttributedString(string: name, attributes: nameAttributes)
            attributedString.append(attributedUserName)
            
            let separator = ": "
            let separatorAttributes = [NSAttributedStringKey.foregroundColor: NSColor.textColor]
            let attributedSeparator = NSAttributedString(string: separator, attributes: separatorAttributes)
            attributedString.append(attributedSeparator)
            
            let content = danmuku.message
            let contentAttributes = [NSAttributedStringKey.foregroundColor: NSColor.textColor]
            let attributedContent = NSAttributedString(string: content, attributes: contentAttributes)
            attributedString.append(attributedContent)
            
            return attributedString
        }
        
        return NSAttributedString(string: "ERR")
    }
    
//    func heightOfDanmuku(at row: Int) {
//
//    }
    
    func add(danmuku: Danmuku) {
        print(#function)
        if danmuku.type == .regular {
            danmukus.append(danmuku)
            delegates.invoke { $0.didAddDanmuku(to: self, danmukus: danmukus) }
        }
    }
    
//    private func add(regularDanmuku: Danmuku) {
//
//    }
}
