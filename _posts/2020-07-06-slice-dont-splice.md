---
id: 151
title: 'Slice don&#8217;t Splice'
date: '2020-07-06T08:06:54+00:00'
author: jordan_terry
layout: post
guid: 'http://jordanterry.co.uk/?p=151'
permalink: /slice-dont-splice
categories:
    - Coding
---

<figure class="wp-block-image size-large">![](https://jordanterry.co.uk/wp-content/uploads/2020/07/juja-han-l3KOZAMPBOU-unsplash-1024x683.jpg)<figcaption>Photo by [Juja Han](https://unsplash.com/@juja_han?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/slice?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)</figcaption></figure>This weekend I’ve spent some time working on a side project written [TypeScript](https://www.typescriptlang.org/), I’ve never used it before so I’ve spent a lot of time referring to documentation and learning a lot. One thing stood out.

I had an array of data that I wanted to create a sub-list of elements starting from and index, `i`, to a range. You can do this by calling `array.slice`:

> “Extracts a section of the array and returns the new array”
> 
> <cite>https://www.tutorialsteacher.com/typescript/typescript-array</cite>

Typescript, or the underlying Javascript also has a function that adds or removes elements from an array. This is called `array.splice`:

> Adds or removes elements from the array
> 
> <cite>https://www.tutorialsteacher.com/typescript/typescript-array</cite>

I suppose I don’t need to go into detail about what caused me to write this blog post, but I have some lessons:

- Pay close detail to the functions you are writing or selecting from autocomplete.
- Test every single piece of code you change, even if you think you are making a small change
- Unit testing isn’t always enough to catch issues, especially when your unit is manipulating data being passed into it

I’d also like to call out the concept of immutability. This would have saved a stupid developer from a stupid mistake.