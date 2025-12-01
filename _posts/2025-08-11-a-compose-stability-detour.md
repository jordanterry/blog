---
title: "Compose Stability Metrics - Parsing"
date: '2025-08-11T00:08:00+00:00'
author: Jordan Terry
layout: post
permalink: /parsing-composes-stability-metrics
excerpt: |
    A look at how a weekend project is derailed into a defining a bit of pseudocode with ANTLR's grammar system.
categories:
  - Software

---

If you’re an Android Developer and have not been living under a stone, you’ll know what Jetpack Compose is. 

Compose is a declarative way to build a tree of nodes with `@Composable` functions, it monitors the parameters of those functions to know when to recreate part of the tree of nodes. Most Android Developers build a tree of nodes that represent a user interface. 

When using Compose, we learn that a `@Composable` function isn’t like other Kotlin functions. It’s unique; time also applies to a `@Composable`. As time progresses after its initial invocation, it might be invoked `0..n` more times. This happens because Compose monitors the parameters in every `@Composable` function.  

The rules of *why* a recomposition might happen are nicely documented in [Stability in Compose](https://developer.android.com/develop/ui/compose/performance/stability). Chris Bane’s [Composable Metrics](https://chrisbanes.me/posts/composable-metrics/) is a great practical review of the rules enabled by the [metrics reporting in the compiler plugin](https://developer.android.com/develop/ui/compose/performance/stability/diagnose#compose-compiler). 

I have a problem at work. I know that some parts of the search results screen I work on are a bit inefficient. Thanks to the metrics output and many re-reads of the stability documentation I know what my problem is. But.. wouldn’t it be great if I didn’t need to refer to the docs, and the IDE could tell me this? What a great idea, Jordan! That sounds like a fun weekend project.

So, here’s my two-part weekend plan to build a nice tool to help my fellow Android developers.

1. Parse the output from the stability report
	i. Ed: I figured I could just look at the IR created by the Compose compiler. But then I realised, quite frankly, I am not smart enough for that. 
2. Pipe this into a Kotlin 2 compiler plugin and associate this with a Composable, then pipe and stability issues out using the new diagnostics API. 

And now, let’s look at why I spent two days on part one. 

> **📀 Record Scratch**
> Everything from this point onwards is done in the name of tinkering. I’m not convinced, nor do I know if it is a good idea. 


### Compose Compiler Metrics Output 

The documentation for the Compiler Metrics tells us that the output is Kotlin pseudocode. This doc [`compiler-metrics.md`](https://cs.android.com/android-studio/kotlin/+/master:plugins/compose/design/compiler-metrics.md) is a great source for some of the rules. But here’s some of what I have inferred.

#### Classes
Here’s a representation of a reported class:

```
unstable class Snack {
  stable val id: Long
  stable val name: String
  stable val imageUrl: String
  stable val price: Long
  stable val tagline: String
  unstable val tags: Set<String>
  <runtime stability> = Unstable
}
```

This represents something like this: 

```
data class Snack(
	val id: Long,
	val name: String,
	val imageUrl: String,
	val price: Long,
	val tagline: String,
	val tags: Set<String>,
)
```

#### Differences
-	Pseudocode shows `stable` or `unstable` for each field, this is calculated by the compiler. 
-	unstable class and `<runtime stability>` shown explicitly — this is inferred, not declared in Kotlin code. Runtime stability is like the tally of a column in an excel spreadsheet. 
	

#### Functions

```
restartable scheme("[androidx.compose.ui.UiComposable]") fun HighlightedSnacks(
  stable index: Int
  unstable snacks: List<Snack>
  stable onSnackClick: Function1<Long, Unit>
  stable modifier: Modifier? = @static Companion
)
```

```kotlin
@Composable
fun HighlightedSnacks(
    index: Int,
    snacks: List<Snack>,
    onSnackClick: (Long) -> Unit,
    modifier: Modifier = Modifier
) {
    // body
}
```

#### Differences
-	`restartable` and `skippable` appear in pseudocode. In source, they are compiler-derived from stability of parameters.
-	`stable` or `unstable` precede each parameter. Not shown in source but critical for recomposition.
-	The `@Composable` annotation is mapped into the scheme. 

### In steps ANTLR

[**AN**other **T**ool for **L**anguage **R**ecognition](https://www.antlr.org/) is a tool that lets us: 

1. Define a programming language by its Grammar
2. Use that Grammar to turn a blob of text that looks like a language into a semantic tree
3. Allow us to visit parts of that tree using the visitor pattern. 

ANTLR allows us to define a g4 file that represents a Grammar. Commonly, we’ll split it into a Lexer and a Parser. The Lexer represents the “tokens”, and the Parser shows how those “tokens” form a language. Here’s an example from the official [Kotlin grammar definition](https://kotlinlang.org/docs/reference/grammar.html). 

Sadly, the source code for the Compose metrics does not have a [language definition](https://cs.android.com/android-studio/kotlin/+/master:plugins/compose/compiler-hosted/src/main/java/androidx/compose/compiler/plugins/kotlin/BuildMetrics.kt). So let’s build one using ANTLR and see how far we get! 

### Parsing a function

```
restartable scheme("[androidx.compose.ui.UiComposable]") fun HighlightedSnacks(
  stable index: Int
  unstable snacks: List<Snack>
  stable onSnackClick: Function1<Long, Unit>
  stable modifier: Modifier? = @static Companion
)
```

#### The Lexer

We could split the Lexer into two sections, keywords and characters. 

```
// Keywords
RESTARTABLE: 'restartable';
STABLE: 'stable';
UNSTABLE: 'unstable';
SCHEME: 'scheme("' ~["]* '")'; // cheating a bit, but this is a scheme( + any character in quotes + )
FUN: 'fun';

// Characters
ARROW: '->';
LPAREN: '(';
RPAREN: ')';
COLON: ':';
EQUALS: '=';
LT: '<';
GT: '>';
QUESTION: '?';
```

Using this, can we write the first line of the function? No, we need a few more things in our Lexer (learned through trial and error). 

```
// Characters that represent a function (if you look at the Kotlin definition, this isn't correct)
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;

NEWLINE: ('\r'? '\n')+; // Capture \r\n (windows) or \n (unix) new lines
// Skip white space, this is very helpful.
WS: [ \t]+ -> skip;
```

Now we have enough. 

```
restartable scheme("[androidx.compose.ui.UiComposable]") fun HighlightedSnacks()

// Represented by this
RESTARTABLE[WS]SCHEME[WS]FUN[WS]IDENTIFIER LPAREN RPAREN
```

We can visually see this, but we need a Lexer to enable our program to do this. 

Let’s define `functionStability` as a Lexer rule. Below, I’ve made a continuation of the last line in the code block above.

```
// Example:
// restartable scheme("[androidx.compose.ui.UiComposable]") fun AppTitle(
//   stable title: Title
// )
functionStability
    : modifiers SCHEME? FUN NEWLINE* IDENTIFIER NEWLINE* LPAREN parameterList? RPAREN
    ;
```  

`modifiers` is another rule. It defines that `restartable` and `skippable` are both optional. 

```
// Modifiers apply to a function.
// Represent restatable or skippable properties of a function.
modifiers
    : RESTARTABLE? SKIPPABLE?
    ;
```

Between the `LPAREN` and `RPAREN` we commonly have a list of parameters. The rules for this in actual Kotlin would be more flexible. But this rule defines an array of parameters which will have a `NEWLINE` before, and a `NEWLINE` after. 

```
// Parameter list with optional ne
parameterList
    : (NEWLINE parameter)* NEWLINE
    ;
```

The `parameterList` references a `parameter`. This is made of either `STABLE` or `UNSTABLE`, a name (`IDENTIFIER`), a `COLON` and a type. This is very, very similar to actual Kotlin.

```
parameter
    : (STABLE | UNSTABLE) IDENTIFIER COLON type
    ;
```

For completion, here is how I have ended up defining types: \

```
// Examples:
// () -> Unit | String
type
    : functionType | simpleType
    ;

// Examples:
// () -> Unit
// (Int) -> Boolean
functionType
    : LPAREN (type (COMMA type)*)? RPAREN ARROW type
    ;

simpleType
    : IDENTIFIER (LT type (COMMA type)* GT)? (QUESTION | ARRAY)*
    ;
```

As a developer tinkering, I’ve found these to be very problematic to get right. The fact that types can reference types has been a lot to get my head around. But essentially: 

- A `functionType` can reference types in its parameters or return type, e.g. you could return a `functionType` from a `functionType`. 
- A `simpleType`, like a `String`, is straightforward. But any type that has a Generic becomes a bit more complex, `List<String>` or `Set<() -> Unit>`. I took the name `simpleType` from Kotlin, I don’t think this is simple!


#### Visualising the Tree

Antlr gives us a tool to debug our parser! We can give it our `g4` files and ask it to output the tree in a nice GUI. 

Let’s try it out: 

```
antlr4-parse ComposeStabilityLexer.g4 ComposeStabilityParser.g4 functionStability -gui 

restartable scheme("[androidx.compose.ui.UiComposable]") fun HighlightedSnacks()

^d
```

Here’s the output: 

<img src="/images/posts/simple_parse_tree.png" />

We see a tree beginning to take shape, it is taking the shape of the Grammar defined in our Lexer. Let us try it again on a more complex function: 

```
antlr4-parse ComposeStabilityLexer.g4 ComposeStabilityParser.g4 functionStability -gui 

restartable scheme("[androidx.compose.ui.UiComposable]") fun HighlightedSnacks(
  stable index: Int
  unstable snacks: List<Snack>
  stable onSnackClick: Function1<Long, Unit>
  stable modifier: Modifier? = @static Companion
)

^d
```

And here is the output of that: 

<img src="/images/posts/complex_parse_tree.png" />


Now we can see the tree being formed! It’s easy to imagine walking this tree, visiting each node and extracting information from it. Thanks to the grammar we have defined, we can see how it is possible to extract stability and types from each parameter! 

### What Next? 

The use of "visiting" above was purposeful. It's common to use the visitor pattern when visiting nodes in a tree, and ANTLR generates visitors for us. Using this, I can now visit each node in the tree and extract stability information from it! 
 

