//
//  DanmukuWindowViewController.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/1/18.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class DanmukuWindowViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!

    //
    var unames = [String]()
    var danmukus = [String]()
    //
    var giftUname = [String]()
    var giftName = [String]()
    var giftAmount = [String]()
    var giftAction = [String]()
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        DanmukuHandler.shared.delegates.addDelegate(self)
    }
    
    @IBAction func playAction(_ sender: NSButton) {
        if MusicStation.shared.isPlaying {
            MusicStation.shared.pause()
            sender.title = "Play"
        } else {
            MusicStation.shared.play()
            sender.title = "Pause"
        }
    }
}

// MARK: - Delegate

extension DanmukuWindowViewController: DanmukuHandlerDelegate {
    func didUnpackData(type: DanmukuType, package: AnyObject) {
        switch type {
        case .regular:
            let danmuku = package as! RegularDanmuku
            unames.append(danmuku.userName)
            danmukus.append(danmuku.message)
            
            DispatchQueue.main.async {
                let visible = self.tableView.isLastRowVisible
                self.tableView.reloadDataWithSelection()
                if visible {
                    self.tableView.scrollRowToVisible(self.danmukus.count - 1)
                }
            }
            
//        case .gift:
//            print("")
//        case .welcome:
//            print("")
//        case .boardcast:
//            print("")
        default:
            return
        }
    }
}

extension DanmukuWindowViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.make(withIdentifier: "msgCell", owner: self) as! NSTableCellView
        let attributedString = attributedDanmukuString(at: row)
        
        cellView.textField?.attributedStringValue = attributedString
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let columnWidth = tableView.tableColumns[0].width - 24
        
        let attributedString = attributedDanmukuString(at: row)
        let textWidth = ceil(attributedString.size().width)
        let rows: CGFloat = ceil(textWidth / columnWidth)
        let newHeight = rows * 17
        
        return newHeight
    }
    
    func tableViewColumnDidResize(_ notification: Notification) {
        let visible = self.tableView.isLastRowVisible
        self.tableView.reloadDataWithSelection()
        if visible {
            self.tableView.scrollRowToVisible(self.danmukus.count - 1)
        }
    }
}

// MARK: - DataSource

extension DanmukuWindowViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return danmukus.count
    }
}

// MARK: - Handy Extension

extension DanmukuWindowViewController {
    fileprivate func attributedDanmukuString(at row: Int) -> NSMutableAttributedString {
        let unameAttributedDictionary = [NSForegroundColorAttributeName: DMColor.unameColor.cgColor]
        let attributedString = NSMutableAttributedString(string: unames[row], attributes: unameAttributedDictionary)
        
        let separatorAttributedDictionary = [NSForegroundColorAttributeName: NSColor.lightGray.cgColor]
        attributedString.append(NSAttributedString(string: ": ", attributes: separatorAttributedDictionary))
        
        let danmukuAttributedDictionary = [NSForegroundColorAttributeName: NSColor.lightGray.cgColor]
        attributedString.append(NSAttributedString(string: danmukus[row], attributes: danmukuAttributedDictionary))
        
        return attributedString
    }
}
