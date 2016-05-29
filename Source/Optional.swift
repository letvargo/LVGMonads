//
//  Optional.swift
//  Pods
//
//  Created by doof nugget on 5/29/16.
//
//

/**
 Lift any value into an `Optional`.
 
 This is the equivalent of `pure` in the Applicative typeclass and
 `return` in the Monad typeclass, and of `unit` generally.
 
 - parameter value: The value to be lifted.
 - returns: The value, wrapped in an `Optional`.
 */
public func opt<A>(value: A) -> A? {
    return .Some(value)
}

// MARK: The Maybe Functor functions

/**
 The fmap function for `Optional`s.
 
 - parameter f: The function to be applied.
 - returns: A function of type `A? -> B?`.
 */

public func fmap<A, B>(f: A -> B) -> A? -> B? {
    return { a in
        guard let a = a else { return nil }
        return f(a)
    }
}

/**
 The fmap operator for `Optional`s.
 
 This function is the equivalent of Haskell's `<$>` operator. `<$>` is
 not used because `$` is a forbidden charactor when defining custom operators.
 
 - parameters:
 - f: The function to be applied.
 - ioa: An `Optional<A>` object. The function will be applied to the output of
 this `Optional` to produce a new `Optional` of type `Optional<B>`.
 - returns: An object of type `Optional<B>`.
 */

public func <^> <A, B> (f: A -> B, a: A?) -> B? {
    return fmap(f)(a)
}

// MARK: The Optional Applicative functions

/**
 Apply a function wrapped in an `Optional` to an `Optional`.
 
 - parameter optf: An `Optional` function of type `(A -> B)?`.
 - returns: A function that takes an `A?` and returns a `B?`.
 */

public func apply<A, B>(optf: (A -> B)?) -> A? -> B? {
    return { opta in
        guard let f = optf, let a = opta else { return nil }
        return f(a)
    }
}

/**
 Apply a function wrapped an `Optional` to an `Optional`.
 
 - parameters:
 - optf: An `Optional` function of type `(A -> B)?`.
 - opta: An object of type `A?`. The nested `optf` function will be applied
 to the value, if there is one, otherwise it will return `nil`.
 - returns: A new `Optional`, `B?`.
 */

public func <*> <A, B>(optf: (A -> B)?, opta: A?) -> B? {
    return apply(optf)(opta)
}