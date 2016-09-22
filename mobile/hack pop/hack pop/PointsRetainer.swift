//
//  PointsRetainer.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/19/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class PointsRetainer: NSObject {
    static var _instance:PointsRetainer? = nil
    static func instance() -> PointsRetainer {
        if ((_instance) == nil) {
            _instance = PointsRetainer()
        }
        return _instance!
    }
    
    let pointSelectionValues:NSArray = [100, 200, 300, 400, 500, 750, 1000]
    let initialDefaultValue = 300
    
    struct defaultsKeys {
        static let PointsValue = "point_value"
    }
    
    let defaults = UserDefaults.standard
    var _value:Int?
    
    var value:Int {
        get {
            if ((_value == nil)) {
                if let defaultsValue:Int = defaults.integer(forKey: defaultsKeys.PointsValue) {
                    if defaultsValue != 0 {
                        _value = defaultsValue
                    } else {
                        defaults.setValue(initialDefaultValue, forKey: defaultsKeys.PointsValue)
                        defaults.synchronize()
                        _value = initialDefaultValue
                    }
                }
            }
            return _value!
        
        } set {
            _value = newValue
            defaults.setValue(_value, forKey: defaultsKeys.PointsValue)
            defaults.synchronize()
        }
    }
    

}
