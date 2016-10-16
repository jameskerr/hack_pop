//
//  HackPopStyleTests.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/20/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import XCTest
import UIKit

class HackPopStyleTests: XCTest {
    func testGetStyledPointSelectionCell() {
        let cell300 = HackPopStyle.GetStyledPointSelectionCell("300" as AnyObject)
        XCTAssert(cell300.textLabel?.text == "300 Points")
    }

}
