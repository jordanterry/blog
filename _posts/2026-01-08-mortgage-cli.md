---
title: "mortgage-cli"
date: '2026-01-08T00:00:00+00:00'
author: Jordan Terry
layout: post
permalink: /mortgage-cli
excerpt: |
    A CLI tool for analysing French rental property investments.
categories:
  - Software
  - Projects
project:
  name: "mortgage-cli"
  summary: "CLI tool for analysing French rental property investments"
  url: "https://jordanterry.github.io/mortgage-cli/"
  technologies:
    - Python
    - CLI
---

My wife and I are looking to buy a property in France. We want to rent it out and, ideally, have it pay for itself. Simple enough, right?

The problem is there's a lot to get your head around: French mortgage rules, notary fees, property taxes, management fees, and rental yields that vary wildly by location. We found ourselves running the same calculations over and over, tweaking one variable at a time. Is this property viable at 4% interest? What if we put 20% down instead of 15%? What rent do we actually need to break even?

## The iteration journey

We've been through a few iterations trying to solve this:

1. **Spreadsheets** - The classic. Works until you want to compare multiple scenarios or share your assumptions with someone else.
2. **Scrapers** - I built tools to pull property listings automatically. Turns out data ingestion is hard and websites don't like being scraped.
3. **A website** - More engineering than the problem warranted.

In the end, I landed on a CLI tool. Claude Code made building it remarkably quick, and a CLI fits how I actually want to use this: run a quick command, see if a property makes sense, move on.

## What it does

The tool has two main concepts: **profiles** and **analysis**.

A profile stores your investment parameters - things you don't want to re-enter every time:

- How much you can put down
- The interest rate you've been quoted
- Your target rental income
- French-specific costs (notary fees, property taxes, etc.)

Then you can analyse properties against that profile:

```
mortgage-cli analyze --price 150000 --rent 900
```

This calculates the break-even rent - the minimum you'd need to charge to cover all expenses - and compares it to your target. The output tells you whether the investment is viable (green), marginal (yellow), or a bad idea (red).

For comparing multiple scenarios at once, there's a sensitivity matrix:

```
mortgage-cli matrix --price-min 100000 --price-max 200000 --rent 1000
```

This shows how break-even rent varies across different price points and down payment percentages. Useful for understanding how much flexibility you have.

## Why a CLI?

I keep coming back to command-line tools for personal projects. They're quick to build, easy to script, and you can pipe the output wherever you need it. Need a CSV for a spreadsheet? `--format csv`. Want to save scenarios for later? Redirect to a file.

## Early days

These early days for tools like this are exciting. Pre-Claude Code, this project would have joined the graveyard of half-finished side projects. I'd have got the core logic working, lost momentum on the CLI interface, and never come back to it.

Instead, I have something I actually use. Something with practical benefit for a real decision my wife and I are making. That's the shift I keep noticing: the gap between "I should build something for this" and "I have something that works" has shrunk dramatically.

The tool is up at [jordanterry.github.io/mortgage-cli](https://jordanterry.github.io/mortgage-cli/) if you're interested.
