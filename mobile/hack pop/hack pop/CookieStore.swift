//
//  CookieStore.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/26/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class CookieStore: NSObject {
    
    static func loadCookies() {
        
        let cookieDict : NSMutableArray? = UserDefaults.standard.value(forKey: "cookieArray") as? NSMutableArray
        
        if cookieDict != nil {
            
            for var cookie in cookieDict! {
                
                let cookies = UserDefaults.standard.value(forKey: cookie as! String) as! NSDictionary
                let httpCookie = HTTPCookie(properties: cookies as! [HTTPCookiePropertyKey : Any])
                HTTPCookieStorage.shared.setCookie(httpCookie!)
            }
        }
    }
    
    static func saveCookies() {
        
        let cookieArray = NSMutableArray()
        let savedCookies = HTTPCookieStorage.shared.cookies
        let expiration = TimeInterval.infinity
        
        for var cookie : HTTPCookie in savedCookies! {
            
            let cookieProps = NSMutableDictionary()
            cookieArray.add(cookie.name)
            cookieProps.setValue(cookie.name, forKey: HTTPCookiePropertyKey.name.rawValue)
            cookieProps.setValue(cookie.value, forKey: HTTPCookiePropertyKey.value.rawValue)
            cookieProps.setValue(cookie.domain, forKey: HTTPCookiePropertyKey.domain.rawValue)
            cookieProps.setValue(cookie.path, forKey: HTTPCookiePropertyKey.path.rawValue)
            cookieProps.setValue(cookie.version, forKey: HTTPCookiePropertyKey.version.rawValue)
            cookieProps.setValue(NSDate().addingTimeInterval(expiration), forKey: HTTPCookiePropertyKey.expires.rawValue)
            
            UserDefaults.standard.setValue(cookieProps, forKey: cookie.name)
            UserDefaults.standard.synchronize()
            
        }
        
        UserDefaults.standard.setValue(cookieArray, forKey: "cookieArray")
    }

}
