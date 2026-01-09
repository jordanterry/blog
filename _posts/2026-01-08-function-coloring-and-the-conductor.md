---
title: "Function Colouring and Structured Concurrency in Kotlin"
date: '2026-01-08T00:00:00+00:00'
author: Jordan Terry
layout: post
permalink: /function-coloring-and-the-conductor
excerpt: |
    What happens when you cross the red/blue boundary in Kotlin coroutines?
categories:
  - Software

---

In Kotlin, not all functions are created equal. Some are `suspend`, others are not. This distinction matters more than you might think.

Bob Nystrom wrote a fantastic piece called [What Color is Your Function?](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/) that introduces a helpful mental model. Functions have colours: red and blue. Each colour comes with rules:

- Red functions can call blue functions
- Red functions can call red functions
- Blue functions can call blue functions
- Blue functions **cannot** call red functions

In Kotlin, red maps to `suspend` functions. Blue maps to regular blocking functions. The metaphor maps cleanly.

```kotlin
// Red function
suspend fun fetchUser(): User { ... }

// Blue function
fun processUser(user: User): String { ... }
```

Kotlin bends the rules slightly with coroutine builders like [`launch`](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/launch.html) and [`async`](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/async.html). These let blue functions *start* red work. But there's a cost to bending rules.

### The Conductor

The "magic" behind Kotlin coroutines is the [`Continuation`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.coroutines/-continuation/). Think of it as a conductor for an orchestra. It's always there, orchestrating the asynchronous work: managing suspension points, state machines, and cooperative cancellation.

The Kotlin compiler adds a `Continuation` as the final parameter to every `suspend` function. When one suspend function calls another, the continuation travels with it. This is how [structured concurrency](https://kotlinlang.org/docs/coroutines-basics.html#structured-concurrency) works - when a parent coroutine is cancelled, all children are cancelled too.

Here's the problem: if a suspend function calls a blocking function, the continuation can't travel into that call. It pauses outside until control returns. The conductor has left the room.

### Crossing the Boundary

Consider this pattern:

```kotlin
suspend fun collectEvents() {
    eventFlow.collect { event ->
        handleEvent(event) // Blue function
    }
}

fun handleEvent(event: Event) {
    coroutineScope.launch {
        // Red work inside a blue function
        val result = repository.fetch(event.query)
        dispatcher.dispatch(Result(result))
    }
}
```

The call stack goes: red -> blue -> red. We've crossed the boundary twice. The `launch` call returns immediately, and the handler continues. The launched coroutine runs on its own timeline.

Three things happen:

1. **Loss of Continuation** - The blocking function doesn't receive the `Continuation` from the suspend function above it. The conductor can't orchestrate what happens inside `launch`.

2. **Non-determinism** - Once the handler returns, cooperative sequencing is lost. We can't guarantee the launched coroutine finishes before the handler does.

3. **Detached lifecycle** - The new coroutine executes independently, which can result in multiple overlapping jobs if the same event is triggered rapidly.

### The Search Problem

Imagine a search bar. A user types "gold necklace". Every keystroke produces an event: "g", "go", "gol", "gold", "gold ", and so on. Each event might trigger a network request.

Requests vary in latency. The request for "gold" might complete *after* the request for "gold necklace". If you update your UI with whatever response arrives, you get stale results overwriting fresh ones.

The manual fix looks like this:

```kotlin
class SearchHandler(
    private val coroutineScope: CoroutineScope,
) {
    private var job: Job? = null

    fun handle(event: Event) {
        job?.cancel()
        job = coroutineScope.launch {
            val results = searchRepository.search(event.query)
            dispatcher.dispatch(SearchResults(results))
        }
    }
}
```

This works in the narrow sense - only the latest search survives. But we've reinvented concurrency control, and done it worse than what Kotlin already provides.

### Keeping the Conductor in the Room

The fix is simple in principle: stay red. If we keep every step in the suspend world, we never lose the continuation.

```kotlin
class SearchHandler(
    private val searchRepository: SearchRepository,
) {
    suspend fun handle(query: String): Event {
        val results = searchRepository.search(query)
        return SearchResults(results)
    }
}
```

Wire this up with Kotlin [`Flow`](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/-flow/)'s built-in operators:

```kotlin
queryFlow
    .distinctUntilChanged()
    .mapLatest { query ->
        searchHandler.handle(query)
    }
    .collect { event ->
        // Process result
    }
```

[`mapLatest`](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/map-latest.html) does what our manual job tracking tried to do, but correctly. Each new emission cancels any in-flight work before starting fresh. The continuation never leaks across the boundary. Cancellation propagates from the Flow collector through every emission.

### The Takeaway

Function coloring isn't just a theoretical concept. It has practical consequences. Every time you cross the red/blue boundary with a coroutine builder inside a blocking function, you're dismissing the conductor.

For most code, this is fine. But for high-frequency events - search typing, rapid button taps, pull-to-refresh - the consequences compound. Out-of-order results, stale state, wasted work.

The solution is to respect the colours. Keep red work red. Let Flow's operators handle the cancellation semantics. The conductor knows what they're doing.
