//
//  HttpNotificationsFetchListener.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/18/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

protocol HttpNotificationsFetchListener {
    func onFetchNotifcationsSuccess(stories:[Story]?) -> Void
    func onFetchNotifcationsFailed(error:Error?) -> Void
}
