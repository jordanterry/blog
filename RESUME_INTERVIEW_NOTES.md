# Resume Interview Notes

Compiled from interview session targeting Anthropic Product Engineer role.

---

## Target: Anthropic

**Role Type:** Product Engineer

**Relevant Experience Themes:**
- Developer tools/productivity
- Generalist mindset (product, infra, speaking)
- Safety/quality thinking

**What Anthropic Values (from research):**
- "Side quests" - personal projects, weekend work
- Generalist engineers who go beyond code
- AI safety awareness
- Low-ego, high-trust collaboration
- Independent research, blog posts, OSS at top of resume
- Impact over credentials

---

## Etsy (2023 - Present) - Senior Android Engineer

### Primary Focus: Search Team
- Search experiences and retrieval systems
- CLIP models for search
- Espoir for ANN (Approximate Nearest Neighbor) searches
- Rapid iteration on UX to drive user outcomes

### LLM Guardrails Work (Highly Relevant for Anthropic)
- **Problem:** Output validation for LLM integrations
- **Approach:** Schema/type validation + compile-time checks
- Built immutable guardrails as part of LLM adoption
- Shows safety-first thinking

**Deep Dive (from interview):**
The journey started with a loosely-typed PHP backend. Jordan helped introduce strict validation using JSON Schema:
- Produces Swagger documentation that AI tools (like Claude) can understand
- Creates source-controlled, reviewable schemas that can be commented on in PRs
- Drives client-side typed class generation in Kotlin
- Moving toward compile-time validation: sealed types generated from validated types
- **Key insight:** Makes it impossible for LLMs to hallucinate types - if it doesn't match the schema, it won't build
- Similar to Protobufs/Thrift pattern but using JSON Schema

**Additional benefits beyond LLM safety:**
- Reduced API payload sizes (99th percentile search responses are 600KB - potential for significant reduction)
- Better documentation, better developer experience, better AI tooling integration

**Content Generation Experiments:**
- Also explored LLM use for rewriting product titles on Etsy
- Careful consideration of guardrails for user-generated content rewriting

### Testing & Compiler Verification
- Drove major improvement in testing practices
- Built compiler verification systems
- **Impact:** ~5% reduction in coroutine errors (continuation issues)
- Cross-platform influence: Helped iOS team with Swift 6 structured concurrency adoption
- Cultural impact: Changed how teams think about these issues

**Deep Dive (from interview):**
Starting point: Team had **no buy-in** for testing.

Jordan changed this through:
1. **Showing value** - Demonstrated concrete benefits (caught bugs, enabled refactoring, faster iteration)
2. **Leading by example** - Modeled the behavior, others followed
3. **Improved Turbine patterns** - Better test structure for Flow/coroutine testing

Key improvement was bringing better **test structure** for Turbine usage.

### MVI Architecture for Structured Concurrency
- Drove architectural proposal and implementation
- Modified MVI system to maintain structured concurrency
- Reduced race conditions and coroutine errors
- Hard to quantify but visible impact on code quality

**Deep Dive (from interview):**
The core problem was **scope mismanagement** causing leaked coroutines:
- ViewModelScope not being properly replaced in dependency injection
- Scopes created by DI library conflicting with built-in viewModelScope
- Led to statically swapping out the main dispatcher in tests (ugly pattern)
- Dispatchers.main.immediate requires a Looper in tests - unreliable
- Passing scopes into blocking functions causing async chaos
- Symptoms: double-refresh on screens, inconsistent typing validation, race conditions in responses

The MVI architecture enforces proper structured concurrency through message-based event dispatching.

### Leadership & Representation
- Mentoring other engineers
- Architecture decision-making
- Cross-team collaboration
- Speaking: Etsy event in Mexico City (CDMX) for local hiring
- Speaking: NYC event

### Search Metrics
- *Still gathering specific numbers*

---

## Twitter (2021 - 2022) - Software Developer II

### Primary Focus: Twitter Blue
- Premium subscription features
- Scale: Millions of DAUs

### Cross-Platform Data Syncing
- First exploration of syncing data reliably across iOS, Android, and web
- GraphQL and GraphQL subscriptions
- Novel problem at Twitter scale

### Unified Card Stack
- Rendering consistency across the platform
- Ensuring cards look/behave the same everywhere

### Observability
- Production monitoring using Interana
- Proactive issue detection

### Speaking
- Droidcon Lisbon (representing Twitter)

---

## Marks & Spencer (2020 - 2022) - Senior Android Engineer
*Note: 24 months, not just 2022*

### Primary Focus: Build Systems & Platform

### Developer Productivity Improvements
- Gradle optimization
- CI/CD pipeline improvements
- Developer workflow tooling
- **Impact:** 50%+ build time reduction

### Droidcon London Talk
- "Developer Productivity on a Budget"
- Directly based on M&S work
- Co-presented with Adam Ahmed

---

## The Guardian (2018 - 2021) - Android Developer
*~4 years tenure*

### Role: Tech Lead Responsibilities

### Kotlin Migration
- Led migration from Java to Kotlin
- Part of codebase modernization

### Modularization
- Breaking up monolithic codebase
- Gradle build optimization
- Improved maintainability

### Product Features (Most Proud Of)
- **Premium Subscriptions:** Built premium content access and subscription management
- Sign in with Apple (custom Android solution)
- Personalized marketing messaging

---

## ClearScore (2017 - 2018) - Android Developer

- Hybrid to native Android transition
- Early Kotlin adoption in production

---

## Unique Differentiators

### Side Quests
- Blog (jordanterry.co.uk)
- grph - CLI tool for graph traversal
- Learning/exploration of new technologies
- Non-tech: Student pilot (VFR flying), ultra running, triathlon

**grph Deep Dive (from interview) - HIGHLY RELEVANT FOR ANTHROPIC:**
grph is explicitly designed to **help LLMs understand complex codebases**.

**The Vision: "Mega Graph"**
A unified graph combining:
- **Static graphs:** Dependency injection graph, build graph (module dependencies)
- **Runtime graphs:** Actual DI class paths, navigation graphs

**What grph does:**
- Enables graph algorithms (PageRank, connectivity, hubs, ancestors, neighbors)
- Well-documented so LLMs can use it to navigate and reason about codebases
- **Goal:** Help AI tools like Claude come to conclusions about complex dependency structures

**Why it matters:**
- Current project has very complex DI graph
- Motivation: Help LLMs understand large, interconnected codebases better
- Shows direct interest in AI tooling and developer experience

### Public Speaking
- Droidcon London (M&S)
- Droidcon Lisbon (Twitter)
- Kotlin London
- Android NYC Meetup
- App Dev Nights Mexico City
- Etsy events (CDMX, NYC)

**Droidcon London Deep Dive:**
- Talk: "Developer Productivity on a Budget"
- Co-presented with Adam Ahmed
- Based directly on M&S work
- **Impact:** Great audience response, made connections with other speakers

**Droidcon Lisbon Deep Dive:**
- Represented Twitter at the conference
- Topic: Build systems (Gradle/build optimization)
- Career highlight: Speaking for a major tech company at international conference

**Etsy Events:**
- Mixed purpose: Hiring, tech talks, community building
- Mexico City and NYC events

### Diverse Interests
- Aviation (student pilot)
- Endurance sports (ultra running, triathlon, cycling)
- Shows curiosity and discipline beyond tech

---

## Key Themes for Resume

1. **Developer Productivity & Tooling** - Thread across M&S, Etsy, Guardian
2. **Safety/Correctness Thinking** - LLM guardrails, structured concurrency, testing
3. **Cross-Platform Impact** - iOS/Android collaboration at Etsy, Twitter syncing
4. **Generalist Approach** - Product features + infrastructure + speaking
5. **Scale Experience** - Twitter (millions DAUs), Etsy marketplace
6. **Public Knowledge Sharing** - Multiple talks, blog, open source

---

## Metrics to Highlight

| Achievement | Metric |
|-------------|--------|
| M&S build times | 50%+ reduction |
| Etsy coroutine errors | ~5% reduction |
| Twitter scale | Millions of DAUs |
| Guardian tenure | ~4 years, tech lead |
| Public talks | 6+ conference/meetup appearances |

---

## Why Anthropic

Jordan's interest in Anthropic is driven by multiple factors:
1. **AI/Safety Interest** - Genuine interest in AI safety mission
2. **Product Focus** - Wants to build user-facing products
3. **Technical Challenge** - Excited by the technical problems

---

## Still Needed

- [ ] Etsy search metrics (conversion, CTR, latency improvements)
- [ ] Specific Twitter Blue features shipped
- [ ] M&S deployment frequency improvements
- [ ] Guardian subscription impact metrics
