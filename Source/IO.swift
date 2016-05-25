//
//  IO.swift
//  Pods
//
//  Created by doof nugget on 5/24/16.
//
//

/**
 A type for representing input/output operations.
 */
public struct IO<T> {
    
    private let action: () -> T
    
    /// Initialize an IO object with a closure that performs a side-effect.
    public init(_ action: () -> T) {
        self.action = action
    }
}

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