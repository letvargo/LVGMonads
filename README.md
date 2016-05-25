# LVGMonads

[![CI Status](http://img.shields.io/travis/letvargo/LVGMonads.svg?style=flat)](https://travis-ci.org/letvargo/LVGMonads)
[![Version](https://img.shields.io/cocoapods/v/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)
[![License](https://img.shields.io/cocoapods/l/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)
[![Platform](https://img.shields.io/cocoapods/p/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)

Haskell-style Monads implemented in Swift.

## Overview

As a way to learn about Monads I've started implementing a few of them in Swift. The first is the 
IO Monad which is nearly complete. I hope to implement others over time. State, Writer and a version 
of Optional that works like `Maybe` are all in the works.

Each of the Monads will also define all of the Functor and Applicative typeclass operations. 

## Operators

Some (most) of Haskell's standard operators are already defined by the Swift standard library. 
For example `>>=` is the `bind` operator and `>>` is the `sequence` operator. Swift already 
defines both of those for use in bit-shifting operations. To avoid conflicts with the standard 
library, I've had to use operators that don't match up with the standard Haskell version. 
This is unfortunate, mainly because nobody likes to have to learn a whole new set of operators,
but that is how it is.

Here is how they translate:

```
Haskell       LVGMonads     Name          Definition
--------------------------------------------------------------------------------------------
<$>           <^>           fmap          (<^>) :: Functor f => (a -> b) -> f a -> f b
<*>           <*>           apply         (<*>) :: Applicative f => f (a -> b) -> f a -> f b
>>=           =>>           bind          (=>>) :: Monad m => m a -> (a -> m b) -> m b
>>            ->>           sequence      (->>) :: Monad m => m a -> m b -> m b
```

There's another set of operators that aren't specific to the type class fucntions, but are 
used by the library for function composition and application:

```
Haskell       LVGMonads     Definition
---------------------------------------------------------------------
.             .<<           (.<<) :: (b -> c) -> (a -> b) -> (a -> c)
N/A           .>>           (.>>) :: (a -> b) -> (b -> c) -> (a -> c)
$             <--           (<--) :: (a -> b) -> a -> b
N/A           -->           (->>) :: a -> (a -> b) -> b
```

`.<<` and `.>>` are right-to-left function composition and left-to-right function composition,
respectively. `<--` and `-->` are right-to-left function application and left-to-right
function application, respectively.

Additional operators may be defined for each specific Monad, but the ones above are used in
all of them.

## The IO Monad

The IO Monad represents an action that produces a side effect. It is a way of representing 
user input, UI updates, reading and writing to files, etc. It either receives data from the 
outside world or it alters the world in some (hopefully) meaningful way.

There are two main ideas from Haskell that I tried to implement: 1) IO actions are not executed
when they are defined - execution is delayed until they are called by a parent IO function;
and 2) It should not be possible to execute an IO action anywhere you want - there should
be a parent-of-all-parent IO actions that calls all the others. The first was idea was easy to 
implement - take the action and wrap it in a closure that can be executed later (examples will 
follow). The second was a little more difficult.

In Haskell there is only one IO function that can ever be called - the `main` function. `main`
starts the program and every other function in the program that returns an IO type has to be
called by `main`, and `main` itself is a function that always returns `IO ()`. In Haskell these
rules are enforced by the language which has no mechanism for calling any IO function other
than `main` (please correct me if I am wrong about this - I have a lot to learn about Haskell).

## Installation

Once at least one Monad (IO is going to be first) is ready for release it will be available 
on CocoaPods. For now, if you want to fool around with it the best thing to do is to clone 
the repository and include the source files in your project. They are small.

## Requirements

- OS X 10.10 or later
- iOS 8.0 or later

## Author

letvargo, letvargo@gmail.com

## License

LVGMonads is available under the MIT license. See the LICENSE file for more info.
