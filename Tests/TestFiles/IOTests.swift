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
    
    func testBind() {
    
        let one = io(1)
        
        let main: IO<Main> =
            one =>> { x in
            
                io <-- XCTAssertEqual(x, 1)
            
            }   =>> exit
        
        <=main
    }
    
    func testFunctorIdentityLaw() {
    
        let ioTen = io(10)
        
        let main: IO<Main> =
        
            fmap(id)(ioTen) =>> { x in
            id(ioTen)       =>> { y in
            
                io <-- XCTAssertEqual(x, y)
                
            } }             =>> exit
        
        <=main
    }
    
    func testFunctorCompositionLaw() {
    
        let ioTen = io(10)
        let f: Int -> Bool = { $0 == 10 }
        let g: Bool -> String = { $0 ? "true" : "false" }
        
        let main: IO<Main> =
        
            fmap(g .<< f)(ioTen)            =>> { x in
            (fmap(g) .<< fmap(f))(ioTen)    =>> { y in
            
                io <-- XCTAssertEqual(x, y)
                
            } }                             =>> exit
        
        <=main
    }
    
    func testApplicativeIdentityLaw() {
    
        let ioTen = io(10)
        
        let main: IO<Main> =
        
            io(id) <*> (ioTen)  =>> { x in
            ioTen               =>> { y in
            
                io <-- XCTAssertEqual(x, y)
                
            } }                 =>> exit
        
        <=main
    }
    
    func testApplicativeCompositionLaw() {
        
        let ioTen = io(10)
        let ioF: IO<Int -> Bool> = io { $0 == 10 }
        let ioG: IO<Bool -> String> = io { $0 ? "true" : "false" }
        
        let h: (Bool -> String) -> (Int -> Bool) -> (Int -> String) = { g in return { f in g .<< f } }
        
        let main: IO<Main> =
            io(h) <*> ioG <*> ioF <*> ioTen =>> { x in
            ioG <*> (ioF <*> ioTen)         =>> { y in
                
                io <-- XCTAssertEqual(x, y)
                
            } }                             =>> exit
        
        <=main
        
    }
}