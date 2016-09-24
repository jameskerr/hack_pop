//
//  Story.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/21/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit


class Story: NSObject {
    
    var url:URL? = nil
    var title:String? = nil
    var points:Int? = nil
    
    static var current:Story? = nil
    
    init(url:String, title:String, points:Int) {
        self.url = URL.init(string: url)
        self.title = title
        self.points = points
    }
    
    func meetsThreshold(threshold:Int) -> Bool {
        return points! >= threshold
    }

}
