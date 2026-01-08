# Portfolio Integration Spec

A vision document for deeply integrating blog content with professional identity, inspired by Microsoft Research, academic portfolios, and prominent developer personal sites.

---

## The Core Insight

**Your portfolio should be a graph, not a list.** Everything connects. One piece of work should lead naturally to others. The whole becomes greater than the parts.

---

## Reference Models

### Microsoft Research / Academic Model

MSR researcher pages show interconnected **artifacts**. A single research project might have:
- Paper (PDF)
- Code repository
- Dataset
- Blog post (accessible explanation)
- Talk recording
- Demo/interactive version
- Press coverage
- Citations showing impact

Everything cross-links. The paper links to the code, the blog explains the paper, the talk demos the code. One piece of work, multiple entry points for different audiences.

### Notable Developer Portfolios

**Julia Evans** (jvns.ca) - Treats learning as content. Zines, blog posts, and talks explore the same topics at different depths. A tweet becomes a blog post becomes a zine becomes a talk. Built a brand around "making hard things understandable."

**Lea Verou** (lea.verou.me) - Academic researcher + web developer. Shows: research papers, W3C spec work, talks, tools. Each piece of work is a **project page**, not just a blog post. CSS tools link to talks explaining them, which link to specs she helped write.

**Dan Abramov** (overreacted.io) - Long-form essays building mental models. Posts explain *why*, not just *how*. Each post stands alone but together they form a coherent philosophy.

**Patrick McKenzie** (patio11/kalzumeus) - Essays that reference each other over years, building a worldview. Traces how thinking evolved. Links back to old posts and reflects on what changed.

**Sindre Sorhus** - GitHub IS the portfolio. 1000+ packages. Volume and consistency tells the story.

---

## Key Patterns

### 1. One Idea, Multiple Formats
Tweet → blog post → talk → book chapter. Same insight, different depths. Not creating new content - *repackaging* for different contexts.

### 2. Project Pages, Not Just Posts
Significant work gets a dedicated landing page with:
- Problem statement
- Approach
- Outcomes
- Artifacts (code, slides, posts)
- Future work

Like a mini research paper.

### 3. Themes Over Chronology
Group work by research area, not just date. Natural themes might include:
- Build systems
- Modularization
- Developer productivity

A theme page collects all related talks, posts, and projects.

### 4. Visible Evolution
Show how thinking changed. "What I believed about modularization in 2019 vs 2024." Authentic content from lived experience.

### 5. Evidence-Based Claims
Skills backed by proof. Not "Expert in Gradle" but:
- Gradle: [3 talks] [5 posts] [2 tools] [used at 4 companies]

### 6. The "Lab" Framing
Present as a one-person research practice with ongoing areas of investigation:
- Current research interests
- Open questions
- Work in progress

---

## Proposed Site Structure

### Research Areas Section
```
/research/build-systems/
  - Overview of thinking in this area
  - Timeline of related work (posts, talks, projects)
  - Open questions being explored
  - Resources and influences
```

### Artifact Pages (Enhanced Talk/Project Pages)
```
/work/reusable-modules-abi/
  - Abstract (what's this about)
  - The slides (embedded)
  - Video recording (embedded)
  - Transcript or long-form written version
  - Related talks/posts
  - Where presented (with links)
  - Impact (views, feedback, follow-up invitations)
```

### Working Notes
Raw, dated thinking - problems being wrestled with, half-formed ideas. Shows process, not just polished output. Can later become talks or posts.

### Influence Map
Visual or textual representation of how work connects:
> "This talk at Droidcon led to this blog post, which I expanded into this talk at Android NYC, which led to this open source tool."

### "What I Learned At" Series
Each job gets a retrospective page. Not a resume entry - a reflection:
- What was built
- What was learned
- What would be done differently
- How it shaped the next move

### Reading/Influences Page
Books, papers, talks by others that shaped thinking. Grouped by theme. Content through curation.

---

## Content Backfill Ideas

Legitimate ways to surface existing experience:

### Resurface Existing Work
- **Talk expansions**: Behind-the-scenes posts for each talk
- **Slides to posts**: Convert decks into written articles
- **Conference notes**: What was learned at conferences attended

### Retrospective Content
- **Job retrospectives**: Reflections on each role
- **Project deep-dives**: Significant projects shipped
- **Career decision posts**: Why joined/left each company

### Learning Journeys
- **Technology retrospectives**: "How I learned Kotlin"
- **Book/resource reviews**: Technical books that shaped thinking
- **Failure posts**: Things that didn't work, lessons learned

### Evergreen Content
- **TIL (Today I Learned)**: Short posts about discoveries
- **Opinion pieces**: Takes on architecture, testing, build systems

### Non-Tech Categories
- **Flying milestones**: First solo, checkrides, memorable flights
- **Race reports**: Ultras, triathlons, training insights

---

## Technical Implementation Ideas

### Current State
- Blog posts in "Talks" category → Resume publications
- Blog posts in "Projects" category → Resume projects
- Resume generated at build time via JSON Resume CLI

### Future Enhancements

**Work Experience ↔ Blog Posts**
- Tag posts with company they were written during
- Resume shows "Related writing" under each job
- Auto-generate highlights from post content

**Skills Evidence**
- Link skills to blog posts demonstrating them
- "Kotlin - [5 posts]" with links

**Achievements Category**
- Posts about certifications, milestones
- Auto-populate achievements section

**Timeline View**
- Single chronological page combining jobs, talks, projects, posts
- Visual professional journey

**GitHub Integration**
- Auto-import pinned repos as projects
- Show contribution activity

**API Integrations**
- Pull Speakerdeck metadata directly
- YouTube view counts for talks

**PDF Export**
- Generate printable resume from same data at build time

---

## Implementation Phases

### Phase 1: Content Structure
- [ ] Create research area pages
- [ ] Enhance talk posts to artifact pages
- [ ] Add working notes section

### Phase 2: Cross-Linking
- [ ] Tag posts by theme/research area
- [ ] Tag posts by company/time period
- [ ] Build related content suggestions

### Phase 3: Resume Integration
- [ ] Skills with evidence links
- [ ] Job entries with related posts
- [ ] Timeline view

### Phase 4: External Data
- [ ] GitHub integration
- [ ] Speakerdeck/YouTube APIs
- [ ] Impact metrics

---

## Open Questions

- How to balance comprehensiveness with maintainability?
- What's the minimum viable version that adds value?
- How to handle content that spans multiple themes?
- Should the resume be the hub, or just one view of the data?
