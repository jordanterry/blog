---
title: 'Strongly Typed APIs - Compose Navigation Transitions'
date: '2025-07-28T00:00:00+00:00'
author: Jordan Terry
layout: post
permalink: /stronly-typed-compose-navigation-apis
excerpt: |
    A look at the simple, but nice Compose Navigation Transition APIs.
categories:
  - Software

---

A nice detail I’ve noticed in the Compose Navigation library is the usage of strong types. 

Let’s take a look at the [NavHost](https://developer.android.com/reference/kotlin/androidx/navigation/compose/package-summary#NavHost(androidx.navigation.NavHostController,androidx.navigation.NavGraph,androidx.compose.ui.Modifier,androidx.compose.ui.Alignment,kotlin.Function1,kotlin.Function1,kotlin.Function1,kotlin.Function1,kotlin.Function1)) composable API. 

```kt
@Composable
fun NavHost(
    navController: NavHostController,
    graph: NavGraph,
    modifier: Modifier = Modifier,
    contentAlignment: Alignment = Alignment.TopStart,
    enterTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> EnterTransition = {
            fadeIn(animationSpec = tween(700))
        },
    exitTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> ExitTransition = {
            fadeOut(animationSpec = tween(700))
        },
    popEnterTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> EnterTransition = enterTransition,
    popExitTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> ExitTransition = exitTransition,
    sizeTransform: (AnimatedContentTransitionScope<NavBackStackEntry>.() -> SizeTransform?)? = null
): Unit
```


The definition of `enterTransition` is fantastic in its simplicity. Its receiver and return type are doing a remarkable amount of heavy lifting. I’m interested

```kt
enterTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> EnterTransition
```

Its return type, [EnterTransition](https://developer.android.com/reference/kotlin/androidx/compose/animation/package-summary#fadeOut(androidx.compose.animation.core.FiniteAnimationSpec,kotlin.Float)),  prevents a user from adding a new NavBackStackEntry and using [fadeOut](https://developer.android.com/reference/kotlin/androidx/compose/animation/package-summary#fadeOut(androidx.compose.animation.core.FiniteAnimationSpec,kotlin.Float)) to add it to the screen. The code `enterTransition = { fadeOut(/* args */ }` cannot compile, preventing a category of runtime errors. A far cry from the days of `@IntRes` or `Anim`, types that lack the semantic simplicity and richness of `EnterTransition` and [ExitTransition](https://developer.android.com/reference/kotlin/androidx/compose/animation/ExitTransition).  

[AnimatedContentTransitionScope\<\*\>](https://developer.android.com/reference/kotlin/androidx/compose/animation/AnimatedContentTransitionScope#public-functions) as a Receiver is also nice. Any functions added are a receiver-scope extension; **only** accessible in functions with this as a receiver. 

These are small details, but they make these APIs incredibly accessible and straightforward to use. 
