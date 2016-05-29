//
//  OptionalTests.swift
//  Tests
//
//  Created by doof nugget on 5/29/16.
//
//

import XCTest
import LVGMonads

class OptionalTests: XCTestCase {
    
    func testFunctorIdentityLaw() {
        
        let optTen: Int? = 10
        
        let x = fmap(id)(optTen)
        let y = id(optTen)
        
        XCTAssertEqual(x, y)
    }
    
    func testFunctorCompositionLaw() {
        
        let optTen: Int? = 10
        let f: Int -> Bool = { $0 == 10 }
        let g: Bool -> String = { $0 ? "true" : "false" }
        
        let x = fmap(g .<< f)(optTen)
        let y = (fmap(g) .<< fmap(f))(optTen)
        
        XCTAssertEqual(x, y)
    }
}
