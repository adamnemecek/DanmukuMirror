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

class RegularDanmuku {
	let type = DanmukuType.regular
	var message : String
	var userId : Int
	var userName : String
	
	init(json: JSON) {
//		json["cmd"].stringValue	// 类型
//		json["info"][0][0]		// ?
//		json["info"][0][1]		// ?
//		json["info"][0][2]		// ?
//		json["info"][0][3]		// ?
//		json["info"][0][4]		// ?
//		json["info"][0][5]		// ?
//		json["info"][0][6]		// ?
//		json["info"][0][7]		// ?
//		json["info"][0][8]		// ?
           message = json["info"][1].stringValue		// 弹幕内容
            userId = json["info"][2][0].intValue		// UID
          userName = json["info"][2][1].stringValue		// 观众昵称
//		json["info"][2][2]		// ?
//		json["info"][2][3]		// ?
//		json["info"][2][4]		// ?
//		json["info"][2][5]		// ?
//		json["info"][3]			// 勋章
//		json["info"][4][0]		// 用户等级
//		json["info"][4][1]		// ?
//		json["info"][4][2]		// ?
//		json["info"][4][3]		// 用户排名
//		json["info"][5]			// 标识
	}
}

class GiftDanmuku {
	let type = DanmukuType.gift
	var giftName : String
	var amount : Int
	var userName : String
	var userId : Int
	var action : String
	
	init(json: JSON) {
//		json["cmd"].stringValue
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
	}
}

class WelcomeDanmuku {
	let type = DanmukuType.welcome
	var userId : Int
	var userName : String
	var isAdmin : Bool
	var isVIP : Bool
	
	init(json: JSON) {
		let jsonData = json["data"]
		userId = jsonData["uid"].intValue
		userName = jsonData["data"]["uname"].stringValue
		isAdmin = jsonData["isadmin"].intValue == 1 ? true : false
		isVIP = jsonData["vip"].intValue == 1 ? true : false
//		json["roomid"].intValue
	}
}

