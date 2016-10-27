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
import Flurry_iOS_SDK


class Story: NSObject, HttpNotificationConfirmListener {
    
    var url:URL? = nil
    var title:String? = nil
    var points:Int? = nil
    var commentsUrl:URL? = nil
    var notificationId:Int? = nil
    
    
    var isHackerNews:Bool = false
    var isUnreadStory = false
    var read = false
    
    static var lastStoryWasEndOfNotifications = false
    
    static let hackerNewsUrl = "https://news.ycombinator.com/"
    static var current:Story? = nil
    
    static func setCurrentStoryToDefault() {
        let hackerNewsStory = Story(urlString: Story.hackerNewsUrl, commentsUrlString:nil, title: "", points: 0);
        Story.current = hackerNewsStory
        Story.current?.isHackerNews = true
    }
    
    convenience init(urlString:String, commentsUrlString:String?, title:String?, points:Int?, notificationId:Int?) {
        self.init(urlString:urlString, commentsUrlString: commentsUrlString, title:title, points:points)
        self.notificationId = notificationId
    }
    
    init(urlString:String, commentsUrlString:String?, title:String?, points:Int?) {
        if Story.isRelativeUrlString(string: urlString) {
            self.url = URL.init(string: Story.hackerNewsUrl + urlString)
        } else {
            self.url = URL.init(string: urlString)
        }
        if let commentsUrlString = commentsUrlString {
            if Story.isRelativeUrlString(string: commentsUrlString) {
                self.commentsUrl = URL.init(string: Story.hackerNewsUrl + commentsUrlString)
            } else {
                self.commentsUrl = URL.init(string: commentsUrlString)
            }
        }

        self.title = title
        self.points = points
    }
    
    init(url:URL?, commentsUrl:URL?, title:String?, points:Int?) {
        self.url = url
        self.title = title
        self.points = points
        self.commentsUrl = commentsUrl
    }
    
    static func storyFromPush(pushData:[AnyHashable : Any]) -> Story {
        var commentsUrlString:String? = nil
        
        if (pushData["comments_url"] != nil) {
            commentsUrlString = pushData["comments_url"] as! String?
        }
        let urlString = pushData["url"] as! String?
        let points = pushData["points"] as! Int?
        let notificationId:Int? = pushData["id"] as! Int?
        
        return Story(urlString: urlString!,
                     commentsUrlString: commentsUrlString,
                     title: nil,
                     points: points,
                     notificationId: notificationId)
    }
    
    static func isRelativeUrlString(string:String) -> Bool {
        return string.range(of: "^https?:\\/\\/", options: .regularExpression) == nil
    }
    
    func meetsThreshold(threshold:Int) -> Bool {
        return points! >= threshold
    }
    
    override func copy() -> Any {
        
        var commentsUrlString:String? = nil
        if let commentsUrl = commentsUrl {
            commentsUrlString = commentsUrl.absoluteString
        }
        
        return Story(urlString: (url?.absoluteString)!,
                     commentsUrlString: commentsUrlString,
                     title: title,
                     points: points,
                     notificationId: notificationId)
    }
    
    
    func delete() {
        if read == false,
            let notificationId = self.notificationId {
            Story.lastStoryWasEndOfNotifications = true
            HackPopServer.confirmNotification(notificationId: notificationId,
                                              delegate: self)
        }
    }
    
    func onNotificationConfirmed() {
        read = true
        Flurry.logEvent("Notification Confirmed")
    }
    
    func onNotificationConfirationFailed(error:Error?) {
        Flurry.logEvent("Notification Confirmation Failed")
    }

}
