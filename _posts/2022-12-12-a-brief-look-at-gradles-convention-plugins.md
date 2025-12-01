---
id: 472
title: 'A brief look at Gradle convention plugins'
date: '2022-12-12T14:48:29+00:00'
author: Jordan Terry
layout: post
guid: 'https://jordanterry.co.uk/?p=472'
permalink: /a-brief-look-at-gradles-convention-plugins

excerpt: |
    Gradle is essential for building Android apps, and Convention Plugins can simplify multi-project codebases by enforcing consistent build logic across modules. They help avoid misconfigurations, reduce repetitive code, and make managing changes, like updating Java or Kotlin versions, more efficient. With Convention Plugins, you can streamline configurations like Kotlin compiler options, dependency injection setups, and SDK versions, ensuring consistency and reducing complexity in large projects.
categories:
    - Software
---

Gradle is the glue that binds our code together that allows us to build an Android application. Exposure to Gradle can
range from limited to deep knowledge producing plugins. Mine currently sits somewhere in the middle. I’m currently
working on levelling it.

My topic of focus over the past few weeks has been **Convention Plugins**. This post is the culmination of what I’ve
learned and it helps me frame Convention Plugins for my mental model. This is by no means a solid resource!

Multi-project applications are nearing the standard for Android codebases\*. Sharing your build logic and rules across
modules is important for a number of reasons:

- As team size grows you want to maintain consistency in how modules are created
- Misconfigured project can impact your task graph causing inflated build times.
- **D**on’t **R**epeat **Y**ourself. The more you repeat the easier it is for a mistake to creep in. It’s even harder to
  make co-ordinated changes.

Here are concrete examples to help:

- Applying the same Jvm source version across all modules for Java or Kotlin
- Applying the same Dagger settings across all modules that require dependency injection
- Applying the same Kotlin compiler flags across all Kotlin modules.
- Applying a consistent min and compile SDK version for Android across modules

You get the idea. If you’ve been around for a while these might stick out as issues you have had to solve. Convention
Plugins can help us solve these problems with idiomatic Gradle.

The majority of my experience with this in the past has been to apply scripts in relevant modules, use `subprojects` or
`allprojects` blocks or put logic in `buildSrc`.

I am used to working with complicated Gradle files. Which can make fixing issues miserable! Does this look familiar?

```kotlin
plugins {
    id("kotlin-android")
    id("kotlin-kapt")
    id("com.android.library")
    id("dagger.hilt.android.plugin")
}

android {
    minSdk 30
    defaultConfig {
        minSdk = 21
        targetSdk = 30
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8.toString()
        targetCompatibility = JavaVersion.VERSION_1_8.toString()
    }
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

```

You may then have a similar Gradle file across many projects. Moving to Java 11 suddenly becomes a manual process. You
can ease the pain by using project wide variables to hold values. You can remove the pain with a Convention Plugin.

## What is a Convention Plugin?

A convention plugin allows us to define configurations, or conventions, for builds that we re-use across a project.

A convention is represented by a Gradle script or a Plugin. They will live in a build logic module that will register
plugins with Gradle. The module is then applied via your `pluginManagement` .

```kotlin
pluginManagement {
    includeBuild("build-logic")
}
```

Once included all projects can access your plugin.

But what can a convention plugin do? Anything a normal Gradle script or Plugin can do!

- Apply plugins to a project (e.g. Kotlin, Android plugins or Kapt)
- Configure extensions or tasks associated with an applied plugin
- Add dependencies to a project

One of the real benefits to me is that it makes Gradle build files feel more life software. You can write plugins using
apply bread and butter principles like: cohesion, coupling and composition. You can write tests, making your build file
feel predictable.

## A Kotlin convention plugin

Here’s a simple example of how we can create a Kotlin convention:

```kotlin
class KotlinConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        target.pluginManager.apply("org.jetbrains.kotlin.jvm")
        target.tasks.withType<KotlinCompile> {
            kotlinOptions.jvmTarget = JavaVersion.VERSION_1_8.toString()
        }
    }
}
```

We can then add this to the build using the `build.gradle.kts` file in our `build-logic` module.

```kotlin
gradlePlugin {
    plugins {
        register("kotlinApplication") {
            id = "example.kotlin"
            implementationClass = "KotlinConventionPlugin"
        }
    }
}
```

A project can then apply this like any other plugin.

```kotlin
plugins {
    id("example.kotlin")
}
```

If you want to update the JVM target you can do that in a single file and have all projects update.

## A Hilt convention plugin

On its own, a Kotlin plugin is less exciting. I think a compelling use case is when we think about applying an
annotation processor and then the libraries that use it.

When creating conventions we should split conventions logically. For example, if we want to use hilt in a project.

Hilt is a dependency injection library that uses kapt. We can write a convention plugin as follows:

```kotlin
class HiltConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            with(pluginManager) {
                apply("org.jetbrains.kotlin.kapt")
                apply("dagger.hilt.android.plugin")
            }
            dependencies {
                add("implementation", "com.google.dagger:hilt-android:2.44")
                add("kapt", "com.google.dagger:hilt-android-compiler:2.44")
            }
        }
    }
```

This library applies the kapt plugin, hilt plugin and adds the related dependencies. The dependencies here are hard
coded as an example but you should make use of the VersionCatalog extension like this:

```kotlin
val libs = extensions.getByType<VersionCatalogsExtension>().named("libs")
dependencies {
    "implementation"(libs.findLibrary("hilt.android").get())
    "kapt"(libs.findLibrary("hilt.compiler").get())
}
```

We can register the plugin:

```kotlin
register("hiltConvention") {
    id = "example.hilt"
    implementationClass = "HiltConventionPlugin"
}
```

Then apply it:

```kotlin
plugins {
    id("example.hilt")
}
```

Now, updating the version or swapping from `kapt` to `ksp` only needs a developer to change a single plugin. Not many
projects.

# Better resources

This scratches the surface. There are many incredible resources out there to help you get started.

- [Gradle docs](https://docs.gradle.org/current/samples/sample_convention_plugins.html) – A brief look at a sample use
  case from the folk at Square.
- [Herding Elephants by Tony Robalik](https://developer.squareup.com/blog/herding-elephants/) – A high level overview of
  how Square use convention plugins to make their monorepo manageable!
- [Now in Android](https://github.com/android/nowinandroid) – A fantastic resource to help you delve into a
  multi-project code base. This serves as a good base for you to build into more complex solutions.
- [Exploring Now in Android Gradle Convention Plugins by Adam Ahmed](https://proandroiddev.com/exploring-now-in-android-gradle-convention-plugins-91983825bcd7)
- I’d encourage reading Dan Luu’s “In defence of simple architecture” – <https://danluu.com/simple-architectures/> – to
  reason if your app needs many modules