//
//  HttpNotificationGetListener.swift
//  hack pop
//
//  Created by Jamie Sunderland on 11/30/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

protocol HttpNotificationGetListener {
    func onGetNotificationSucceeded(story:Story) -> Void
}
