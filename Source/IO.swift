//
//  IO.swift
//  Pods
//
//  Created by doof nugget on 5/24/16.
//
//

// MARK: The IO struct

/**
 A type for representing input/output actions.
 */
public struct IO<A> {
    
    let action: () -> A
    
    /// Initialize an IO object with a closure that performs a side-effect.
    public init(_ action: () -> A) {
        self.action = action
    }
}

// MARK: The <= Operator Functions

prefix operator <= { }

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
prefix func <= <A> (io: IO<A>) -> A {
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

// MARK: The IO Functor functions

/**
 The fmap function for IO objects.
 
 This function is the equivalent of Haskell's `<$>` operator. `<$>` is
 not used because `$` is a forbidden charactor when defining custom operators.
 
 - parameter f: The function to be applied.
 - returns: A function of type `IO<A>` -> `IO<B>`.
 */

public func fmap<A, B>(f: A -> B) -> IO<A> -> IO<B> {
    return { ioa in IO { (f .<< ioa.action)() } }
}

/**
 The fmap function for IO objects.
 
 This function is the equivalent of Haskell's `<$>` operator. `<$>` is
 not used because `$` is a forbidden charactor when defining custom operators.
 
 - parameters:
   - f: The function to be applied.
   - ioa: An `IO<A>` object. The function will be applied to the output of
   this IO action to produce a new action of type `IO<B>`.
 - returns: A new IO action
 */

public func <^> <A, B> (f: A -> B, ioa: IO<A>) -> IO<B> {
    return fmap(f)(ioa)
}

// MARK: The IO Applicative functions

/**
 Apply a function wrapped an IO object.
 
 - parameter iof: An IO object of type `IO<A -> B>`.
 - returns: A function that takes an `IO<A>` object and returns an 
 `IO<B>` object.
 */

public func apply<A, B>(iof: IO<A -> B>) -> IO<A> -> IO<B> {
    return { ioa in IO { <=fmap(<=iof)(ioa) } }
}

/**
 Apply a function wrapped an IO object to an IO object.
 
 - parameters: 
   - iof: An IO object of type `IO<A -> B>`.
   - ioa: An object of type `IO<A>`. The nested `iof` function will be applied
   to the output of this IO action.
 - returns: A function that takes an `IO<A>` object and returns an
 `IO<B>` object.
 */

public func <*> <A, B>(iof: IO<A -> B>, ioa: IO<A>) -> IO<B> {
    return apply(iof)(ioa)
}

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
 Flatten a nested IO object one level.
 
 This function is the equivalent of `join` in the Monad typeclass. It 
 takes an object of type `IO<IO<T>> and returns the internal IO object.
 
 - parameter value: The IO object that is to be flattened.
 - returns: The nested `IO<T>` object.
 */

public func join<T>(io: IO<IO<T>>) -> IO<T> {
    return <=io
}

/**
 Chain two IO actions together, where the output of the first is
 the input of the second.
 
 - parameter ioa: An `IO<A>` object.
 - returns: A new function that takes a function of type `A -> IO<B>` and
 returns a new IO action of type `IO<B>`.
 */

public func bind<A, B>(ioa: IO<A>) -> (A -> IO<B>) -> IO<B> {
    return { f in IO { <=(f .<< ioa.action)() } }
}

/**
 Chain two IO actions together, where the output of the first is 
 the input of the second.

 This function is the equivalent of `bind` in the Monad typeclass. The output
 of the left-hand IO action is fed into the function on the right-hand side and
 a new IO action is returned.
 
 `>>=`, the standard Haskell `bind` operator, is not used because `>>=` is
 already defined by the Swift standard library.
 
 - parameters:
   - ioa: An `IO<A>` object.
   - f: A function of type `A -> IO<B>`.
 - returns: A new IO action of type `IO<B>` that executes the two actions
 in succession.
 */

public func =>> <A, B> (ioa: IO<A>, f: A -> IO<B>) -> IO<B> {
    return bind(ioa)(f)
}

/**
 Chain two IO actions together, ignoring the output of the first.
 
 This function is the equivalent of Haskell's `>>` operator. The output of
 the left-hand IO action is ignored.
 
 The standard Haskell `>>` operator is not used because `>>` is already 
 defined by the Swift standard library.
 
 - parameters:
   - ioa: The first IO action to execute.
   - iob: The second IO action to execute.
 - returns: A new IO action of type `IO<B>` that executes the two actions 
 in succession.
 */

public func ->> <A, B> (ioa: IO<A>, iob: IO<B>) -> IO<B> {
    return ioa =>> { _ in iob }
}