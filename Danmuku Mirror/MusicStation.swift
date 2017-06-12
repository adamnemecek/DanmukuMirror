//
//  MusicStation.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/2/2.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Foundation
import AVFoundation

enum playStatus {
    case playing
    case pause
    case stopped
}

protocol MusicStationDelegate: class {
    func playerStatusDidChanged(to: playStatus)
    func trackDidChanged(to: Song?)
}

extension MusicStationDelegate {
    func playerStatusDidChanged(to: playStatus) {}
    func trackDidChanged(to: Song?) {}
}

class MusicStation {
    
    static let shared = MusicStation()
    weak var delegate: MusicStationDelegate?
    
    var player: AVPlayer?
    var playlist: RingBuffer<Song> = {
        let count = UserDefaults.standard.playlistMaxLength
        let rb = RingBuffer<Song>(count: count)
        
        return rb
    }()
    public var isPlaying: Bool {
        return player != nil && player!.isPlaying
    }
    public var status: playStatus = .stopped {
        didSet { delegate?.playerStatusDidChanged(to: status) }
    }
    
    public func searchBy(id: String, _ completionHandler: @escaping (Song?, Error?) -> ()) {
        if let url = URL(string: "http://music.163.com/api/song/detail/?id=\(id)&ids=%5B\(id)%5D" ) {
            // cookies
            let jar = HTTPCookieStorage.shared
            let cookieHeaderField = ["Cookie": "appver=1.5.1;"]
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
            jar.setCookies(cookies, for: url, mainDocumentURL: url)
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("http://music.163.com/", forHTTPHeaderField: "Referer")
            request.timeoutInterval = 5.0
            
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                if error != nil {
                    completionHandler(nil, error)
                    return
                }
                
                let json = JSON(data: data!)
                let song = Song(json: json)
                completionHandler(song, nil)
                
            }).resume()
        }
    }
    
    public func searchBy(title: String, artist: String, _ completionHandler: @escaping (Song?, Error?) -> ()) {
    
    }
    
    public func addToPlaylist(song: Song) {
        if !playlist.write(element: song) {
            // playlist is full
            print("playlist is full")
        }
    }
    
    public func stream(trackId: String) {
        
    }
    
    var item: AVPlayerItem?
    
    public func play() {
        if player == nil {
            if !playlist.isEmpty {
                let song = playlist.read()!
                
                if let urlStr = song.url, let url = URL(string: urlStr) {
                    item = AVPlayerItem(url: url)
                    NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: item)
                    player = AVPlayer(playerItem: item)
                    delegate?.trackDidChanged(to: song)
                    status = .playing
                }
            } else {
                delegate?.trackDidChanged(to: nil)
            }
            
//            if let url = URL(string: "http://m2.music.126.net/zqvI8xba0Un2yiWdkECSJQ==/1364493994787283.mp3") {
//                let item = AVPlayerItem(url: url)
//                NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: item)
//                status = .playing
//                player = AVPlayer(playerItem: item)
//            }
        }
        player?.play()
    }
    
    @objc func didFinishPlaying() {
        player = nil
        status = .stopped
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
        play()
    }
    
    public func pause() {
        if player != nil && player!.isPlaying {
            status = .pause
            player?.pause()
        } else {
            status = .playing
           player?.play()
        }
    }
    
    public func next() {
        
    }
    
    public func reloadPlaylist() {
        let count = UserDefaults.standard.playlistMaxLength
        var newPlaylist = RingBuffer<Song>(count: count)
        
        while !playlist.isEmpty || !newPlaylist.isFull {
            _ = newPlaylist.write(element: playlist.read()!)
        }
        
        playlist = newPlaylist
    }
}
