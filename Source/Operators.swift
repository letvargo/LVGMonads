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