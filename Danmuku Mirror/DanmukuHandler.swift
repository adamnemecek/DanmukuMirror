//
//  DanmukuHandler.swift
//  DanmukuMirror
//
//  Created by ixan on 2017/1/8.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

// MARK: Enum

/// A enumeration indicating connection status.
enum ConnectStatus {
    case disconnected
    case connnecting
    case connected
}

// MARK: - Protocol

protocol DanmukuHandlerDelegate: class {
    func statusDidChange(status: ConnectStatus)
    func didReceviedOnlineCount(_ online: Int)
    func didReceviedData(rawJson: JSON)
    func didUnpackData(type: DanmukuType, package: AnyObject)
}

extension DanmukuHandlerDelegate {
    func statusDidChange(status: ConnectStatus) {}
    func didReceviedOnlineCount(_ online: Int) {}
    func didReceviedData(rawJson: JSON) {}
    func didUnpackData(type: DanmukuType, package: AnyObject) {}
}

// MARK: -

class DanmukuHandler: NSObject, StreamDelegate {
    
    static let shared = DanmukuHandler()
    let delegates = MulticastDelegate<DanmukuHandlerDelegate>()

    fileprivate var inputStream: InputStream?
    fileprivate var outputStream: OutputStream?
    fileprivate var timer: Timer?
    
    public var status = ConnectStatus.disconnected
    public var isConnected: Bool { get { return status == .connected } }
    public var isConnecting: Bool { get { return status == .connnecting } }
    public var isDisconnected: Bool { get { return status == .disconnected } }
    public var isCached: Bool { get { return isRoomCached && isRealRoomCached } }
    public var cookie: String = ""
    
    fileprivate var isRoomCached: Bool { return profile.cachedRoom == profile.room }
    fileprivate var isRealRoomCached: Bool { return profile.cachedRealRoom > 0 }
//    fileprivate var isServerCached: Bool { return UserDefaults.standard.string(forKey: "dm.cache.server") != nil }
    
    // MARK: -

    public func start() {
        let roomId = profile.room
        
        changeStatus(to: .connnecting)
        
        if !isCached {
            Util.httpGet(from: "http://live.bilibili.com/\(roomId)", { (result, error) in
                guard error == nil else {
                    self.changeStatus(to: .disconnected)
                    return
                }
                
                // get real room id
                let realRoomId = result!.substring(between: "var ROOMID = ", and: ";")
                
                // caching other info
                let roomName = result!.substring(between: "room-title\" title=\"", and: "\">")
                profile.cachedRoomName = roomName ?? "-"
                let owner = result!.substring(between: "info-text\" title=\"", and: "\">")
                profile.cachedOwner = owner ?? "-"
                
                if let realRoomId = realRoomId {
                    // get server url
                    Util.httpGet(from: "http://live.bilibili.com/api/player?id=cid:\(realRoomId)", { (result, error) in
                        guard error == nil else {
                            self.changeStatus(to: .disconnected)
                            return
                        }
                        
                        let server = result!.substring(between: "<server>", and: "</server>") ?? profile.defaultServer
                        
                        self.openConnection(to: Int(realRoomId)!, with: server, at: 788)
                        self.changeStatus(to: .connected)
                        
                        profile.cachedRoom = roomId
                        profile.cachedRealRoom = Int(realRoomId) ?? 0
                        profile.cachedServer = server
                    })
                }
            })

        } else {
            let room = profile.cachedRealRoom
            let server = profile.cachedServer
            self.openConnection(to: room, with: server, at: 788)
            changeStatus(to: .connected)
        }
    }
    
    public func stop() {
        if !isDisconnected {
            inputStream?.close()
            outputStream?.close()
            
            inputStream?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
            outputStream?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
            
            timer?.invalidate()
            timer = nil
            
            changeStatus(to: .disconnected)
        }
    }
    
    fileprivate func reconnect() {
        stop()
        start()
    }
    
    fileprivate func openConnection(to room: Int, with server: String, at port: UInt32) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        let host: CFString = NSString(string: server)
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readStream, &writeStream)
        
        inputStream = readStream?.takeUnretainedValue()
        outputStream = writeStream?.takeRetainedValue()
        inputStream!.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream!.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream?.delegate = self
        outputStream?.delegate = self
        inputStream!.open()
        outputStream!.open()
        
        let uid = 1000000000 + arc4random() % 2000000000
        let joinRoomMsg = "{\"roomid\": \(room), \"uid\": \(uid)}".data(using: .utf8)!
        
        self.send(outputStream!, totalLength: joinRoomMsg.count + 16, headerLength: 16, protocolVersion: 1, action: 7, param5: 1, data: joinRoomMsg)
        
        // send heartbeat
        self.sendHeartbeat()
    }
    
    fileprivate func sendHeartbeat() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {_ in
            self.send(self.outputStream!, totalLength: 16, headerLength: 16, protocolVersion: 1, action: 2, param5: 1, data: nil)
        }
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    public func sendDanmuku(message: String, handler: (_ code: Int, _ msg: String, _ data: [String]) -> Void) {
        if let url = URL(string: "http://live.bilibili.com/msg/send") {
            let request = NSMutableURLRequest(url: url)
            request.timeoutInterval = 5.0
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            // TODO: load from profile
            request.setValue("DedeUserID=1727932; DedeUserID__ckMd5=8730a7c5b4448179; SESSDATA=e42c15a1%2C1492353843%2C0046bc81;", forHTTPHeaderField: "Cookie")
            if let data = "msg=\(message)&roomid=\(profile.cachedRealRoom)".data(using: .utf8) {
                request.httpBody = data
                
                URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    if error != nil { return }
                    if let data = data {
                        let json = JSON(data: data)
                        Swift.print(json["code"].string)
                        
                    } else {
                        Swift.print("no data!")
                    }
                }).resume()
            }
        }
    }
    
    internal func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == Stream.Event.hasBytesAvailable {
            let inputStream = aStream as! InputStream
            var buffer = [UInt8](repeating: 0, count: 10240)
            let result = inputStream.read(&buffer, maxLength: buffer.count)
            if result > 0 {
                let receivedData = [UInt8](buffer[0..<result])
                self.analyze(receivedData)
            }
        } else {
            Swift.print("stram event code \(eventCode)")
        }
    }
    
    fileprivate func analyze(_ data: [UInt8]) {
        var received = data
        let dataLength = received.count
        
        // broken data
        guard dataLength >= 16 else { return }
        
        let msgLength = Util.readIntFrom(received)
        
        // consider a larger buffer
        guard msgLength >= 16 else { return }
        
        if msgLength < dataLength {
            // received multiple messages
            analyze([UInt8](received[0..<msgLength]))
            analyze([UInt8](received[msgLength..<dataLength]))
            
        } else if msgLength == dataLength {
            // recevied message
            let actionCode = Util.readIntFrom([UInt8](received[8..<12]))
            
            switch actionCode {
            case 3: // heartbeat respond (current online)
                let online = Util.readIntFrom([UInt8](received[16..<20]))
                delegates.invoke { $0.didReceviedOnlineCount(online) }
                
            case 5: // data respond
                let rawJson = NSString(bytes: [UInt8](received[16..<received.count]), length: received.count - 16, encoding: String.Encoding.utf8.rawValue)
                if let dataFromString = rawJson?.data(using: String.Encoding.utf8.rawValue) {
                    let json = JSON(data: dataFromString)
                    delegates.invoke { $0.didReceviedData(rawJson: json) }
                    
                    // Unpack
                    switch json["cmd"] {
                    case "DANMU_MSG": delegates.invoke { $0.didUnpackData(type: .regular, package: RegularDanmuku(json: json)) }
                    case "SEND_GIFT": delegates.invoke { $0.didUnpackData(type: .gift,    package: GiftDanmuku(json: json))    }
                    case   "WELCOME": delegates.invoke { $0.didUnpackData(type: .welcome, package: WelcomeDanmuku(json: json)) }
                    default:          print("undefined cmd")
                    }
                }
                
            default: // other action we don't care yet
                print("unknow action code")
            }
        }
    }
    
    fileprivate func send(_ outputStream: OutputStream, totalLength: Int32, headerLength: CShort, protocolVersion: CShort, action: Int32, param5: Int32, data: Data?) {
        var totalLengthBE = totalLength.bigEndian
        var headerLengthBE = headerLength.bigEndian
        var protocolVersionBE = protocolVersion.bigEndian
        var actionBE = action.bigEndian
        var param5BE = param5.bigEndian
        
        withUnsafePointer(to: &totalLengthBE) {
            _ = $0.withMemoryRebound(to: UInt8.self, capacity: 1, { outputStream.write($0, maxLength: MemoryLayout<Int32>.size) })
        }
        withUnsafePointer(to: &headerLengthBE) {
            _ = $0.withMemoryRebound(to: UInt8.self, capacity: 1, { outputStream.write($0, maxLength: MemoryLayout<CShort>.size) })
        }
        withUnsafePointer(to: &protocolVersionBE) {
            _ = $0.withMemoryRebound(to: UInt8.self, capacity: 1, { outputStream.write($0, maxLength: MemoryLayout<CShort>.size) })
        }
        withUnsafePointer(to: &actionBE) {
            _ = $0.withMemoryRebound(to: UInt8.self, capacity: 1, { outputStream.write($0, maxLength: MemoryLayout<Int32>.size) })
        }
        withUnsafePointer(to: &param5BE) {
            _ = $0.withMemoryRebound(to: UInt8.self, capacity: 1, { outputStream.write($0, maxLength: MemoryLayout<Int32>.size) })
        }
        if data != nil {
            _ = data!.withUnsafeBytes { outputStream.write($0, maxLength: data!.count) }
        }
    }
    
    fileprivate func changeStatus(to: ConnectStatus) {
        status = to
        delegates.invoke { $0.statusDidChange(status: status) }
    }
}

