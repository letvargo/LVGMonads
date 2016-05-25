//
//  IO.swift
//  Pods
//
//  Created by doof nugget on 5/24/16.
//
//

// MARK: Operator Definitions

prefix operator <= { }

// MARK: The IO struct

/**
 A type for representing input/output actions.
 */
public struct IO<T> {
    
    private let action: () -> T
    
    /// Initialize an IO object with a closure that performs a side-effect.
    public init(_ action: () -> T) {
        self.action = action
    }
}

// MARK: The <= Operator Functions

/**
 Execute the action stored in an `IO<Main>` object.
 
 - parameter io: The `IO<Main>` object to execute.
 - returns: A dummy `Main` object.
 */
public prefix func <= (io: IO<Main>) -> Main {
    return io.action()
}

/** 
 A private prefix function that represents the execution of an IO action.

 - parameter io: The IO action to execute.
 - returns: An object of type `T`.
 */
private prefix func <= <T> (io: IO<T>) -> T {
    return io.action()
}

// MARK: The Main struct

/**
 A dummy type used to define the top level of execution for an IO type.
 
 An `IO<Main>` object is executed using the `<=` prefix operator.
 */
public struct Main { public init() { } }

/**
 A function that returns an `IO<Main>` object.
 
 This function is used to signal the end of a chain of IO actions and end
 execution of the application's main IO function.
 */
public func exit() -> IO<Main> { return io(Main()) }

// MARK: The IO Monad functions

/** 
 Lift a value into an `IO` object.
 
 This function is the equivalent of `return` (also called `unit`) in 
 the Monad typeclass and `pure` in the Applicative typeclass.
 
 It takes a value of any type `T` and returns an `IO<T>`.
 
 - parameter value: The value that is to be lifted.
 - returns: The value wrapped in an `IO<T>` object.
 */

public func io<T>(value: T) -> IO<T> {
    return IO { _ in value }
}

/**
 Chain two IO actions together, executing them in succession.

 This function is the equivalent of `bind` in the Monad typeclass. The output
 of the left-hand IO action is fed into the function on the right-hand side and
 a new IO action is returned.
 
 `>>=`, the standard Haskell `bind` operator, is not used because `>>=` is
 already defined by the Swift standard library.
 
 - parameters:
   - ioa: An `IO<A>` object.
   - f: A function of type `A -> IO<B>`.
 - returns: A new IO action of type `IO<B>`.
 */

public func =>> <A, B> (ioa: IO<A>, f: A -> IO<B>) -> IO<B> {
    return IO { <=(f(<=ioa)) }
}