//
//  PersistedStory.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/12/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PersistedStory: NSManagedObject {
    @NSManaged var url:URL
    @NSManaged var comments:URL
    @NSManaged var title:String
    @NSManaged var points:Int
    
    
}
