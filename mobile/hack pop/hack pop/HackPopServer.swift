//
//  HackPopServer.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/21/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class HackPopServer: NSObject {
    
    static var _instance:HackPopServer? = nil
    
    static func instance() -> HackPopServer {
        if ((HackPopServer._instance) == nil) {
            HackPopServer._instance = HackPopServer()
        }
        return HackPopServer._instance!
    }
    
    
    let defaults = UserDefaults.standard
    var hostUrl = "http://localhost:4001"
    
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
            let httpMethod = "PUT"
            let postDataString = "client_id=\(id)"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = postDataString.data(using: String.Encoding.utf8)
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            return request
            
        }
        
        static func UpdateThreshold(id:String, threshold:Int) -> URLRequest {
            let path = "/clients/\(id)"
            let httpMethod = "PUT"
            let postDataString = "threshold=\(threshold)"
            let url:URL = URL(string: "\(HackPopServer.instance().hostUrl)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = postDataString.data(using: String.Encoding.utf8)
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
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
            let story = Story(url: url, title:title, points: points)
            stories.append(story)
        }
        return stories
    }
    
    func getStories(delegate:HttpStoriesListener) {
        let request = EndPoints.Stories()
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                delegate.onStoriesLoadedError(error: error!)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                    let stories = self.processStories(jsonArray: json)
                    delegate.onStoriesLoaded(stories: stories)
                    
                } catch let error as NSError {
                    
                    delegate.onStoriesLoadedError(error: error)
                    
                }
            }
        })
        task.resume()
    }
}
