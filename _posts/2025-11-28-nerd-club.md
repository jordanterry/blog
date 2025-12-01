---
title: "Nerd Club"
date: '2025-11-28T00:08:00+00:00'
author: Jordan Terry
layout: post
permalink: /nerd-club
excerpt: |
    Nerd Club reads designing data intensive applications. 
categories:
  - Software

---

I spend a lot of time working with technology that I don’t understand. They are black boxes to me; I write code, it does what I want it to do. Great! 

Let’s use SQLite as an example: I can write SQL, and I understand that indexes are efficient because they are B-trees. But I certainly do not understand how the query engine converts my SQL to an algorithm, nor do I understand how a B-tree is serialised to disk. I do have a rough mental model, though. Even if I did learn how B-tree storage worked, I still wouldn’t know how memory really works on disk; a black box remains. 

The fun of my job is to reduce those black boxes. But I have to choose where to do that. Will learning how flash memory works in conjunction with SQLite be the best use of my time? No. 

The biggest black box I have right now is the backend at work! I know roughly what happens: I send a network request, it gets routed to a computer in our fleet, data is hydrated (we fan out?), it reads data from memcache, and we map data to JSON. Oh, hang on, I don’t have a clue how that works. I have a rough blurry mental model, in fact, its a blackbox. I don’t have a clue how the backend works! 

Working on reducing the black box of the backend and the systems that run it makes me more effective at work. 

Whilst pondering how on earth I was going to tackle this in short succession, two of my colleagues mentioned the book www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable/dp/1449373321) written by [Martin Kleppmann](https://martin.kleppmann.com/). Someone even had it on their desk! 

I vaguely knew of this book, and browsing through it I realised this book contained a literal map to understanding a lot of the black box that was the « backend »! 

One button click on Amazon and two days of waiting later I was the proud owner of the first edition! I now carry it around the office doing what I call « Performative Software Engineering ». I find it makes me look far more intelligent than I am!

A few days later, we have a small group of us assembled. We’ve read the first two chapters now and it has been exciting! Our general pattern has been to read for a week or two, and then get together in a meeting room and talk about what we’ve learned. In the space of a few hours of talking I’ve had so many questions answered, and found that I know more than I thought and can engage on topics of systems at scale! 

### Chapter One

Day to day, I work on Etsy search. The first paragraph of the book neatly summarises the domain we work on: 

> Many applications today are data-intensive, as opposed to compute-intensive. Raw CPU power is rarely a limiting factor for these applications - bigger problems are usually the amount of data, the complexity of data, and the speed at which it is changing. 

A big chunk of our work is actually moving data around and analysing it. One colleague has been working on analysing consecutive sales, yes, algorithms do show up in your day-to-day work ([leetcode](https://leetcode.com/problems/longest-consecutive-sequence/description/))!

We do a lot of work analysing data and moving it from one place to another. Imagine analysing listings on sale and finding consecutive sales! This is data-intensive work, we have never discussed if we will overload CPUs.This paragraph (yes, the first in the book!) has opened my eyes to a new approach to thinking about what the blackbox of a backend does. This doesn’t change *how* I do my work, my job has always been about marshalling data from one place to another. But it has made it explicit. 

The first chapter introduces four terms: 

* **Faults** - Something that can go wrong in your application. These are split neatly into Hardware, Software, and Human errors. I’m a few chapters ahead « Fault » is a consistently used word throughout the book. 
* **Reliability** - This is how your application handles *faults*, regardless of type. Unreliable software impacts money, trust and reputation. Reliability isn’t only for Nuclear Power Stations.
* **Scalability** - How does your program handle growth in load? The case study is how Twitter manages accounts with varying numbers of followers Tweeting. It’s not straightforward! We also learn how to quantify Load, perfect for Observability!
* **Maintainability** - This introduces more terms: Operability, Simplicity and Evolvability. All descriptors of how to make operations run smoothly and make it easy for new devs to onboard and improve a system. 

These are such simple terms, but already they have made their way into our day-to-day conversations. At first, this would evoke reactions of « ha! That’s from the book ». But we’ve realised these terms bring consistency and definitions to our conversations. It actually roots our conversations in a shared vocabulary that we all understand. 

Not only that, but we’ve applied these to what Etsy does. For example, how does clearing up data we’ve saved to a cache for an experiment fit into Maintainability? Our documentation and processes are now improving as we know our observability must be better for the Reliability of our systems! 


### Start a book club

I’ll leave with this: start a book club. Every one of your colleagues can help you learn by providing diffierent pieces of knowledge or points of view. You will leave every book club better off for it. 

We’ve also named our book club Nerd Club, because frankly who else is reading O’Reilly books? 

