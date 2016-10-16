//
//  HttpSetThresholdListener.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/12/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

protocol HttpSetThresholdListener {
    func onThresholdSet(threshold:Int) -> Void
    func onThresholdSetFailed(error:Error?, threshold:Int) -> Void
}
