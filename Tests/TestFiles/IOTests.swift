//
//  IOTests.swift
//  Tests
//
//  Created by doof nugget on 5/24/16.
//
//

import XCTest
@testable
import LVGMonads

class IOTests: XCTestCase {

    let ioPrint: Any -> IO<()> = { a in IO { print(a) } }
    let intToString: Int -> String = { $0.description }
    
    func testAction() {
        let one = io(1)
        XCTAssertEqual(one.action(), 1, "action() did not extract correct value.")
    }
    
    func testActionOperator() {
        let one = io(1)
        XCTAssertEqual(<=one, 1, "action() did not extract correct value.")
    }
    
    func testFmapOperator() {
        
        let op: IO<String> =
                intToString
            <^> io(10)
        
        XCTAssertEqual(op.action(), "10", "Did not convert correctly.")
    }
}