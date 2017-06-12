//
//  Util.swift
//  DanmukuMirror
//
//  Created by ixan on 2017/1/8.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

class Util: NSObject, URLSessionDelegate {
    
    static func httpGet(from url: String, _ completionHandler: @escaping (String?, Error?) -> Void) {
//        print("perform http GET from \(url)")
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error == nil {
                    // do stuff
                    let rawHttp = "\(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))"
                    completionHandler(rawHttp, nil)
                } else {
                    // deal with error
                    print("Err performing http GET!")
                    completionHandler(nil, error)
                }
            }.resume()
        }
    }
    
//    static func substring(from string: String, between A: String, and B: String) -> String? {
//        guard let beginIndex = string.range(of: A)?.upperBound else {
//            print("ERR getting substring: can't find \"\(A)\"")
//            return nil
//        }
//
//        let cuttedString = string.substring(from: beginIndex)
//        
//        guard let endIndex = cuttedString.range(of: B)?.lowerBound else {
//            print("ERR getting substring: can't find \"\(B)\"")
//            return nil
//        }
//        
//        let result = cuttedString.substring(to: endIndex)
//        
//        return result.characters.count == 0 ? nil : result
//    }
//    
//    static func count(string: String, from origString: String) -> Int {
//        var count = 0
//        var str = origString
//        
//        while str.range(of: string) != nil {
//            count += 1
//            str = str.substring(from: (str.range(of: string)?.upperBound)!)
//        }
//        
//        return count
//    }
    
    static func readIntFrom(_ array: [UInt8]) -> Int {
        let array = [UInt8](array[0..<4].reversed())
        var value = 0
        
        let data = Data(bytes: UnsafePointer<UInt8>(array), count: 4)
        (data as NSData).getBytes(&value, length: 4)
        
        value = Int(littleEndian: value)
        return value
    }
}

extension String {
    func substring(between: String, and: String) -> String? {
        var string = self
        
        guard let beginIndex = string.range(of: between)?.upperBound else {
            return nil
        }
        
        string = string.substring(from: beginIndex)
        
        guard let endIndex = string.range(of: and)?.lowerBound else {
            return nil
        }

        string = string.substring(to: endIndex)
        
        return string.characters.count == 0 ? nil : string
    }
    
    func count(other: String) -> Int {
        var string = self
        var count = 0
        
        while string.range(of: other) != nil {
            count += 1
            string = string.substring(from: (string.range(of: other)?.upperBound)!)
        }
        
        return count
    }
}

