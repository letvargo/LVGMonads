# LVGMonads

[![CI Status](http://img.shields.io/travis/letvargo/LVGMonads.svg?style=flat)](https://travis-ci.org/letvargo/LVGMonads)
[![Version](https://img.shields.io/cocoapods/v/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)
[![License](https://img.shields.io/cocoapods/l/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)
[![Platform](https://img.shields.io/cocoapods/p/LVGMonads.svg?style=flat)](http://cocoapods.org/pods/LVGMonads)

Haskell-style Monads implemented in Swift.

## Overview

As a way to learn about Monads I've started implementing a few of them in Swift. The first is the 
IO Monad which is nearly complete. I hope to implement others over time. State, Writer and a version 
of Maybe (essentially `Optional`) are all in the back of my mind.

Each of the Monads will also define all of the Functor and Applicative typeclass operations.

## Let Me Explain Monads to You Like No One Before

Just kidding. I am coming to love Monads, and category theory, and functional programming, but
I am not the one to explain them. Writing my own versions of these Monads has helped me understand
a lot, but I know enough to know that what I know is somewhat superficial. In lieu of my own version
of the [Monads-are-burritos tutorial](https://byorgey.wordpress.com/2009/01/12/abstraction-intuition-and-the-monad-tutorial-fallacy/)
I will just share some links to resources that have helped me.

- Everything ever written by [Bartosz Milewski](https://bartoszmilewski.com/).
 - Especially his series on Monads which [starts here](https://bartoszmilewski.com/2011/01/09/monads-for-the-curious-programmer-part-1/) and this [series on category theory](https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/).
- HaskellWiki's [Monad page](https://wiki.haskell.org/Monad).
- Conal Elliott's paper [Denotational design with type class morphisms](http://conal.net/papers/type-class-morphisms/type-class-morphisms-long.pdf).
- [Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html#monads).
- [What is a monad?](http://stackoverflow.com/questions/44965/what-is-a-monad) on StackOverflow.
- The Wikipedia page on [Monads in Functional Programming](https://en.wikipedia.org/wiki/Monad_(functional_programming)).
- The Wikipedia page on [Monads in Category Theory](https://en.wikipedia.org/wiki/Monad_(category_theory)).

Have something you think should be included? [Create an issue](https://github.com/letvargo/LVGMonads/issues/new) with a link and I'll take a look at it.

Honestly, these ideas about Monads, category theory and the like only started to come together for
me when I started writing my own versions of them. What do Lists, self-logging Writer functions, 
Maybe values, IO actions, and State transformations all have in common? They all seem so
different. But they all share a common mathematical foundation, one that is just beginning to
come into focus for me.

## Operators

Some (most) of Haskell's standard operators are already defined by the Swift standard library
but for other purposes. In Haskell, for example, `>>=` is the `bind` operator and `>>` is the 
`sequence` operator. Swift already  defines both of those for use in bit-shifting operations. 
To avoid conflicts with the standard library, I've had to use operators that don't match up with the 
standard Haskell version. This is unfortunate, mainly because nobody likes to have to learn a whole 
new set of operators, but it is what it is.

Here is how they translate:

```
Haskell       LVGMonads     Name          Definition
--------------------------------------------------------------------------------------------
<$>           <^>           fmap          (<^>) :: Functor f => (a -> b) -> f a -> f b
<*>           <*>           apply         (<*>) :: Applicative f => f (a -> b) -> f a -> f b
>>=           =>>           bind          (=>>) :: Monad m => m a -> (a -> m b) -> m b
>>            ->>           sequence      (->>) :: Monad m => m a -> m b -> m b
```

There's another set of operators that aren't specific to the type class functions, but are 
used by the library for function composition and application:

```
Haskell       LVGMonads     Definition
---------------------------------------------------------------------
.             .<<           (.<<) :: (b -> c) -> (a -> b) -> (a -> c)
N/A           .>>           (.>>) :: (a -> b) -> (b -> c) -> (a -> c)
$             <--           (<--) :: (a -> b) -> a -> b
N/A           -->           (-->) :: a -> (a -> b) -> b
```

`.<<` and `.>>` are right-to-left function composition and left-to-right function composition,
respectively. `<--` and `-->` are right-to-left function application and left-to-right
function application, respectively.

Accuse me of OCD if you want, but I made all of these 3 characters long because Xcode indents
internal blocks of code 4 spaces. That means if you start a new line with one of these
operators followed by a space followed by the expression, you're code will all naturally
line up. 

```
    aitch
    .<< gee
    .<< eff
    <-- ex    // evaluates to aitch(gee(eff(ex)))
```

Some of these operators could have been shorter, but then the spacing would be off and the
world would end. There is a madness to my method.

Additional operators may be defined for each specific Monad, but the ones above are used in
all of them.

## The IO Monad

### Introduction

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

There is no way to enforce such a rule in Swift. I came up with a hack that makes you go out of
your way to execute an IO action - I made it so that there is only one type of IO action that
can be executed: `IO<Main>`. `Main` itself is just a dummy type:

```
public struct Main { public init() { } }
```

So the Swift equivalent of Haskell's `main:: IO ()` is `let main: IO<Main>`. Of course unlike
in Haskell you can put an `IO<Main>` action anywhere in your Swift code and execute it if you 
want to. In a way, each little `IO<Main>` action becomes a functionally pure program unto itself,
which is kind of cool. After all, people are unlikely to start rewriting entire iPhone
applications as a single `IO<Main>` action. But they may find places here and there where the
Monadic structure of the IO type makes sense. The compositional nature of these Monadic structures
make it possible to start very small and grow, naturally, into something very big.

### Creating an IO action

The IO type is quite simple. This is all of it:

```
public struct IO<A> {
    
    /// The IO action to perform.
    let action: () -> A
    
    /// Initialize an IO object with a closure that contains an IO action.
    public init(_ action: () -> A) {
        self.action = action
    }
}
```

You can think of IO actions (oversimplification alert) as falling into one of two categories - 
read actions and write actions. An example of a read action might be getting a line of 
input from standard input. In Swift you use the `readLine()` function to do that, which returns 
a `String?`. We can turn it into an IO action like this (and we'll keep things simple for now 
by forcing it to return a non-optional `String`):

```
let ioReadLine: IO<String> = IO { readLine()! }
```

Now let's create a write operation. We'll use `print` as our example, which writes any
value you give it to standard output.

```
let ioPrint: String -> IO<()> = { s in IO { print(s) } }
```

Standing alone there is no way to execute either of these functions. Only IO actions of type `IO<Main>` can be
executed, remember? So how do we call them? Like this:

```
// This defines our main function:
let main: IO<Main> = ioReadLine =>> ioPrint =>> exit
```

What's happening here? The short version is that `ioReadline` grabs a `String` from
standard input. That value is fed into `ioPrint`. `ioPrint` returns an `IO<()>` action which, 
when executed, returns a `()`. That `()` is fed into `exit` which is a special function
available everywhere of type `() -> IO<Main>`. So when `exit` gets the `()` input from
`ioPrint`, it returns `IO<Main>`.

But none of that happens right away. All we've done so far is compose a couple of IO
actions into a single IO action and called it `main`. Nothing happens until we execute
`main`, which we can do using the handy `<=` prefix operator:

```
// Execute the main function:
<=main
```

Only when `main` is executed do the other actions get executed, in the order in which
they have been combined.

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
