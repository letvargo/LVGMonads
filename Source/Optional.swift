//
//  Maybe.swift
//  Pods
//
//  Created by doof nugget on 5/29/16.
//
//

// MARK: The Maybe Functor functions

/**
 The fmap function for `Optional`s.]
 
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
 The fmap function for IO objects.
 
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