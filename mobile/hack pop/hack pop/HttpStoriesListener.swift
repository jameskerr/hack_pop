//
//  HttpStoriesListener.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/21/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

protocol HttpStoriesListener {
    func onStoriesLoaded(stories:[Story]) -> Void
    func onStoriesLoadedError(error:Error) -> Void
}
