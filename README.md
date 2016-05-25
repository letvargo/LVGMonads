# LVGUtilities

[![CI Status](http://img.shields.io/travis/letvargo/LVGMonads.svg?style=flat)](https://travis-ci.org/letvargo/LVGMonads)
[![Version](https://img.shields.io/cocoapods/v/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)
[![License](https://img.shields.io/cocoapods/l/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)
[![Platform](https://img.shields.io/cocoapods/p/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)

Haskell-style Monads implemented in Swift.

## Overview

As a way to learn about Monads I've started implementing a few of them in Swift. The first is the 
IO Monad which is nearly complete. I hope to implement others over time. State, Writer and version 
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

## Installation

Once at least one Monad (IO is going to be first) is ready for release it will be available on CocoaPods. For now, if you want to fool around with it the best thing to do is to clone the repository and include the source files in your project. They are small.

## Requirements

- OS X 10.10 or later
- iOS 8.0 or later

## Author

letvargo, letvargo@gmail.com

## License

LVGMonads is available under the MIT license. See the LICENSE file for more info.
