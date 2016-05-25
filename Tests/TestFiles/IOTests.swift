//
//  IOTests.swift
//  Tests
//
//  Created by doof nugget on 5/24/16.
//
//

import XCTest
import LVGMonads

class IOTests: XCTestCase {

    func testIOMainActionOperator() {
        let main: IO<Main> = io(Main())
        
        let m = <=main
        
        XCTAssertTrue(m is Main, "<= did not return a Main type.")
    }
}