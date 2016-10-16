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
    
    static func isRelativeUrlString(string:String) -> Bool {
        return string.range(of: "^https?:\\/\\/", options: .regularExpression) == nil
    }
    
    func meetsThreshold(threshold:Int) -> Bool {
        return points! >= threshold
    }
    
    override func copy() -> Any {
        return Story(url: url, title: title, points: points)
    }
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Story", in: context)
        let transaction = NSManagedObject(entity: entity!, insertInto: context)
        
        transaction.setValue(NSDate(), forKey: "createdAt")
        transaction.setValue(false, forKey: "seen")
        
        if let title = self.title {
            transaction.setValue(title, forKey: "title")
        }
        
        if let points = self.points {
            transaction.setValue(points, forKey: "points")
        }
        
        if let commentsUrl = self.commentsUrl {
            transaction.setValue("\(commentsUrl)", forKey: "commentsUrl")
        }
        
        if let url = self.url {
            transaction.setValue("\(url)", forKey: "url")
        }
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func updateSeen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Story")
        if let urlString = url?.absoluteString {
            request.predicate = NSPredicate(format: "url == %@", urlString)
            do {
                
                let results = try context.fetch(request)
                if results.count > 0 {
                    let object:NSManagedObject = results.first as! NSManagedObject
                    object.setValue(true, forKey: "seen")
                    try context.save()
                }
                
            } catch {
                print("Error with request: \(error)")
            }
        }
    }
    
    func delete() {
        if !markedForDeletion {
            markedForDeletion = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Story")
            if let urlString = url?.absoluteString {
                request.predicate = NSPredicate(format: "url == %@", urlString)
                do {
                    
                    let results = try context.fetch(request)
                    if results.count > 0 {
                        let object:NSManagedObject = results.first as! NSManagedObject
                        context.delete(object)
                        try context.save()
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
            }
        }
    }
    
    static func getSavedStories() -> [Story] {
        //limit stories
        var stories:[Story] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Story")
        //limit to 15 order by descending time where unseen
        let sectionSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        request.fetchLimit = 15
        let booleanLiteral = NSNumber.BooleanLiteralType(false)
        request.predicate = NSPredicate(format: "seen == %@", booleanLiteral as CVarArg)
        
        do {
            
            
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                let title:String = result.value(forKey: "title") as! String
                let url:String = result.value(forKey: "url") as! String
                //let commentsUrl:String = result.value(forKey: "commentsUrl") as! String
                let points:Int = result.value(forKey: "points") as! Int
                let story = Story(urlString: url, title: title, points: points)
                story.isUnreadStory = true
                stories.append(story)
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return stories
    }

}
