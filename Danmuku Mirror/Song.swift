//
//  Song.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/2/2.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Foundation

class Song: NSObject {
    var id: String?
    var title: String?
    var artist = [String]()
    var album: String?
    var albumArtUrl: String?
//    var dfsIds
    var url: String?
    
    init(json: JSON) {
        guard json["code"].intValue == 200 else {
            return
        }
        
        self.id = json["songs"]["id"].stringValue
        self.title = json["songs"][0]["name"].stringValue
        for index in 0..<Int(json["songs"][0]["artists"].count) {
            artist.append(json["songs"][0]["artists"][index]["name"].stringValue)
        }
        self.album = json["songs"][0]["album"]["name"].stringValue
        self.albumArtUrl = json["songs"][0]["album"]["picUrl"].stringValue
        self.url = json["songs"][0]["mp3Url"].stringValue
//        json["songs"][0]["hMusic"]["dfsId"].stringValue
//        json["songs"][0]["mMusic"]["dfsId"].stringValue
//        json["songs"][0]["lMusic"]["dfsId"].stringValue
//        json["songs"][0]["hMusic"]["extension"].stringValue
//        json["songs"][0]["mMusic"]["extension"].stringValue
//        json["songs"][0]["lMusic"]["extension"].stringValue
    }
}
