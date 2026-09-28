---
id: SPEC-fast-autonomous-flutter-validation
companions:
  - validation-matrix.md
sources:
  - ../../backlog/story-fast-autonomous-flutter-validation.md
  - ../../../README.md
---

> **Canonical contract.** This SPEC and the files in `companions:` are the complete, preservation-validated contract for what to build, test, and validate. Source documents listed in frontmatter are for traceability; consult them only when narrative rationale omitted here is needed.

# Fast Autonomous Flutter Validation

## Why

Agents can pass Flutter analysis and unit or widget tests while breaking visible layout, and current runtime inspection can require slow human navigation or fail when network-hosted assets are unavailable. They need one truthful local validation entry point that makes focused feedback fast and final review comprehensive without hiding checks that could not run.

## Capabilities

- **CAP-1**
  - **intent:** An agent can run fast focused validation for a changed screen or behavior and receive behavior, visual, timing, and failure feedback.
  - **success:** Fast mode targets the requested scope, can capture from an already running Chrome session without rebuilding, reports elapsed time and failures, warns when a warm one-screen check exceeds 15 seconds, and fails on compilation failure, zero discovered tests, or an unavailable required check.
- **CAP-2**
  - **intent:** An unattended local check can detect visual regressions against approved English and Dutch references without network access.
  - **success:** Compact and wide comparisons detect missing mascot, activity cards, emoji, profile controls, or intended layout and retain inspectable actual, expected, and difference images while all required fonts and assets load offline.
- **CAP-3**
  - **intent:** Automated validation can prove that the supported Dutch user journey and persisted progress remain isolated from existing English data.
  - **success:** Starting with saved English progress, validation switches to Dutch, returns home, completes the supported lesson, game, and story, changes profile, restarts, and returns to English with language-correct visible and stored results, unchanged English progress, and intact course access.
- **CAP-4**
  - **intent:** Final validation can inspect a reachable local Chrome runtime without human navigation.
  - **success:** Final mode hot restarts Chrome, checks browser and Flutter exceptions, and captures compact and wide viewports; unavailable browser access or capture is reported as blocked while deterministic checks still run.
- **CAP-5**
  - **intent:** An agent can run a repeatable final gate and receive an honest summary of every selected check.
  - **success:** Analysis, the full test suite, and visual checks pass, and the summary distinguishes passed, failed, skipped, and blocked checks while treating blocked Chrome smoke as incomplete verification.

## Constraints

- Validation stays local and requires no CI host or remote service; fonts and test assets required by deterministic checks must load without network access.
- Chrome is the fast visual-smoke target; macOS remains necessary for desktop-specific behavior that Chrome cannot represent.
- The work must not change lesson scoring, English course selection or saves, existing navigation, or approved English styling.
- Approved image references change only through deliberate human review, never automatically after a mismatch.
- Unavailable required checks, browser access, or capture are blocked or failed as applicable and never reported as passed; compilation failure and zero discovered tests fail the selected mode.
- Physical Netherlands QWERTY punctuation and dead-key behavior remains human validation and cannot be claimed by automation.

## Non-goals

- Providing CI infrastructure or a remote visual-regression service.
- Replacing macOS-only or physical-keyboard validation with Chrome checks.
- Expanding or changing product behavior while creating the validation path.
- Automatically accepting changed visual references.

## Success signal

A developer or agent runs one local command after a Flutter edit and receives a focused result within the warm target or an explicit timing warning; at review time, the same entry point produces a complete final verdict with inspectable visual evidence and no unavailable required check disguised as success.

## Assumptions

- Fifteen seconds is the warning threshold for a warm focused one-screen check, not a first-build guarantee.
- Initial references cover the home and profile pickers in English and Dutch at 800 by 600 and a wider desktop viewport.
- One human approval of initial visual references is acceptable before subsequent comparisons run unattended.

## Open Questions

- Which local Chrome version is the pinned visual-reference renderer?
- What stable image-comparison tolerance will the initial reference reviewer approve?