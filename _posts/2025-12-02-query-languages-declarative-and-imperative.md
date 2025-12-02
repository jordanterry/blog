---
title: "Query Languages: Declarative and Imperative"
date: '2025-12-02T00:08:00+00:00'
author: Jordan Terry
layout: post
permalink: /query-languages-declarative-and-imperative
excerpt: |
    Database Query Lanugages and Data Models, how to they relate to Jetpack Compose?
categories:
  - Software

---

Chapter two of [Designing Data-Intensive Applications](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/) is called “Data Models and Query Languages”. It touches on a vast array of topics: the competition between Relational and Document models in the 70’s, through to the Relational model victory through to the introduction of Not-quite SQL databases. It takes us on a tour of one-to-many and many-to-many databases and explains how these relations dictate your underlying data model choices. 

## Query Languages

The book proposes that there are two types of query languages: **declarative** and **imperative**. Before reading this, I had some vague notion of this, but I can’t say I had ever deeply thought about the relationship. I’ve found the section discussing Query Languages to be simple, but to have caused a small revolution in my mental model for data models and querying them.

### Declarative

SQL (Structured Query Language) is a declarative query language. Everyone knows and ~~loves~~ ~~hates~~ loves it. 

```sql
SELECT 
  * 
FROM 
  animals 
WHERE 
  family = 'shark';
```

This is **declarative** because the query is defining what data is required, not the *how*. The query engine is responsible for that.

Contrast this to the an **imperative** alternative: 

```kotlin
fun sharks(): List<Animal> {
	val sharks = arrayListOf<Animal>()
	for (animal in animals) {
		if (animal.family == "Sharks") {
			sharks.add(animal)
		}
	}
	return sharks
}
```

Imperative instructions have been written to define the *how*. We are locked into this implementation as it is the code we have written. 

#### What’s the difference? 

The **imperative** code above is going to always have a time-complexity of `O(n)` where `n` is the count of animals. Parallelising the code above is going to be complex, too. The **declarative** code is not tied to an implementation in any way. The query engine is responsible for applying queries; it knows how to leverage the computer it is running on to parallelise and run as quickly as possible. Perhaps we can introduce a new index that allows us to search with `O(log n)` time complexity? And then there are joins, joins are complex too! **Imperative** joins require two outbound database connections, whereas the **declarative** query runs on the same machine. 


### Where else does this apply? 

Data models don’t only exist on databases. If you write HTML, JSON or any UI code, you are creating a data model. Often, they are defining a tree. 

To lift another shark-related example from the book, here is a HTML data model: 

```html
<ul>
	<li class="selected">
		<p>Sharks</p>
		<!-- More HTML -->
	</li>
	<li>
		<p>Whales</p>
		<!-- More HTML -->
	</li>
</ul>
```

Cascading Style Sheets (CSS) are used to style different elements in the data model. 

```css
li.selected > p {
	background-color: blue;
}
```

CSS is another declarative query language; it doesn’t tell CSS *how* it should traverse the Document Object Model (DOM), that is left to the browser engine. 

The **imperative** alternative is to query the DOM using JavaScript. Each instruction for the machine will be typed out and executed, perhaps inefficiently! 

### What about Jetpack Compose?

All of this talk of data models and query languages is very exciting. It got me thinking about Jetpack Compose. For Android developers, this introduced the concept of **declarative** UIs. We define *what* we want but not the *how*. The creation of the underlying UI tree is delegated to the library: 

```kotlin
@Composable
fun AnimalList() {
	Column {
		Row {
			Text("Sharks")
		}
		Row {
			Text("Whales")
		}
	}
}
```

At runtime, the UI can be updated to change the background colour: 

```diff
@Composable
fun AnimalList() {
	Column {
		Row {
			Text(
				"Sharks",
+				modifier = Modifier
+					.background(Colors.Blue)
			)
		}
		Row {
			Text("Whales")
		}
	}
}
```

Compose is both the data model and a query language. By changing the user interface at runtime, it knows *how* to efficiently find relevant parts of the data model and update them. The user doesn’t need to know about slot-tables or gap buffers. The library handles these for us. 

### Obviously, duh?

Maybe this isn’t “revolutionary” to others, but it was for me. The chapter introducing the relationship between databases and the web’s data models has helped me open my eyes to further relationships. 

I love this book! 

