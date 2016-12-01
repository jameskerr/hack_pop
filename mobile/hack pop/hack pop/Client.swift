//
//  Client.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/23/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class Client: NSObject {
    
    var token:String?
    var successfullySetId:Bool = false
    
    static var _instance:Client? = nil
    static func instance() -> Client {
        if ((_instance) == nil) {
            _instance = Client()
        }
        return _instance!
    }
    
    var _storedToken:String? = nil
    
    struct defaultsKeys {
        static let storedToken = "device_stored_token"
    }
    
    
    let defaults = UserDefaults.standard
    
    var storedToken:String? {
        get {
            if ((_storedToken == nil)) {
                if let defaultsstoredToken:String = defaults.string(forKey: defaultsKeys.storedToken) {
                    _storedToken = defaultsstoredToken
                }
            }
            return _storedToken
            
        } set {
            token = newValue
            _storedToken = newValue
            successfullySetId = true
            defaults.setValue(_storedToken, forKey: defaultsKeys.storedToken)
            defaults.synchronize()
        }
    }

}
