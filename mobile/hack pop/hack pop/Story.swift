//
//  Story.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/21/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class Story: NSObject {
    
    var url:URL? = nil
    var title:String? = nil
    var points:Int? = nil
    var commentsUrl:URL? = nil
    var notificationId:Int? = nil
    
    
    var isHackerNews:Bool = false
    var isUnreadStory = false
    var markedForDeletion = false
    
    static let hackerNewsUrl = "https://news.ycombinator.com/"
    static var current:Story? = nil
    
    static func setCurrentStoryToDefault() {
        let hackerNewsStory = Story(urlString: Story.hackerNewsUrl, title: "", points: 0);
        Story.current = hackerNewsStory
        Story.current?.isHackerNews = true
    }
    
    convenience init(urlString:String, title:String?, points:Int?, notificationId:Int?) {
        self.init(urlString:urlString, title:title, points:points)
        self.notificationId = notificationId
    }
    
    init(urlString:String, title:String?, points:Int?) {
        if Story.isRelativeUrlString(string: urlString) {
            self.url = URL.init(string: Story.hackerNewsUrl + urlString)
        } else {
            self.url = URL.init(string: urlString)
        }
        self.title = title
        self.points = points
    }
    
    init(url:URL?, title:String?, points:Int?) {
        self.url = url
        self.title = title
        self.points = points
    }
    
    static func storyFromPush(pushData:[AnyHashable : Any]) -> Story {
        let urlString = pushData["url"] as! String?
        let title = pushData["title"] as! String?
        let points = pushData["points"] as! Int?
        let notificationId:Int? = pushData["notification_id"] as! Int?
        
        return Story(urlString: urlString!, title: title, points: points, notificationId:notificationId)
    }
    
    static func isRelativeUrlString(string:String) -> Bool {
        return string.range(of: "^https?:\\/\\/", options: .regularExpression) == nil
    }
    
    func meetsThreshold(threshold:Int) -> Bool {
        return points! >= threshold
    }
    
    override func copy() -> Any {
        return Story(urlString: (url?.absoluteString)!, title: title, points: points, notificationId: notificationId)
    }
    
    
    func delete() {
        if !markedForDeletion {
            markedForDeletion = true
        }
    }

}
