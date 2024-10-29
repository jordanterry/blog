---
title: 'Reusable Modules - Its as easy as ABI'
date: '2024-10-28T10:56:21+00:00'
author: Jordan Terry
layout: post
permalink: /reusable-modules-easy-as-abi-lightning-blog
excerpt: |
  A "lightning blog" to accompany a lightning talk I have recently given at Kotlin London. I dig into the importance of visibility modifiers and declaring dependencies.

categories:
  - Android
  - Coding
  - Gradle
  - Kotlin
---


In this post I’m going to share my mental model for evaluating if a Gradle moduls in your project is reusable. This
pairs up with a lightning talk (also
called [Reusable Modules - It's as easy as ABI](https://www.jordanterry.co.uk/reusable-modules-easy-as-abi)) I have
recently given at Kotlin London.

We'll start by looking at two key concepts:

- Kotlin’s visibility modifiers - We’ll focus on `public`, `internal` and `private`
- Declaring dependencies in Gradle - `api` and `implementation`

Then we'll tie them together to explore how a composition of the two forms an Application Binary Interface.

Then we'll evaluate what impact this has on a module's reusability.

## Visibility modifiers

A foundational part of Kotlin that you don’t think about them. But it is important you do, they have a large impact on
your project’s reusability.

### `public`

In the code below the `LoginViewModel` has been modified with the `public` modifier.

```kotlin
public class LoginViewModel() : ViewModel() {

}
```

The `LoginViewModel` is now accessible outside of its compilation unit. Any module consuming this module can see and
use this type.

`public` is optional, it is implicit, unless you are compiling with `explicitApi()`.

### `internal`

In this example we have placed an `internal` keyword before the `constructor`.

```kotlin
public class LoginViewModel internal constructor() : ViewModel() {

}
```

This means that the constructor is not `public`. It can only be accessed by the same compilation unit that
`LoginViewModel` is
compiled in.

This is a great way of scoping where you can create code from.

### `private`

Below we've added two new properties to our `LoginViewModel`. One of which is `private`, this field
is use a `MutableStateFlow` from [`kotlinx.coroutines`](https://github.com/Kotlin/kotlinx.coroutines). We have a
non-mutable field which is implicitly `public`.

```kotlin
public class LoginViewModel internal constructor() : ViewModel() {
  private val _state = MutableStateFlow<UiState>(UiState.Loading)
  val state: StateFlow<UiState> = _state.asStateFlow()
}
```

The `private` field means this property is `private` to the scope it is defined in. If you've defined something
top level in a file it is accessible to an entire file. If you define private on something scoped to a class, it is
accessible to the
class it is defined in.

This is all, I hope, straightforward! Let’s look at how we add dependencies to Kotlin.

## Dependencies

We add libraries to a Gradle project using the dependencies block in a build file. The two methods of adding
dependencies that we are interested in are `api` and `implementation`.

### `implementation`

Using the `implementation` keyword we are telling the build that this dependency should be **consumed** by the current
module.

```groovy
dependencies {

  implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'

}
```

This means that the module can independently compile against and execute against the classes defined in a library.

### `api`

When we declare a dependency as an `api` we are telling this dependency should be **consumed** by this module, but also
be **produced** by it.

```groovy
dependencies {

  implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'
  api 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0'

}
```

This means that the module can independently compile against and execute against the classes defined in a library. Not
only that, but it will produce that library for consumers of this module to be compiled and run against.

## Application Binary Interface

Our usage of modifiers and dependencies comes together to form something called an Application Binary Interface (ABI).

The ABI itself is the enumeration of all classes, functions and properties that are public from a module. It is how
other modules see other modules during compilation.

An ABI is used for binary compatibility checks in libraries. Comparing one ABI to another for the same module (e.g. a
prior release) informs if you have changed an API and must change your semantic version.

Below is an ABI generated from the `LoginViewModel`.

```
@Lkotlin/Metadata;
public final class uk/co/jordanterry/LoginViewModel : androidx/lifecycle/ViewModel {



	public final fun getState ()Lkotlinx/coroutines/flow/StateFlow;


}
```

Let’s break it down line by line.

```
@Lkotlin/Metadata;
public final class uk/co/jordanterry/LoginViewModel : androidx/lifecycle/ViewModel {
```

We see: our `public final class`, the fully qualified `LoginViewModel` and fully qualified Androidx `ViewModel`.

```
	public final fun getState ()Lkotlinx/coroutines/flow/StateFlow;
```

We see: the `public` `getState` function which returns the fully qualified `StateFlow`.

But, something doesn’t work here. We haven’t produced the androidx `ViewModel` from the module containing
`LoginViewModel`. If we compile the application we’ll see the following compilation error:

> Cannot access 'android.lifecycle.ViewModel' which is a supertype of 'uk.co.jordanterry.LoginViewModel'. Check your
> module classpath for missing or conflicting dependencies.

This is a pretty good error! If we look at our module classpath (out dependency block) we’ll see the following:

```groovy
dependencies {

  api 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0'
  implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'

}
```

We have defined the `viewmodel` dependency using `implementation`.
Which is not producing the dependency. If we change
it to an API like below it will be produced and our code will compile!

```groovy
dependencies {

  api 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0'
  api 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'

}
```

The module is now reusable - it is **producing** dependencies that contain classes that are public on it's ABI.

To make your modules reusable, we must satisfy an ABI by ensuring that any construct that is public is **produced** from
a module. If you notice something is public that shouldn't you can modify it's visibility to solve the problem.

### The code generation gotcha

If you work in a codebase that makes use of code generation. Beware that generated code will end up on your ABI.

A concrete example is Dagger. Dagger dependencies will **always** need to be an `api` because they are present on
generated code. Dependencies you thought were internal may not be anymore, Dagger will create public factories exposing
those types!

## Why should you care about this?

Making our modules reusable is great for developer productivity. Developers do not have to invest time trying to
understand why their code doesn’t compile.

Incremental compile time can be impacted. If you are over declaring your modules, you may force the recompilation of
more modules than expected.

We should all care if our code is written correctly! As developers we should care that our work is done correctly for
the tools we use.

## Tools

Has this piqued your interest? There are a number of great tools that build upon the concepts mentioned here. Please
check them out:

- [Dependency Analysis Gradle Plugin](https://github.com/autonomousapps/dependency-analysis-gradle-plugin/) - This does
  the process of identifying dependencies and matching them to your ABI automatically. It is very cool.

- [Kotlin Binary Compatibility Validator](https://github.com/Kotlin/binary-compatibility-validator) - Are you a Kotlin
  library author? This will allow you to detect changes in your ABI.
- [Metalava](https://android.googlesource.com/platform/tools/metalava/) - this is the same as Metalava but it covers
  Android + Java.

Tony Robalik is produced a post on ABIs:

- [Dependency Analysis Gradle Plugin: What's an ABI?](https://dev.to/autonomousapps/dependency-analysis-gradle-plugin-what-s-an-abi-3l2h) -
  this should be required reading for all devs
