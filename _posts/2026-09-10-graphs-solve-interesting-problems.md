---
title: "Graphs solve interesting problems"
date: '2026-09-10T00:00:00+00:00'
author: Jordan Terry
layout: post
permalink: /graphs-solve-interesting-problems
categories:
  - Software
---

*This is an exceprt from a post, and a piece of software I'm working on internally at Etsy. I'm just really happy with myself that I wanted to share it.*

Software Engineering is full of Graph problems that have been solved with interesting algorithms. Search, navigation, networking, recommendation systems. Each of these is solved by mapping relationships and identifying how to navigate between them. I want to share an example of using a graph to solve an interesting problem.

The Android codebase I work on day-to-day is fundamentally monolithic. Whilst code is distributed across multiple compilation units, the majority (tens of thousands of Kotlin files) sit in a single large "module" (a [Project](https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html) in [Gradle](https://gradle.org/) parlance). Monoliths carry a large burden: complexity, longer compilation time, and hidden boundaries between code.

To break apart a monolith, we say that we want to modularise it. Doing so lets us better leverage the build system. Local and distributed build caching, plus better distribution of work across threads, lead to faster builds. From some experimentation, I've been able to reduce test run time in some areas from three minutes to eight seconds (this is not measured, but anecdotal, don't go quoting this just yet). Modularised code also makes code ownership easier to understand.

Breaking apart a monolith is arguably "straightforward". For a file to be extractable, the following must be true:

> A file must have zero references to files within the same module of code.

Often, files are grouped together to create a meaningful feature, so of course they reference one another. If we follow the file-by-file invariant strictly, you'll never find anything to move. Also, are we really going to modularise code file by file? Probably not!

Let's stop thinking about files and start thinking in groups. When we think in groups, we need to find a way to identify the grouping that gets in the way of modularisation. In a graph, there is a term for this a [Strongly Connected Components](https://en.wikipedia.org/wiki/Strongly_connected_component) (SCC): a set of nodes where every node can reach every other one and back. A cycle, in other words! If `Package A` depends on `Package B` and `Package B` depends on `Package A`, that's one SCC. We can't modularise an SCC correctly, so we must find a way to break the cycles. This changes the invariant above:

> An SCC is extractable when it has no dependency cycle with the code it's leaving behind, and everything it still depends on has already been modularised.

This is a much easier problem space to work with. But still, in our large module it is incredibly hard to reason about. We're only human, and holding a graph of this size in our head impossible! We could do it a couple of times, but it is hard to do multiple times. To quote Dijkstra in [Notes on Structured Programming](https://www.cs.utexas.edu/~EWD/ewd02xx/EWD249.PDF):

> We tell ourselves that what we can do once, we can also do twice and by induction we fool ourselves into believing that we can do it as many times as needed, but this is just not true! A factor of a thousand is already far beyond our powers of imagination!

So lets use a computer to do things beyond the powers of our imagination. Like I say, this project is still very WIP and I want to share my overarching thoughts.

## Building a Graph on the JVM

Android apps run on a Virtual Machine that executes DEX bytecode. The build gets there in two steps: Kotlin and Java source code is compiled to JVM `.class` files, then D8 converts those into DEX. It's the intermediate [`.class`](https://docs.oracle.com/en/java/javase/26/docs/specs/jvms/jvms-4.html) file that we care about. Inside every class file is a constant pool, that records the fully qualified name of each class the compiled code references: types, fields, or names in a signature.

As a class file is compilation output, not input: it reflects what a compiler has resolved, not what someone has typed. Source files are noisy: wildcard imports, unused lines and large inheritance chains! The types are also resolved to classes on a classpath, of which resolving is difficult. Parsing a `.class` file ensures that we are parsing exactly the result of a compilation, and removes complexity from our parsing.

<img src="/images/posts/jvm-class-files.png" />

This sounds a bit like a Graph, doesn't it? Well, that's because it is one! Class files are nodes and references are our edges.

<img src="/images/posts/its-a-graph.png" />

The JVM also has the concept of "packages", these are namespaces to separate code. These are much more useful in Java and don't really have any meaning in Kotlin. But, they are useful for grouping together code. Storing the package is pretty helpful.

## Finding SCCs

We have our graph, let's find some cycles! We need to condense our class files into packages, these are the groups of code we will work with. Each class-to-class edge becomes an edge between the packages the classes live in.

<img src="/images/posts/class-to-packages.png" />

To give a sense of scale, this kind of graph can reduce tens of thousands of class-level nodes down to a few hundred packages. It's still a lot, but it's a graph that a computer can get through in a few milliseconds and a human can actually read it!

With our graph of packages, we hand it over to a Strongly Connected Component algorithm. [Tarjan's](https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm) is the famous one of the bunch, the library I've used to implement this uses [Gabow's](https://en.wikipedia.org/wiki/Path-based_strong_component_algorithm) (please don't ask me to explain the difference!). A single depth-first pass of the Graph can identify all strongly connected components (it does this in linear time, and is frankly a minor miracle). This should produce two types of SCCs:

* Simple SCCs: Single packages are their own SCCs. They sit in no cycle, so the algorithm will just hand them back to us.
* Tangled SCCs: Some packages clump into cycles. `Package A` needs `Package B`, `Package B` needs `Package A`. One SCC across two packages, these cannot be modularised.

<img src="/images/posts/tangled-packages-to-tangled-scc.png" />

In a healthy codebase, you should get a lot of the first kind. In a monolith you tend to get one enormous SCC, think of it as a massive knot, where hundreds of packages all reach each other. This is where a huge chunk of code lives.

## Sorting SCCs

Our graph of condensed SCCs is probably enough to run with. But it isn't really enough, we want a plan to tell us how to modularise! We can do one more trick to make this possible. We can collapse every SCC into a single node in a new Graph. An SCC of N dots will become a single node. This removes cycles from our graph and creates a Directed Acyclic Graph (DAG). We can sort a DAG by using a topological sort.

The topological sort should provide us with a plan. It's an ordering where nothing shows up before the things it depends on. Reading it from top to bottom should show packages that depend on nothing still in the monolith, then packages that rely only on packages that have no dependencies.

<img src="/images/posts/topologically-sorted.png" />

With this, we can just get on with modularisation. Extracting modules that have no dependencies. This is remarkably similar to.. Compilation! A compiler or build system has to do the process above to know where it can start compiling!

## What's next?

I've mostly stayed away from the concrete details as I am still toiling on this. But I have discovered the [JGraphT](https://jgrapht.org/) library which provides Java implementations of Graph's and relevant aglorithms. Discovering this, made this project actually achievable. 

I'm trying to avoid scope creep as I come up with ideas. But I am interested in a couple of additional ideas: 

1. Using [Leiden's algorithm](https://en.wikipedia.org/wiki/Leiden_algorithm) to discover communities of code. I'm currently experimenting with [lowest common ancestor](https://en.wikipedia.org/wiki/Lowest_common_ancestor) and package name to determine related behaviour, but what if file location isn't the best way to do that? What if we can discover it through the coupling of code itself? 
2. Can I rewrite the graph and then use the rewritten graph to produce move source code? Obviously llms can do this, but I wonder if this could be made determenistic?

In general I am pretty psyched about this. I'm excited to find out if this truly works, or if I have missed something obvious!
