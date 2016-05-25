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

    let ioPrint: Any -> IO<()> = { a in IO { print(a) } }
    let intToString: Int -> String = { $0.description }
    
    func testFmap() {
    
        let test: String -> IO<()> = { x in
            IO { XCTAssertEqual(x, "10", "Did not convert correctly.") }
        }
        
        let main: IO<Main> =
            intToString
            <^> io(10)
            =>> test
            =>> exit
        
        _ = <=main
    }
}