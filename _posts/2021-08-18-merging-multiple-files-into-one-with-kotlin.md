---
id: 206
title: 'Merging multiple files into one with Kotlin'
date: '2021-08-18T22:27:27+00:00'
author: Jordan Terry
layout: post
guid: 'http://jordanterry.co.uk/?p=206'
permalink: /merging-multiple-files-into-one-with-kotlin
background: /images/uploads/2021/08/Kotlin-Full-Color-Logo-on-White-RGB-e1637049937600.webp
categories:
    - Software
---

Kotlin lets us write top level functions, this enables us to write code that isn’t necessarily constrained to the
concept of classes. It frees us from “util” classes of static methods (but it doesn’t free us from dumping methods or
functions in one place).

Under the hood, Kotlin is constrained to classes, the compiler must generate bytecode that will run in the JVM (
multiplatform is another story). To do this, it must put your functions into a class. It will take your file name and
create a class from it. Functions in `StringExtensions.kt` will be placed in a class named `StringExtensionsKt`.

You may write a set of extensions on the `Fragment` type that are responsible aiding the retrieval of arguments:

```
// FragmentArgumentExtensions.kt
fun Fragment.requireStringArgument(name: String): String {
    return arguments?.getString(name, null) ?: // throw
}
```

The Kotlin compiler translates it into some bytecode that roughly looks like this:

```
public final class FragmentArgumentExtensionsKt {
    @NonNull
    public static String requireStringArgument(@NonNull Fragment fragment, String name) {
        // Implementation
    }
}
```

You may also have another file containing extensions to help you create a `ViewBinding` for this `Fragment`:

```
// FragmentViewBindingExtensions.kt
fun <T : ViewBinding> Fragment.viewBinding(factory: (View) -> T): T {
    // Implementation
}
```

This Kotlin would then be compiled into a class named `FragmentViewBindingExtensionsKt`.

This all makes sense, we’ve kept our logically different extension functions in separate files. Sometimes we might want
to combine our extensions into a single file:

- If we had Java consumers of our extensions we might want to present the extensions in a single class named
  `FragmentExtensionsKt`.
- Splitting our functions apart internally may not always be the best for a public API.
- We could be working in an environment that requires we keep our class or method count as low as possibl e.g. two
  classes create two constructor methods, one class creates one constructor method

Kotlin provides a couple of handy annotations to support this functionality, `@JvmMultifileClass` and `@JvmName`.

## `@JvmName`

This annotation tells the compiler what to call the class your file will be mapped into. This is useful if you want your
api to look nice for Java users or you want to provide some API compatibility across a Java to Kotlin conversion.

## `@JvmMultifileClass`

This annotation tells the compiler that this file will be contribuing to a class that other files may also bee
contributing to.

When used, they should have the file qualifier and be the first two lines of code in your file.

```
@file:JvmMultifileClass
@file:JvmName("KotlinExtensionsKt")
```

When added to our two files above, the Kotlin compiler will produce a single class under the hood.