---
id: 1
type: story
title: "An agent validates Flutter changes with fast, reliable visual feedback"
parent: none
covers: []
after: [2]
assignee: ""
refined: false
hitl: true
risk: medium
estimate: ""
---

# An agent validates Flutter changes with fast, reliable visual feedback

## Description

An agent can run one local validation entry point in fast post-edit or final review mode and get trustworthy feedback on behavior, layout, and runtime health. Chrome provides the quick visual smoke target, with the macOS app reserved for desktop-specific checks. The entry point reports what passed, what was not run, elapsed time, and where to inspect differences; a person approves the initial visual reference once.

## Acceptance Criteria

1. **Fast focused loop**
   **Given** a warm local checkout and a changed screen or behavior
   **When** an agent runs fast mode for that screen
   **Then** its focused behavior and visual checks run without waiting for the full suite, report elapsed time and failures, and warn if a warm one-screen check exceeds 15 seconds
   **And** it can reuse an already running Chrome session for a screen capture without rebuilding the app
   **And** a compile failure, zero discovered tests, or an unavailable required check fails the mode instead of reporting a pass.
2. **Offline visual regression**
   **Given** approved references for the existing English design and its Dutch counterpart at compact and wide viewports
   **When** a screen loses its mascot, activity cards, emoji, profile controls, or intended layout
   **Then** an unattended visual check fails with inspectable actual, expected, and difference images
   **And** fonts and other assets needed for those checks load without network access.
3. **User journey and persistence**
   **Given** a child profile with previously saved English progress
   **When** automated validation switches to Dutch, returns home, finishes the supported lesson, game, and story, changes profile, and restarts
   **Then** the visible route and stored results match the selected language, while English progress and course access remain intact.
4. **Runtime smoke and honest fallback**
   **Given** a local Chrome target is configured for validation
   **When** the agent applies Dart changes and runs final mode
   **Then** if Chrome is reachable, the app is hot restarted, inspected for browser and Flutter exceptions, and captured at compact and wide viewports without a human navigating it
   **And** unavailable browser access or capture is marked blocked, never passed, while deterministic widget and visual checks still run.
5. **Repeatable final gate**
   **Given** a change is ready for review
   **When** the agent runs final mode locally
   **Then** analysis, the full test suite, and visual checks must pass; the summary distinguishes passed, failed, skipped, and blocked checks
   **And** blocked Chrome smoke is reported as incomplete rather than silently counted as a fully verified run.

## Boundaries

- Must not change: lesson scoring, English course selection or saves, existing app navigation, or approved English styling.
- Reference images are updated only through a deliberate review step, never automatically when a comparison fails.
- Chrome validation cannot stand in for macOS-only keyboard behavior or hardware-specific rendering; report those as separate manual checks when relevant. No CI host or remote service is required.
- Physical Netherlands QWERTY punctuation and dead-key checks remain human validation; automated checks must not claim to verify hardware behavior.

## References

- existing run instructions — README.md, Run on your current platform
- current home appearance — screenshots/home_screen.png

## Notes

- Evidence: this session passed 44 widget/unit tests and analysis in seconds yet lost the Dutch home layout until a human opened it; 23 test calls followed in a 35-minute repair window. The sandboxed macOS run built and hot restarted, but Google Fonts downloads failed and the device connection was lost.
- Risk: shared test assets and Chrome rendering can vary between local machines; pin the browser/renderer used for references and report environment-specific differences.
- Assumption: 15 seconds is a warm local target for one focused screen; report real elapsed times rather than hiding slower machines or first builds.
- Assumption: a one-time human review of visual references is acceptable; every subsequent comparison and failure report is autonomous.
- Assumption: the screen references cover the home and profile pickers in both languages at the existing 800x600 test viewport and a wider desktop viewport; the builder selects a stable comparison tolerance with the reference reviewer.
- Decision: all development and validation stay local; use Chrome for fast visual feedback, with native checks only where browser behavior is not equivalent (2026-09-27).
- Open question: settle the local Chrome version and image comparison tolerance with the initial reference reviewer when the story is refined.