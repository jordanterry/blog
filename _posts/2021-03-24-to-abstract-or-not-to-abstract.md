---
id: 195
title: 'To abstract or not to abstract'
date: '2021-03-24T08:53:59+00:00'
author: jordan_terry
layout: post
guid: 'http://jordanterry.co.uk/?p=195'
permalink: /to-abstract-or-not-to-abstract
categories:
    - Coding
---

The longer I’ve written software the more I debate with myself about whether I should be adding an abstraction or not adding an abstraction.

  
Let us define an abstraction, it could be an interface, a trait, a protocol, or an abstract class. It is a structure that defines how a piece of code should interact with the outside. But not how that interaction is handled.

  
Abstractions are a powerful tool, but they should be used appropriately. They are powerful at the boundaries of your code but introduce too much indirection when used overzealously.

  
A good abstraction lets a developer switch out an implementation without any effort. A bad abstraction finds a developer clicking through many files trying to a lot of information in their head.

  
I have a few rules of thumb that I try to follow:

1. An abstraction is useful when there is a genuine reason to swap out the implementation.

1. If you are at a boundary of a key separation of concern use an interface to define that boundary.

1. If you are designing a library use an abstraction to define a public API that can be added to or sensibly deprecated

1. If you know your class isn’t going to be swapped out don’t use an abstraction

These are not a definitive set of rules but I find they rein me in from creating an abstraction for everything under the sun!