//
//  Danmuku.swift
//  Danmuku Mirror
//
//  Created by Ixan on 16/9/1.
//  Copyright © 2016年 IXAN Production. All rights reserved.
//

import Cocoa

enum DanmukuType {
	case regular
	case boardcast
	case gift
	case welcome
}

class Danmuku {
    var type: DanmukuType
    
    init(type: DanmukuType) {
        self.type = type
    }
    
}

class RegularDanmuku: Danmuku {
	var message : String
	var userId : Int
	var userName : String
	
	init(json: JSON) {
        message = json["info"][1].stringValue		// 弹幕内容
        userId = json["info"][2][0].intValue		// UID
        userName = json["info"][2][1].stringValue	// 观众昵称
        
        super.init(type: .regular)
	}
}

class GiftDanmuku: Danmuku {
	var giftName : String
	var amount : Int
	var userName : String
	var userId : Int
	var action : String
	
	init(json: JSON) {
//		json["roomid"].intValue
		
		let jsonData = json["data"]
		
		giftName = jsonData["giftName"].stringValue
		amount = jsonData["num"].intValue
		userName = jsonData["uname"].stringValue
//		jsonData["rcost"].intValue
		userId = jsonData["uid"].intValue
//		jsonData["top_list"]
//		jsonData["timestamp"].intValue
//		jsonData["giftId"].intValue
//		jsonData["giftType"].intValue
		action = jsonData["action"].stringValue
//		jsonData["super"].intValue
//		jsonData["price"].intValue
//		jsonData["rnd"].intValue
//		jsonData["newMedal"].intValue
//		jsonData["medal"].intValue
//		jsonData["capsule"]
//		jsonData["summerScore"].intValue
//		jsonData["summerNum"].intValue
        super.init(type: .gift)
	}
}

//class WelcomeDanmuku: Danmuku {
//    var userId : Int
//    var userName : String
//    var isAdmin : Bool
//    var isVIP : Bool
//
//    init(json: JSON) {
//        let jsonData = json["data"]
//        userId = jsonData["uid"].intValue
//        userName = jsonData["data"]["uname"].stringValue
//        isAdmin = jsonData["isadmin"].intValue == 1 ? true : false
//        isVIP = jsonData["vip"].intValue == 1 ? true : false
////        json["roomid"].intValue
//        super.init(type: .welcome)
//    }
//}

