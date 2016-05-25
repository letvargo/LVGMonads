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
    
    func testFunctorIdentityLaw() {
    
        let ioTen = io(10)
        
        XCTAssertEqual(<=fmap(id)(ioTen), <=id(ioTen))
    }
    
    func testFunctorCompositionLaw() {
    
        let ioTen = io(10)
        let f: Int -> Bool = { $0 == 10 }
        let g: Bool -> String = { $0 ? "true" : "false" }
        
        XCTAssertEqual(
            <=(   fmap(g  .<< f       )(ioTen)),
            <=(   fmap(g) .<< fmap(f) )(ioTen)
        )
    }
}