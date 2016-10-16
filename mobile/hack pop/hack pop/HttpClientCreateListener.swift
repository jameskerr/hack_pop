//
//  HttpClientCreateListener.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/12/16.
//  Copyright © 2016 james inc. All rights reserved.
//

protocol HttpClientCreateListener {
    func onClientCreated(id:String) -> Void
    func onClientCreatedFailed(error:Error) -> Void
}
