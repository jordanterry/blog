---
id: 198
title: 'Experimenting in a legacy code base'
date: '2021-04-07T22:10:20+00:00'
author: jordan_terry
layout: post
guid: 'http://jordanterry.co.uk/?p=198'
permalink: /experimenting-in-a-legacy-code-base
categories:
    - Coding
---

I work on what could be called a “legacy code base”. We’ve just crossed the 10 year anniversary of the first commit. Between then and now over 40 developers have contributed. Many features have come and gone, and the platform we develop for has changed beyond recognition and so have our ways of writing code.

Because of these reasons, we have a vibrant, frustrating, yet interesting code base. Over the past three or so years we have systematically refactored and improved it, but we have a lot further to go. We’re in a place where we can start to think about adopting new technologies to modernise our code base.

Using the newest technologies available to us has a lot of benefits the biggest for me is that developers get the satisfaction of using the newest and greatest tools.

But before we can adopt new technologies we have to make sure that developers have a shared understanding of how to use the new technologies and what we want to achieve by adopting it.

The best way to do this is to experiment.

When we experiment with code we learn new ways to write code, and more often than not, we learn why our previous ways writing code aren’t as good as we thought!

Legacy code bases come with a cost. You are surrounded with code full of history and reasons why you just can’t change it, and often there aren’t a lot of tests to make you feel safe! To make matters worse, you can’t just add a new technology for the sake of it – that’s the kind of thing that gives you a legacy code base in the first place. This combination makes experimenting a tricky thing in legacy code bases.

So how do we experiement in a legacy code base? Here are some ideas that I have been trying to adopt over the last six months:

Create disposable or small applications to demo your ideas. You aren’t constrained by your legacy code base and you can move quicker. Don’t forget that you will ultimately be integrating into a larger code base. If you can reuse these applications it is even better, keep them stored in a separate repository so you can use code reviews to explain your experiments to colleagues.

Create a “bleeding edge” application (better name pending), this is an app that can be used to incubate new technology before folding it into your main code base. Think Google Inbox and Google Gmail. If you can roll these changes out to users you get a better idea of what works and what doesn’t.

Design your code base with small modules and strong boundaries defined by abstract types. You can peacefully change your implementations of one module without impacting the rest of your application.

Each of the above options are just different ways of saying that you need to find somewhere outside, or inside, of your code base that allows your to make changes without those reprecussions being felt elsewhere.

When you’ve finished experimenting, you will know how best to propagate your changes safely into the rest of the code base without creating more legacy code.