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

### Testing & Compiler Verification
- Drove major improvement in testing practices
- Built compiler verification systems
- **Impact:** ~5% reduction in coroutine errors (continuation issues)
- Cross-platform influence: Helped iOS team with Swift 6 structured concurrency adoption
- Cultural impact: Changed how teams think about these issues

### MVI Architecture for Structured Concurrency
- Drove architectural proposal and implementation
- Modified MVI system to maintain structured concurrency
- Reduced race conditions and coroutine errors
- Hard to quantify but visible impact on code quality

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

### Public Speaking
- Droidcon London (M&S)
- Droidcon Lisbon (Twitter)
- Kotlin London
- Android NYC Meetup
- App Dev Nights Mexico City
- Etsy events (CDMX, NYC)

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

## Still Needed

- [ ] Etsy search metrics (conversion, CTR, latency improvements)
- [ ] Specific Twitter Blue features shipped
- [ ] M&S deployment frequency improvements
- [ ] Guardian subscription impact metrics
