---
id: 156
title: 'Some thoughts on testing'
date: '2020-07-11T08:31:18+00:00'
author: jordan_terry
layout: post
guid: 'http://jordanterry.co.uk/?p=156'
permalink: /some-thoughts-on-testing
background: "/wp-content/uploads/2020/07/oguzhan-akdogan-qYMkkREOHa4-unsplash-1024x768.webp"
categories:
    - Coding
---

The first is finding peace of mind. In years gone by I have written some dodgy code that has gone to production, I still think about some of this code to this day. I still write dodgy code, but I’m able to stop it from going to production with a superpower I have gained. That superpower is to write tests for my code and mostly stop that code from being released (crashlytics will sometimes disagree). A good set of tests should be enough to give me confidence that what I have written actually works.

Testing is the quickest way to validate your code. As an app developer running a suite of tests from your IDE, in a matter of seconds, is far quicker than navigating to the relevant screen in your app and then doing a sequence of actions to find out your code doesn’t work!

The code you write to test code is a good indicator of the complexity of the code you have written; large test functions, repeated test code or long lists of dependencies all indicate that your test code is a bit complex. I *try* to let this guide me when I am writing code.

I’m not going to tell you I know how to write proper tests, because I don’t and have a long way to go before I start to write good tests. However, over the past few years I’ve started to pick up a few things and form some – hopefully useful – opinions.

## Concise test naming

Don’t be too descriptive, get to the point quickly, and make sure the name matches what is in the body of the test. You and a colleague will need: to review this code or refer back to tests in the future. Make your tests easy to understand now and avoid regret in the future.

I like to imagine non-technical colleagues might want to read a report on test coverage and then share it to other teams. If you think your tests are easy to understand you are going in the right direction. If you aren’t sure, why not ask someone else?

I think testing code with a small public API helps keep your test names concise. The more API you have to test, the more words you need to describe what you are testing. If you really can’t avoid a large public API, split your tests into a number of different files focusing on a particular method or function of that API to help reduce potential confusion.

## Consistent structure for tests

If you are working on code in the same project you will want to see consistency across in the code that is written. If every test has a familiar structure your or a colleague won’t have to spend time getting up to speed with the general shape of the code, you can just get on with the testing.

I think this fits nicely alongside the idea that your test code will inform you of the complexity of the code you are testing; if your tests are consistently different or hard to understand you should probably change the code you have written.

## White box or black box?

For the longest time I was an advocate for [white box](https://en.wikipedia.org/wiki/White-box_testing) testing; I wanted to know that my tests rigorously tested internals of the code I have written, this is great for my peace of mind. However, changing the tiniest implementation detail would cause a butterfly effect of failing tests through the entire test code base. This is alarming and stressful for whoever is making a change, not a good developer experience! This has led me to becoming a fan of [black box ](https://en.wikipedia.org/wiki/Black-box_testing)testing.

I do think white box testing is helpful, I think it is a great way to help understand difficult to understand code. Writing tests verifying the behaviour of different parts of this code can help you to understand what is happening. I like to think of it as writing notes “this function does this.. And causes this to happen..” the best thing is those notes will tell you if you are right or wrong as soon as you execute them!

Nowadays, I like to just test and output for a given set of inputs. It is a much nicer developer experience and your test code is less intimidating to look at. I also think it has helped to inform how I write code. I try to ensure any function returns something that can easily be used in a test and ensure there are no hidden side effects.

The three points above are things I regularly think of when I write tests. They certainly aren’t a recipe for cooking up the perfect tests but they do help me write better tests bit by bit.