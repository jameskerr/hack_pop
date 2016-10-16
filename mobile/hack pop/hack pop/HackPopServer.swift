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
    var hostUrl = "http://ec2-52-201-223-136.compute-1.amazonaws.com"
    
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
        
    }
    
    override init() {
        if let defaultsUrl = defaults.string(forKey: defaultsKeys.HackPopUrl) {
            hostUrl = defaultsUrl
        }
    }
    
    private func processStories(jsonArray:[[String:Any]]) -> [Story] {
        var stories:[Story] = []
        for parsedStory in jsonArray {
            let url:String = parsedStory["url"] as! String
            let title:String = parsedStory["title"] as! String
            let points:Int = parsedStory["points"] as! Int
            let story = Story(urlString: url, title:title, points: points)
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
                    let stories = self.processStories(jsonArray: json)
                    
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
}
