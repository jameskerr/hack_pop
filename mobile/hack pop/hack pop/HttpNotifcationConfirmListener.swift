//
//  HttpNotifcationConfirmListener.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/20/16.
//  Copyright © 2016 james inc. All rights reserved.
//


protocol HttpNotificationConfirmListener {
    func onNotificationConfirmed() -> Void
    func onNotificationConfirationFailed(error:Error?) -> Void
}
