---
title: '[Lightning Blog] Reusable Modules - Its as easy as ABI'
date: '2024-10-28T10:56:21+00:00'
author: Jordan Terry
layout: post
permalink: /reusable-modules-easy-as-abi-lightning-talk
excerpt: |
  A "lightning blog" to accompany a lightning talk I have recently given at Kotlin London. I dig into the importance of visibility modifiers and declaring dependencies.

categories:
  - Android
  - Coding
  - Gradle
  - Kotlin
---

# Reusable Modules - It's as easy as ABI

In this post I’m going to share my mental model for evaluating if a Gradle modules in your project are reusable. This is
a « lightning post » which pairs up with a lightning talk I have recently given at Kotlin London.

At the end I’ll share resources for you to dive deeper into the topic!

We’ll start by looking at two key concepts:

- Kotlin’s visibility modifiers - We’ll focus on `public`, `internal` and `private`
- Declaring dependencies in Gradle - `api` and `implementation`

We’ll tie those together to explore how a composition of the two impacts an Application Binary Interface.

Finally, we’ll tie these together to see how this impacts the reusability of your Gradle module.

## Lighting Primers

- **What is a Gradle Module?** - A compilation unit in Gradle. It is normally a folder with a `build.gradle[.kts]` file
  inside it.
- **Wha**

## Visibility Modifiers

Visibility modifiers are such a foundational part of Kotlin that you don’t think about them. But it is important you do,
they have a large impact on your project’s reusability.

Let us look at the three core modifiers: `public`, `internal` and `private`.

### `public`

Look at the code below. We’ve created a `ViewModel` with the `public` modifier.

```kotlin
public class LoginViewModel() : ViewModel() {

}
```

The `LoginViewModel` is now accessible outside the compilation unit where this is located. Any module consuming this
module can see and use this type.

Remember, `public` is optional unless you are compiling with `explicitApi()`.

### `internal`

Next, we have `internal`. In this example we have placed an `internal` keyword before the `constructor`.

```kotlin
public class LoginViewModel internal constructor() : ViewModel() {

}
```

	- `internal constructor`
	- `LoginViewModel` cannot be made constructed of the compilation module

This means that the constructor is not `public`. It can only be accessed by the same module that `LoginViewModel` is
compiled in.

This is a great way of scoping where you can create code from.

### `private`

Finally, `private`. Here, we've added two new properties to our `LoginViewModel`. One of which is `private`, this field
is use a `MutableStateFlow` from [`kotlinx.coroutines`](https://github.com/Kotlin/kotlinx.coroutines). We have a
non-mutable field which is implicitly `public`.

```kotlin
public class LoginViewModel internal constructor() : ViewModel() {
  private val _state = MutableStateFlow<UiState>(UiState.Loading)
  val state: StateFlow<UiState> = _state.asStateFlow()
}
```

The `private` field means this property is `private` to the scope it is defined in. By that, if you've defined something
top level in a file it is accessible to an entire file. If you define it like we have here, it is accessible to the
class it is defined in.

This is all, I hope, straightforward! Let’s look at how we add dependencies to Kotlin.

## Dependencies

Gradle is the build tool of choice for the majority of Kotlin projects. We add dependencies to them using  `api` and
`implementation`.

### `implementation`

When we declare a dependency as the `implementation` keyword we say that I want this dependency to be **consumed** by
this module.

```groovy
dependencies {

  implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'

}
```

This means that the module can independently compile against and execute against the classes defined in a library.

### `api`

When we declare a dependency as an `api` we say that I want this dependency to be **consumed** by this module, but also
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

We must satisfy an ABI by ensuring that any construct that is public is produced from a module. If we don’t the module
is not reusable, forcing consumers to redeclare dependencies.

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

This is a pretty good error! If we look at our module class path (out dependency block) we’ll see the following:

	oh oh! Something doesn't add up.

```groovy
dependencies {

  api 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0'
  implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'

}
```

We have defined the `viewmodel` dependency using `implementation`. Which is not producing the dependency. If we change
it to an API like below it will be produced and our code will compile!

```groovy
dependencies {

  api 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0'
  api 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.6'

}
```

This is pretty much it! Any module, of any scale, will be reusable when dependencies produced matches up to the ABI. Our
ABI is modified by using visibility modifiers.

## Why should you care about this?

Every developer should care about this. Making our modules reusable is great for developer productivity. Developers do
not have to invest time trying to understand why their code doesn’t compile.

Incremental compile time can be impacted. If you are over declaring your modules, you may force the recompilation of
more modules than expected.

We should all care if our code is written correctly! As developers we should care that our work is done correctly for
the tools we use.

## Want to visualise this?

Has this piqued your interest? There are a number of great tools that build upon the concepts mentioned here. Please
check them out:

- [Dependency Analysis Gradle Plugin](https://github.com/autonomousapps/dependency-analysis-gradle-plugin/) - This does
  the process of identifying dependencies and matching them to your ABI automatically. It is very cool.

- [Kotlin Binary Compatibility Validator](https://github.com/Kotlin/binary-compatibility-validator) - Are you a Kotlin
  library author? This will allow you to detect changes in your ABI.
- [Metalava](https://android.googlesource.com/platform/tools/metalava/) - this is the same as Metalava but it covers
  Android + Java.

