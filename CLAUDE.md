# CLAUDE.md — Kaizen Solutions Notebooks Website

This file is automatically loaded by Claude Code at the start of every session. It is the single source of truth for brand, copy, technical, and design context. **Always read this file fully before acting on any session prompt.**

---

## 1. Project Overview

- **Project:** Marketing website for Kaizen Solutions Notebooks.
- **Stack:** Flutter (Web target). Built with Flutter Web; deployed as a static site.
- **Audience:** School decision-makers — principals, administrators, directors of CBSE schools in India.
- **Goal of the site:** Build trust and drive one action — requesting a tailored proposal. No online commerce. No pricing shown.
- **Tone to hit:** Premium, editorial, warm, confident, teacher-to-teacher. NOT childish. NOT a generic SaaS landing page.

## 2. Brand Identity

### Company
- **Name:** Kaizen Solutions Notebooks
- **Division:** Educational Innovations Division
- **Tagline:** *Capture Learning. Create Progress.*
- **Philosophy:** Kaizen — the Japanese principle of continuous, incremental improvement. Every page, a small step forward.
- **Positioning:** A hybrid learning tool that merges curriculum-aligned content, visual summaries, attainment targets, and structured note-taking into a single notebook. Class-specific, subject-specific, CBSE-aligned.

### Logo
- File path: `assets/images/kaizen_logo.png`
- Imagery: Sun rising over mountains above an open book, inside a yellow circle.
- Symbolism: Knowledge ascending daily — the Kaizen principle visualised.

### Color Palette (defined in `lib/core/theme/app_colors.dart`)
| Token | Hex | Usage |
|---|---|---|
| `kaizenGold` | `#FFC72C` | Primary accent, CTAs, highlights |
| `kaizenGoldDeep` | `#F5B800` | Hover states, pressed buttons |
| `kaizenBlue` | `#1A3AE0` | Secondary accent, links, ink elements |
| `kaizenBlueDeep` | `#0F2494` | Deep blue bands, pull-quotes |
| `kaizenInk` | `#0B0B0F` | Primary text |
| `kaizenCream` | `#FAFAF7` | Page background |
| `kaizenPaper` | `#F4EFE4` | Card / section backgrounds |
| `kaizenMuted` | `#6B6B73` | Secondary text, captions |

### Typography (via `google_fonts`, defined in `lib/core/theme/app_typography.dart`)
- **Display / Headings:** **Fraunces** — a warm, editorial serif with optical sizing. Weights 500–800. Use italic for pull-quotes and emphasis.
- **Body / UI:** **Inter Tight** — weights 400–600. Tighter than Inter; characterful while legible.
- **Line-heights:** display 1.05, headings 1.15, body 1.6.
- **Max reading width:** 720px for body paragraphs.
- **Never use:** Inter, Roboto, Arial, or system defaults. Fraunces + Inter Tight only.

### Spacing (defined in `lib/core/theme/app_spacing.dart`)
- 8pt scale: `s4, s8, s12, s16, s24, s32, s48, s64, s96, s128`.
- `maxContentWidth = 1280`
- `maxReadingWidth = 720`

## 3. Contact Information (use everywhere it's relevant)

- **Address:** KPHB Colony, Hyderabad, India – 500072
- **Email:** thekaizensolutions.hyd@gmail.com
- **Phone 1:** +91 9989828388
- **Phone 2:** +91 8686960105
- **Office Hours:** Mon–Sat · 10:00 AM – 6:00 PM IST
- All email and phone instances must be tap-to-action via `url_launcher`.

## 4. Founder Context (for the Our Story page)

- The founder is a woman with **25+ years of teaching and school-administrative experience** across India.
- She designed the Kaizen Notebook out of decades of classroom observation — watching the gap between *content* and *practice* widen in Indian schools.
- She is affiliated with the **Educational Innovations Division** of Kaizen Solutions.
- **IMPORTANT:** Do **not** invent a name for the founder. Leave a clear `// TODO: founder name` comment in the relevant widgets. The project owner will fill this in.
- Founder photo: not yet provided. Use a gold circle with an ink Fraunces initial "S" as placeholder at `assets/images/founder.jpg` (add a TODO to swap).

## 5. Product Facts (treat as authoritative)

- **What it is:** A single notebook per class and subject. First section = curriculum-aligned concept content (chapter overviews, mind maps, diagrams, quick summaries, attainment targets, "Food for Thought" prompts). Second section = high-quality ruled writing pages.
- **Curriculum alignment:** CBSE, by class and subject.
- **Customisation schools can choose:**
  - **Paper:** 70 GSM (Standard), 80 GSM (Premium), 100 GSM (Luxury), eco-friendly recycled (optional). All no-bleed, smooth, durable.
  - **Size:** Kaizen Standard 24cm × 18cm, Long Book, Medium Book, or custom.
  - **Page count:** Standard 150 pages; custom counts available. Ruled, blank or grid options.
  - **Subject bifurcations:** Science → Physics/Chemistry/Biology OR Physical Science + Biology; Social Studies → History/Geography/Civics & Economics; English → Grammar/Creative Writing; Term-wise bifurcations.
  - **Branding:** School-branded covers and custom templates.
- **Delivery model:** Sold directly to schools. Production begins after advance payment. Delivered to school premises.

## 6. Pedagogical Principles (for the Why It Works page — use exact framing)

1. **Constructivist Learning** — students build knowledge by connecting new ideas to prior knowledge.
2. **Dual Coding (Visual + Verbal)** — memory strengthens when info is encoded both visually and verbally.
3. **Cognitive Load & Scaffolding** — complex material must be broken into age-appropriate pieces.
4. **Retrieval Practice & Spacing** — retrieval and revisiting beat passive re-reading.
5. **Metacognition & Transparent Goals** — learners perform better when they know the target.

Every principle must be paired with a *"How we applied it on the page"* explanation. No pop-psych language.

## 7. Hard Copywriting Rules

- **No pricing anywhere on the site.** Schools request a tailored proposal to get a quote.
- **No invented claims, statistics, testimonials, or client names.** If a section would need a real customer story, leave a clear `// TODO: real testimonial` comment — do not fabricate.
- **No invented founder biography beyond the facts above.** 25+ years teaching and administrative experience is the only factual claim to make.
- **Tagline capitalisation:** *Capture Learning. Create Progress.* — always exactly this.
- **Brand name capitalisation:** *Kaizen Solutions Notebooks* (plural "Notebooks"). *Kaizen Solutions* is acceptable as the shorter form.
- **CBSE** is always uppercase.
- **"Kaizen"** stays capitalised when referring to the brand; lowercase when referring to the philosophy is acceptable if paired with context (e.g. "a kaizen approach to learning"), but prefer capitalised for consistency.

## 8. Technical Conventions

- **Routing:** `go_router`. Routes defined in `lib/core/router/app_router.dart`.
- **Folder structure:**
  ```
  lib/
    main.dart
    app.dart
    core/{theme,router,responsive}/
    features/{home,about,product,psychology,customisation,contact}/
    shared/widgets/
  ```
- **Responsive breakpoints:** mobile `< 640`, tablet `640–1024`, desktop `> 1024`.
- **Every page** is rendered inside a shared `SiteScaffold` widget that injects the global `NavBar` and `Footer` and exposes a scroll controller.
- **Animations:** Prefer Flutter-native (`AnimationController`, `AnimatedOpacity`, `AnimatedSlide`, `visibility_detector`). Respect `MediaQuery.disableAnimations` (reduced-motion preference).
- **Icons:** Material `Icons` are acceptable for now. No icon libraries.
- **Images:** All assets live under `assets/images/` and are declared in `pubspec.yaml`.
- **External packages (approved):** `google_fonts`, `go_router`, `url_launcher`, `flutter_svg`, `visibility_detector`. Do not add others without asking.
- **No backend.** The contact form uses `mailto:` via `url_launcher`. Leave a `// TODO: replace mailto with real backend` comment.

## 9. Accessibility & Quality Bar

- All interactive elements ≥ 44×44 tap target.
- Visible focus rings (gold outline) on all interactive elements.
- Color contrast: on gold backgrounds, use `kaizenInk` for text (not `kaizenBlue`).
- Every image must have a semantic label.
- After every session: `flutter analyze` must be clean. No warnings, no unused imports.

## 10. Working Rhythm

- Work in **numbered sessions** defined in `kaizen_claude_code_prompts.md` (or provided by the user).
- At the start of each session: read this file + read the session prompt fully before writing code.
- At the end of each session:
  1. Run `flutter analyze` — must be clean.
  2. Briefly summarise what was built.
  3. List any TODOs introduced.
  4. Do not begin the next session until the user explicitly says to.
- Do not over-reach. If a prompt asks for Session N, build only Session N.

## 11. Do Nots

- Do not use generic SaaS / "AI purple gradient" aesthetics.
- Do not use Inter, Roboto, or system fonts. Fraunces + Inter Tight only.
- Do not invent founder names, student testimonials, school partners, or statistics.
- Do not introduce pricing anywhere on the site.
- Do not install packages outside the approved list without asking.
- Do not produce childish / cartoonish visuals. The audience is adult educators.
- Do not skip the `flutter analyze` clean check at the end of a session.
