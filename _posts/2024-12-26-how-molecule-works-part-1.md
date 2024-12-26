---
title: 'Molecule - How does work? part i'
layout: post
categories:
  - Software
  - Android
---

Molecule from Cash App is a library built on top
of [Jetpack Compose](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/) Compiler +
Runtime to enable us to write reactive code in an imperative code.

General reactive code is often branded as confusing - because it is. Going beyond the basic functions gets a bit
confusing, whether it is Compose, Reactor or Flows. But, reactive code is really really good. As a mobile developer it
is required to write code that updates or wiring up buttons.

Using Jetpack Compose means we are writing without all of the confusing wiring up code. The compiler magically wires
together subscribing from reactive streams for us. **It is SO cool.** We mostly use this for writing up UI screens,
which is neat but it feels like we are scratching the surface.

Molecule, takes the compose runtime and allows us to wire up our Kotlin reactive streams and handle updates
imperatively. Lets take a look:

By annotating generic functions with `@Composable` we are able to make use of Compose’s magic `$composer` parameter to
identify changes to state objects returned from composable.

We can convert the following code:

```kotlin

val productStream = productRespository.observe(10)
val recommendations = recomendationsRepository.observe(10)

combine(productStream, recommendationStream).collect { product, recommendations ->
  ListingsPage(
    product,
    recommendations,
  )
}

```

with:

```kotlin
@Composable
fun ListingScreen(
  productRepository: ProductRepository,
  recomendationsRepository: RecommendationRepository,
): ListingPage {

  val product: Product? = productRespository.observe(10).collectAsState(null)
  val recommendation: Recommendation? = recomendationsRepository.observe(10).collectAsState(null)

  return if (product != null && recommendation != null) {
    ListingPage(
      product,
      recommendations
    )
  } else {
    null
  }

}
```

This removes the need to use reactive operators in order to combine streams of data. Don’t get me wrong, reactive
streams are great but they are complicated - RxJava, Mono, Flow none of them are better than writing plain old boring
imperative code.

The possibility of doing this hasn’t existed until Kotlin + Compose on the JVM (as far as I’m aware).

## How does it work?

Under the hood Molecule sets up the compose runtime. This consists of a few things:

1. A MonotonicClock added to the CoroutineContext. This is retrieved from a `CoroutineScope` passed into the
   `moleculeFlow`. This drives the progress of the coroutines runtime, for Coroutines UI this would normally be
   responsible for ticking along time with the frame rate of a screen.
2. The [
   `Recomposer`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/Recomposer.kt) -
   this is responsible for managing the updating of one or more Composition
3. [
   `Composition`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/Composition.kt) -
   this is used to initially set up the composition. I understand this as responsible for creating the initial tree of
   code.
4. `Applier<T>` - this is for adding and updating the nodes in the renderingtree. It decides; do we want to apply to a
   tree from the bottom up or top down.
   See [Detecting Structural Changes on the compose design docs](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/runtime/design/how-compose-works.md).
1. **Important** - Molecule does not actually render anything; it makes use of the compiler to detect changes.
   Molecule has a [
   `UnitApplier`](https://github.com/cashapp/molecule/blob/4cd38f4764e940915d32f38cc8f8ed7e6bbe7337/molecule-runtime/src/commonMain/kotlin/app/cash/molecule/molecule.kt#L205-L211).
5. `ObserverHandler` - this is an entry into the snapshot system.. I think! I haven’t quite worked this one out.
1. I have these two blog posts queued to
   read - [**How derivedStateOf works: a deep d(er)ive
   **](https://blog.zachklipp.com/how-derivedstateof-works-a-deep-d-er-ive/)
   and [**Talk: Deriving derived state: derivedStateOf explained
   **](https://blog.zachklipp.com/talk-deriving-derived-state-derivedstateof-explained/).

I suggest diving into the code on [
`CashApp/Molecule/molecule.kt`](https://github.com/cashapp/molecule/blob/trunk/molecule-runtime/src/commonMain/kotlin/app/cash/molecule/molecule.kt)
to get a better understanding of how this comes together.