---
title: "Hot TAIke Two: TDD is back, baby"
date: '2026-02-01T00:00:00+00:00'
author: Jordan Terry
layout: post
permalink: /tdd-is-back-baby
excerpt: |
    Test Driven Development gets a bad rap. But in a world of AI coding assistants, it might be exactly what we need.
categories:
  - Software
---

Test Driven Development gets a bad rap. I don't understand why; you derive your tests from your functional requirements, and thanks to Continuous Integration those tests then run on every push, merge, and release of your code. Sounds great to me.

I once worked at a really, really, really boring software development job. It was so boring that I started reading the books I thought were boring at university. Except this time I had to buy them, rather than take them out of the library. Namely [Working Effectively with Legacy Code](https://www.goodreads.com/book/show/44919.Working_Effectively_with_Legacy_Code), [Test-Driven Development](https://www.goodreads.com/book/show/6408726), and [Extreme Programming Explained](https://www.goodreads.com/book/show/67833.Extreme_Programming_Explained). They left an impression on me. That boring job became a lot less boring once I started applying what I'd read. These books gave me a framework for thinking about, and addressing Software Engineering. 

These books are a well of great quotes that I come back to regularly.

On the definition of Legacy Code:

> To me, legacy code is simply code without tests.

And a couple of bangers from Kent Beck:

> I'm not a great programmer; I'm just a good programmer with great habits.

And:

> Test-driven development is a way of managing fear during programming.

Over time I was lucky enough to have these mantras drilled into me by working with some great mentors.

But I often despair that the fine art of validating your work before you even write it is dying off. So imagine my delight when I read that TDD is in the [Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices) documentation.

The concept of Continuous Delivery was created in order to continuously validate your code. Without tests, we lose confidence in the code we write. This is even more crucial in a world of Claude Code, where we should by default distrust the code that is written.

So what if we turn the current way of working on its head? If our intention is to deliver projects for our users, can we turn our roles into a job of writing tests? A harness that allows us to validate the work done by our untrustworthy friend, Claude.

I think test libraries are some of the most creative spaces in software development. They give us room to experiment with new patterns, explore edge cases, and stress-test our assumptions. In a future where Claude writes the production code, this becomes *our* playground. The place where we flex our craft and define what "correct" actually means.
