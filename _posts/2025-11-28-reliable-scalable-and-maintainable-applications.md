---
title: "Reliable, Scalable and Maintainable Applications"
date: '2025-11-28T00:08:00+00:00'
author: Jordan Terry
layout: post
permalink: /reliable-scalable-and-maintainble-applications
excerpt: |
    Chapter One of Designing Data-Intensive Applications.
categories:
  - Software

---

I’ve started a book club at work. A couple of my colleagues have mentioned [Designing Data-Intensive Applications](https://www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable/dp/1449373321), one even has it on their desk. I was also interested, but we all needed a forcing function to make us read it! Thus, the « Designing Data Intensive Applications book club » was born, since rebranded to « Nerd Club ». 

Now I have the book, I perform "performative Software Engineering" by openly reading it around the office. I find it makes me look far more intelligent than I am!

Day to day, we work on Etsy search. The first paragraph of the book neatly summarises the domain we work on: 

> Many applications today are data-intensive, as opposed to compute-intensive. Raw CPU power is rarely a limiting factor for these applications - bigger problems are usually the amount of data, the complexity of data, and the speed at which it is changing. 

We do a lot of work analysing data and moving it from one place to another. Imagine analysing listings on sale and finding consecutive sales! This is data-intensive work, we have never discussed if we will overload CPUs.This paragraph (yes, the first in the book!) has opened my eyes to a new approach to thinking about my work. This doesn’t change *how* I do my work, my job has always been about marshalling data from one place to another. But it has made it explicit. 

The first chapter introduces four terms: 

* **Faults** - Something that can go wrong in your application. These are split neatly into Hardware, Software, and Human errors. I’m a few chapters ahead « Fault » is a consistently used word throughout the book. 
* **Reliability** - This is how your application handles *faults*, regardless of type. Unreliable software impacts money, trust and reputation. Reliability isn’t only for Nuclear Power Stations.
* **Scalability** - How does your program handle growth in load? The case study is how Twitter manages accounts with varying numbers of followers Tweeting. It’s not straightforward! We also learn how to quantify Load, perfect for Observability!
* **Maintainability** - This introduces more terms: Operability, Simplicity and Evolvability. All descriptors of how to make operations run smoothly and make it easy for new devs to onboard and improve a system. 

This summary is brief, but chapter one is rich with useful tidbits. I learned a lot from it, I’m looking forward to writing up the following chapters in a lot more detail. 

Also, start a book club! Having an hour to chat to colleagues and learn from them is amazing. A book like this can also be related back to the projects you work on and the tools you use. 
