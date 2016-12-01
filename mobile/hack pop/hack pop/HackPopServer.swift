//
//  HackPopServer.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/21/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

enum RequestError : Error {
    case InvalidStatusCode
}


class HackPopServer: NSObject {
    
    static var _instance:HackPopServer? = nil
    
    private static var lastRequestTime:NSDate? = nil
    private static var cachedStories:[Story]? = nil
    
    
    static func instance() -> HackPopServer {
        if ((HackPopServer._instance) == nil) {
            HackPopServer._instance = HackPopServer()
        }
        return HackPopServer._instance!
    }
    
    
    let defaults = UserDefaults.standard
    
    #if DEBUG
        var hostUrl = KeyFetcher.getApiKey(key: "Hack Pop Dev Url") as! String
    #else
        var hostUrl = KeyFetcher.getApiKey(key: "Hack Pop Prod Url") as! String
    #endif
    
    struct defaultsKeys {
        static let HackPopUrl = "hack_pop_url"
    }
    
    struct EndPoints {
        static func Stories() -> URLRequest {
            let path = "/stories"
            let httpMethod = "GET"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            return request
            
        }
        
        static func GetNotifications(id:String) ->URLRequest {
            let path = "/clients/\(id)/notifications"
            let httpMethod = "GET"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            return request
        }
        
        static func UpdateReadNotification(clientId:String, notificationId:Int) ->URLRequest {
            let path = "/clients/\(clientId)/notifications/\(notificationId)"
            let httpMethod = "PUT"
            let postDataString = "read=true"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = postDataString.data(using: String.Encoding.utf8)
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            return request
        }
        
        static func CreateClient(id:String) -> URLRequest {
            let path = "/clients"
            let httpMethod = "POST"
            let postDataString = "client_id=\(id)"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = postDataString.data(using: String.Encoding.utf8)
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            return request
            
        }
        
        static func UpdateThreshold(id:String, threshold:Int) -> URLRequest {
            let path = "/clients/\(id)"
            let httpMethod = "PUT"
            let putDataString = "threshold=\(threshold)"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = putDataString.data(using: String.Encoding.utf8)
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            return request
            
        }
        
        static func GetNotification(clientId:String, notificationId:Int) -> URLRequest {
            let path = "/clients/\(clientId)/notifications/\(notificationId)"
            let httpMethod = "GET"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            return request
        }
        
    }
    
    static func processStory(json:[String:Any]) -> Story {
        let url:String = json["url"] as! String
        let commentsUrl:String = json["comments_url"] as! String
        let title:String = json["title"] as! String
        let points:Int = json["points"] as! Int
        let notificationId:Int? = (json["notification_id"] as? Int?)!
        return Story(urlString: url,
                          commentsUrlString:commentsUrl,
                          title:title,
                          points: points,
                          notificationId: notificationId)
    }
    
    static func processStories(jsonArray:[[String:Any]]) -> [Story] {
        var stories:[Story] = []
        for parsedStory in jsonArray {
            let story = processStory(json: parsedStory)
            stories.append(story)
        }
        return stories
    }
    
    func getStories(delegate:HttpStoriesListener) {
        
        // if five minutes has not passed send back the cached stories and short circuit
        if (!HackPopServer.shouldRequestNewStories()) {
            delegate.onStoriesLoaded(stories: HackPopServer.cachedStories!)
            return
        }
        
        let request = EndPoints.Stories()
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                delegate.onStoriesLoadedError(error: error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                    if (httpResponse?.statusCode)! < 200 || (httpResponse?.statusCode)! >= 300 {
                        throw RequestError.InvalidStatusCode
                    }
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                    let stories = HackPopServer.processStories(jsonArray: json)
                    
                    // store the stories and update the cache
                    HackPopServer.cachedStories = stories
                    HackPopServer.lastRequestTime = NSDate()
                    
                    delegate.onStoriesLoaded(stories: stories)
                    
                } catch let error as NSError {
                    
                    delegate.onStoriesLoadedError(error: error)
                    
                }
            }
        })
        task.resume()
    }
    
    static func shouldRequestNewStories() -> Bool {
        
        let twoMinutesInSeconds:Double = 120
        if let lastRequestTime = HackPopServer.lastRequestTime {
            let elapse = lastRequestTime.timeIntervalSinceNow as Double
            // has five minutes passed?
            // note elapse is a negative number 
            return -elapse > twoMinutesInSeconds
        }
        // the stories do not exist yet so we should request them
        return true
    }
    
    static func setClient(id:String, delegate:HttpClientCreateListener) {
        
        let request = EndPoints.CreateClient(id: id)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                delegate.onClientCreatedFailed(error: error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                    if (httpResponse?.statusCode)! < 200 || (httpResponse?.statusCode)! >= 300 {
                        throw RequestError.InvalidStatusCode
                    }
                    delegate.onClientCreated(id: id)
                    
                } catch let error as NSError {
                    
                   delegate.onClientCreatedFailed(error: error)
                    
                }
            }
        })
        task.resume()
    }
    
    static func fetchNotifcations(id:String?, delegate:HttpNotificationsFetchListener) {
        
        var stories:[Story]? = nil
        
        if !Client.instance().successfullySetId ||  id == nil {
            delegate.onFetchNotifcationsFailed(error: nil)
            return
        }
        
        let request = EndPoints.GetNotifications(id: id!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                delegate.onFetchNotifcationsFailed(error: error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                    if (httpResponse?.statusCode)! < 200 || (httpResponse?.statusCode)! >= 300 {
                        throw RequestError.InvalidStatusCode
                    }
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                    stories = HackPopServer.processStories(jsonArray: json)
                    delegate.onFetchNotifcationsSuccess(stories: stories)
                    
                } catch let error as NSError {
    
                    delegate.onFetchNotifcationsFailed(error: error)
                    
                }
            }
        })
        task.resume()
    
    }
    
    static func setTheshold(id:String?, threshold:Int, delegate:HttpSetThresholdListener) -> Bool {
        
        let thresholdBeforeRequestCompletes:Int = PointsRetainer.instance().value
        
        if !Client.instance().successfullySetId ||  id == nil {
            delegate.onThresholdSetFailed(error: nil, threshold: thresholdBeforeRequestCompletes)
            return false
        }
        
        let request = EndPoints.UpdateThreshold(id: id!, threshold: threshold)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                delegate.onThresholdSetFailed(error: error, threshold: thresholdBeforeRequestCompletes)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                    if (httpResponse?.statusCode)! < 200 || (httpResponse?.statusCode)! >= 300 {
                        throw RequestError.InvalidStatusCode
                    }
                    delegate.onThresholdSet(threshold: threshold)
                    
                } catch let error as NSError {
                    
                    delegate.onThresholdSetFailed(error: error, threshold: thresholdBeforeRequestCompletes)
                    
                }
            }
        })
        task.resume()
        return true
    }
    
    static func confirmNotification(notificationId:Int, delegate:HttpNotificationConfirmListener) {

        if let token = Client.instance().token {
            let request = EndPoints.UpdateReadNotification(clientId:token, notificationId:notificationId)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    delegate.onNotificationConfirationFailed(error: error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    do {
                        if (httpResponse?.statusCode)! < 200 || (httpResponse?.statusCode)! >= 300 {
                            throw RequestError.InvalidStatusCode
                        }
                        delegate.onNotificationConfirmed()
                        
                    } catch let error as NSError {
                        
                        delegate.onNotificationConfirationFailed(error: error)
                        
                    }
                }
            })
            task.resume()
        }
    }
    
    static func getNotification(notificationId:Int, delegate:HttpNotificationGetListener) {
        if let token = Client.instance().token {
            let request = EndPoints.GetNotification(clientId: token, notificationId: notificationId)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                
                if error == nil {
                    let httpResponse = response as? HTTPURLResponse
                    do {
                        if (httpResponse?.statusCode)! < 200 || (httpResponse?.statusCode)! >= 300 {
                            throw RequestError.InvalidStatusCode
                        }
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        let story = processStory(json: json)
                        delegate.onGetNotificationSucceeded(story: story)
                        
                    } catch _ as NSError {
                        
                    }
                }
            })
            task.resume()
        }
    }
}
