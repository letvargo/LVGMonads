//
//  Operators.swift
//  Pods
//
//  Created by doof nugget on 5/24/16.
//
//

// The bind operator for Monads.
infix operator =>> { associativity left precedence 150 }

// The continuation operator for Monads.
infix operator ->> { associativity left precedence 150 }

// The fmap operator for Functors.
infix operator <^> { associativity left precedence 150 }

// The apply operator for Applicative Functors.
infix operator <*> { associativity left precedence 150 }

// Left-to-right function composition.
infix operator .>> { associativity left precedence 200 }

/** 
 Left-to-right point-free function composition.

 parameters:
   - f: A function of type `T -> U`.
   - g: A function of type `U -> V`.
 returns: A new function of type `T -> U`.
 */
public func .>> <T, U, V> (f: T -> U, g: U -> V) -> T -> V {
    return { t in g(f(t)) }
}

// Right-to-left function composition.
infix operator .<< { associativity right precedence 200 }

/**
 Right-to-left point-free function composition.
 
 parameters:
 - g: A function of type `U -> V`.
 - f: A function of type `T -> U`.
 returns: A new function of type `T -> U`.
 */
public func .<< <T, U, V> (g: U -> V, f: T -> U) -> T -> V {
    return { t in g(f(t)) }
}

// Left-to-right function application.
infix operator --> { associativity left precedence 50 }

/**
 Left-to-right function application.
 
 parameters:
   - x: The function parameter.
   - f: The function to apply.
 returns: `f(x)`.
 */
public func --> <T, U> (x: T, f: T -> U) -> U {
    return f(x)
}

// Left-to-right function application.
infix operator <-- { associativity right precedence 50 }

/**
 Right-to-left function application.
 
 parameters:
   - f: The function to apply.
   - x: The function parameter.
 returns: `f(x)`.
 */
public func <-- <T, U> (f: T -> U, x: T) -> U {
    return f(x)
}