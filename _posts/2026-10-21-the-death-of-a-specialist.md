---
title: "The death of a specialist"
date: '2026-10-21T00:00:00+00:00'
author: Jordan Terry
layout: post
permalink: /the-death-of-aspecialist
categories:
  - Software
---

> This is my submission to the [How software engineering is changing: an essay challenge](https://blog.pragmaticengineer.com/how-software-engineering-is-changing-an-essay-challenge/) from the [Pragmatic Engineer](https://blog.pragmaticengineer.com/). Now the essay submission date has passed, I can post this online.

I’m most proud of myself when I produce something that I know is of a high standard. This applies to my work as a software developer, and almost anything else I do. Part of the satisfaction comes from finishing something. The greatest satisfaction comes from knowing why it is good. 

Being a software developer is fascinating. One job title covers a vast range of specialisms. I specialise in mobile development, but I might share a title with someone who builds distributed databases. We share some foundations in our skill set, but we have taken different paths and learned very different skills. 

Over time, our accumulated knowledge becomes something colleagues rely on. Colleagues come to us with questions because we understand a particular corner of our work. It feels good to be recognised as an expert, to test our hard-earned knowledge, and to pass it on. There is a feeling of responsibility to be correct when passing on knowledge. 

I fear that we software developers, and I assume the wider world of trained professionals, are sleepwalking into a future where we produce more while understanding less and less. 

To explain why I think this, I want to start with how I became a specialist. 

Many years ago, when I was a naive student considering my future. I wanted a career in Formula One. My Dad gave me some advice: choose something to specialise in. Be the guy who knows about the front wings on a Formula One car. 

Shortly after, my college maths and physics results gave me some advice of their own: no Formula One for you; it’s a career in computing instead. 

My Dad’s advice stuck with me over the years, though. I have spent a lot of time thinking about what it means to specialise in an industry as broad as ours. 

I started as a web developer before moving into Android development.  At the time, mobile developers were the rock stars. It seemed as though every app was receiving millions of dollars in funding. It looked like a great place to be, even if I had little idea which part would eventually interest me most. 

I like to think that what happened next was through osmosis. My interests in software changed through the interactions I had with developers I met and worked with. 

One of the most formative periods for me was working at Twitter. I worked alongside people that I had looked up to before I started working there and still look up to now. They were Android developers, but within that shared title they specialised in payment systems, user interfaces, platform engineering, video, concurrency and much, much more. 

Amongst many great discussions at Twitter one really stands out. During a discussion about push notifications and polling, someone asked how often we should ask the device’s radio to wake up. 

What? 

I had never even thought to ask that question. I was thinking about what to do with the data once we had access to it. Someone else was thinking about the impact polling would have on the health and battery of our users’ devices. It was a small moment, but it showed me how much expertise can change what you see in a problem. 

Over time, I fell in with the platform crowd. We’re the kind of people who talk about code generation. We talk about dependency graphs, Application Binary Interfaces. We talk about the merits of code generation, then nerd out about how code passes through the layers of compilation. It’s good stuff over here. I still made Android applications, but I became increasingly enamoured by the systems that made building them possible. 

Eventually, I began to recognise recurring structures across these interests: graphs. I think everything in software is a graph. Everything depends on something else in some form or another. Over time, I realised that understanding those connections and thinking about them gave me the knowledge to communicate with others. 

I've developed most of my understanding through writing technical documents. For each project, I generally document what I do in a technical document. Sometimes this is called an Architecture Decision Record (ADR), a Technical Design Document (TDD), or a Request for Comments (RFC). Putting an idea into words forced me to find the gaps in my own thinking. The best part? When a document goes out for review, others find the gaps in your thinking. 

Like moths to a light, specialists gather around these documents. “Why are you doing it like this?” “Did you know we already looked at this?” “Have you considered another approach?”

Having more experienced developers critique my work could be intimidating. But those questions were how we shared knowledge. Someone who has already struggled with a problem could help me understand it before I repeated the same mistake.

Links shared in the margins of a Google Doc led to other docs and other discussions that contain the history behind earlier decisions. I can see where people tried, disagreed, and debated; I can see where obvious solutions were rejected as inappropriate. 

Also, lets be real. If you’ve been around long enough, you know software engineers can be pretty blunt. Those discussions were not always comfortable. But they gave me ideas to examine and opinions to challenge. Over time, they helped me develop my own judgement. 

Another format that has helped me grow is pairing with another developer. 

Pairing provides us with the opportunity to see other developers in action. We find answers to questions we might not have thought to ask as we work on a project. 

How did a developer who is an expert come to the answer they give? How do they write code? What resources do they look at? What assumptions do they question as they tackle code? 

These habits are hard to capture in the margins of a document or in the code we refer to. They also don't capture the discarded ideas they don’t bring up in discussions. 

Working with a developer lets you access their thinking in real time. You can interrupt and say why when they do something. Sometimes, a simple and innocent question can prompt a more experienced developer to rethink their approach to a problem. 

Also, when you work with a passionate developer, you find that passion is infectious. I find that I can adopt a passion because someone else has spoken passionately to me about a topic. 

Passion isn’t the only infectious behaviour, but habits are too. I inherit the habits of others that I’ve seen work well. Recognising a warning sign because a colleague once helped me to understand it, for example. Eventually, I pass that learning on to another colleague.

Within my specialisms, I've focused on a few technical areas: build systems, dependency injection, type safety, and concurrency. 

These specialisms are where my colleagues seek me out. Often as a senior developer on a team, I feel responsible for passing on the knowledge I have gained from others. 

Specialisation has never stopped me from wanting to explore. Sometimes I get bored of solving familiar problems. This leads me to explore different areas of this broad domain we call a career. 

Some years ago, Google announced that Binder, a key concept for communicating between processes on Android, would be converted from C to Rust. This piqued my interest and led me on a journey into Rust. It is, after all, the cool kid on the block right now. I’ve learned a lot doing this, including a better understanding of pointers and their lifecycles, memory layout, and how data passes through a CPU. 

Asynchronous programming has been another recurring fascination, and a source of intimidation. I keep returning to how different languages and systems let work progress without everything waiting for everything else. This topic alone has led me on countless other side quests, like implementing an interpreter (it makes sense, honestly- look, you, Robert Nystrom\!). 

I call these my side quests. They take me beyond my main specialisation, but I actively try to bring my knowledge back to my day job of making mobile applications. 

These side quests do not make me a specialist in every subject I explore. 

I would not dream of applying tomorrow for a job writing embedded Rust to power MRI machines. Not a chance. I might understand some of the language, but I would have little understanding of the environment, the constraints or consequences of getting something wrong. I would be cosplaying as a specialist. 

I would be remiss, in an essay that will explore the impact of machines, to not mention that software development is fundamentally a human job. A colleague recently said to me that everyone is doing the same job: we come in, we read, we write and we go to meetings. The artifacts in between are just different for each of us. 

I strongly disagree when I see or hear developers say we are different because we need time to sit and focus on a problem. Is that suggesting that other professions don’t need that focus time? It has always left me confused. 

The developers who I have met that display the very human side of our roles are the ones I cherish interactions with the most. This always flourishes during the morbidly named post-mortem process. The intention of this ceremony is to candidly explore what might have gone wrong, and how to prevent a similar incident from happening again. The best companies I have worked at: Twitter, Marks & Spencer and now Etsy were experts in this process. 

Twitter operated at a scale I had never, and may never experience again, getting to scale for them meant that many, oh so many, incidents were had along the way. The company's searchable index was a treasure trove for learning from the mistakes of others. 

Marks & Spencer’s digital culture was expanding as I joined. With post-mortems being a key part of my platform's team culture. We grew a process of regularly capturing the issues we made, and growing from them. 

Etsy, similar to Twitter has existed for a long time. In my opinion, it’s one of the OG digital companies. Etsy has long, long been a beacon for blameless post mortems. For us, a post-mortem is a place for us to gather and solve problems so they do not occur again.

The post-mortem practice has taught me to be reflective of all that I do. I have a habit of producing a one pager post-mortem for even the smallest projects. The intention of this is for me to reflect, and share knowledge and this practise with less exeperienced developers than myself. 

The experiences I’ve outlined above have made me, I think, a better than average software developer. I can make connections, ask questions, and recognise when I need someone else’s expertise. I am becoming someone who can contribute interesting ideas to the discussions in the margins of technical documents and help others learn in the way I did before. 

Our industry is facing change, at a rapid pace. It isn’t just us; change is happening at a frightening pace across many industries. I am concerned, as I am sure many of us are. My concerns largely centre on humans, knowledge transfer, and our ability to feel satisfied with the work we produce. 

As I look around my immediate area and talk to friends and colleagues. I see two intertwined problems: the erosion of knowledge sharing and how easily we can now cosplay as specialists. 

Both are wonderful. We can type a question into a text box and receive an answer in seconds. We can explore unfamiliar subjects or get help with a problem; I use these tools myself, and I understand the appeal and desire for them. It is addictive.

What concerns me is how easily the answer can become the end of the thinking. A technical document can now appear from thin air, become a set of tickets and then become code. Yet somewhere in that process, we miss the conversations through which people would have understood and challenged the proposal. 

An LLM can help write a document, and my concern is whether the person presenting it understands the decisions well enough to defend them, and whether anyone else has had the chance to question them. 

Should we use JSON or Protocol, Buggers? Inheritance or composition? Would polling be reasonable here, despite the advantages of push? These discussions reveal assumptions and constraints we did not know about. They are how we learn from each other. 

Even when presented with the opportunity to read documents written by LLMs. I am hearing more and more that reviewers don’t do it. They are turned off by obvious LLM use.

“Jordan”, I hear you all saying, “the LLM has already read every variation of those discussions; let it make the decision for you”. 

Perhaps it has. But my colleagues and I still need to develop our own understanding of the decisions we need to take responsibility for. 

I recently joined an architecture review group at work. Our job is to help developers bring their technical documents and ideas to peers for review.

That requires more than having opinions about architecture. Sometimes we can offer relevant experience. Sometimes we know who else should be involved. Sometimes the most useful thing we can do is ask questions that haven't been considered. 

In recent months, I have noticed an imbalance. More code is being committed, and more pull requests are appearing, while fewer technical documents are being reviewed. More documentation is being written, but very little of it is being reviewed in the manner I remember fondly. 

I can’t attribute that whole change to LLMs. But I'm more sensitive to work that arrives with a proposed solution without being properly examined and discussed. 

That conversation is part of the work. It is also an opportunity for everyone involved in a decision to learn.  

When answers and code are so cheap to produce, it becomes easier to appear competent in an unfamiliar field. 

I have mixed feelings about this. Contributing outside our specialisms is a fantastic way to learn. I even mention this above. I have some experience with iOS, Flutter, web and backend development, and I could imagine contributing to these codebases at work. 

But I would want to talk to someone who understands them first. Preferably, I would pair with that person whilst we write and debug code. I would want help recognising assumptions I brought with me and conventions I hadn't learned yet. 

The same applies to Rust. I enjoy the language and appreciate the guarantees it provides. But successfully compiling a change alone wouldn't give me the confidence that I understood the system around it. I certainly don't buy the idea that code is just a compilation target for a written language. 

I believe an LLM makes it easier for me to attempt a change. It does not automatically tell me whether I am qualified to judge the result of a change. 

I am lucky; my current employer has taken a very cautious approach to adopting LLMs. We are on the slower side, and I believe we will continue adopting them in a reasonable manner.

I don't feel the same about the wider industry. I’ve heard stories of companies relinquishing control of their businesses to LLMs, or requiring you to talk to agents before you speak to a human. 

I’m concerned that the ease of producing something is obscuring how much help we really still need. 

Experienced developers must take responsibility in this situation. I cannot complain about others skipping opportunities to learn if I am unavailable when they ask questions, impatient when their proposals need work, or too busy to pair with them. 

The developers who developed me gave a lot of time and care to my development. A question new to me might have been something they have heard a hundred times before. Or, for example, instead of taking on tasks they could have completed quickly, they ceded responsibility to help me grow, then took responsibility for issues. 

More features, more users, more money, more tickets closed, more pull requests, more commits. More. More. More. 

The pressure to produce more, because these tools exist to help us do this, is real. If we measure productivity by how quickly work reaches the finish line, we can indeed look incredibly productive. 

I am completing more work right now, but I don't think I'm a better developer. I think we have found a way to turn productivity into procrastination.  

We can now finish tasks while putting off research, debate, the failed ideas and the awkward conversations that would force us to understand the problems we are tackling. We tell ourselves we can read the code and understand it once it has been generated. But then: More. More. More. Another task is waiting.

I worry we are accepting the demand for more without thinking about what makes us better.

I am part of this problem. I reach for LLMs constantly. I know the satisfaction of getting an immediate answer to my questions, especially when I don’t understand something. 

I enjoy learning, as I mentioned at the start. I like the satisfaction of doing something well and knowing I have done it well. I am worried about my trend towards LLM soft things I should learn. 

I have recently been tackling this problem by practising a little discipline. I spend more time with a problem before asking for a solution. I write out my own proposals using Excalidraw. When I am confident in what I have, I then turn to the tool for improvements. I also reach out to someone else for their opinion. I prefer to do this on a call.

I want to leave room to be taught by others; I also try to recognise when I am in a position to teach and pass down the knowledge I have. 

We need to protect the time and space required to develop knowledge and pass it onwards. That learning shapes our ability to question a solution, recognise its limits and whether it serves our users. We owe that judgement to the people who trust our software.

I wonder what happens to a profession that keeps racing to demonstrate how much it can produce. Whilst giving ourselves fewer opportunities to develop the expertise required behind it.
