//
//  General.swift
//  Tests
//
//  Created by doof nugget on 5/28/16.
//
//

import XCTest
@testable
import LVGMonads

class General: XCTestCase {

    func testLToRFuncComposition() {
        let f: Int -> Int = { $0 * 2 }
        let g: Int -> Double = { Double($0) * 2 }
        let x = 1
        
        XCTAssertEqual((f .>> g)(x), g(f(x)))
    }
    
    func testRToLFuncComposition() {
        let f: Int -> Int = { $0 * 2 }
        let g: Int -> Double = { Double($0) * 2 }
        let x = 1
        
        XCTAssertEqual((g .<< f)(x), g(f(x)))
    }
    
    func testLToRFuncApplication()  {
        let f: Int -> Int = { $0 * 2 }
        let x = 1
        
        XCTAssertEqual(x --> f, f(x))
    }
    
    func testRToLFuncApplication()  {
        let f: Int -> Int = { $0 * 2 }
        let x = 1
        
        XCTAssertEqual(f <-- x, f(x))
    }
    
    func testIdentity() {
        let x = 1
        
        XCTAssertEqual(id(x), x)
    }
}
