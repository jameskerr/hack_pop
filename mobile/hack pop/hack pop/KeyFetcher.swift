//
//  KeyFetcher.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/16/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class KeyFetcher: NSObject {
    
    static func getApiKey(key:String) -> AnyObject? {
        
        var value: AnyObject?
        var dictionary:NSDictionary? = nil
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path)
        }
        if let dict = dictionary {
            value = dict[key] as AnyObject
        }
        return value
    }

}
