---
id: 2
type: story
title: "App typography works without Google Fonts network access"
parent: none
covers: []
after: []
assignee: ""
refined: false
hitl: false
risk: medium
estimate: ""
---

# App typography works without Google Fonts network access

## Description

Investigate the failed Google Fonts requests seen during a local macOS run and remove any runtime network dependency needed to display the app's intended typography. Establish whether the failure affects Chrome, macOS, and fresh offline installs; preserve the existing English and Dutch appearance while making font failures visible to automated checks.

## Acceptance Criteria

1. **Cause is established**
   **Given** a fresh local font cache and blocked access to font servers
   **When** the app starts on Chrome and macOS
   **Then** the investigation records whether the font failure is caused by a runtime fetch, a missing asset, or an environment-only restriction, with reproducible evidence for each platform.
2. **Intended fonts work offline**
   **Given** a fresh install with no cached fonts and no network access
   **When** the home, profile, and lesson screens render in English and Dutch
   **Then** their intended text styles render without font download errors or silent substitution.
3. **Regression is detected**
   **Given** the local font assets or their configuration are missing or broken
   **When** the automated font and visual checks run
   **Then** the checks fail with a diagnostic that identifies the missing font, and do not pass only because a machine has cached fonts.
4. **Appearance is preserved**
   **Given** the existing English and Dutch screens
   **When** the offline font solution is applied
   **Then** text remains readable and fits its controls at compact and wide sizes without an unintended change in typography or layout.

## Boundaries

- Must not change: language selection, lesson progress, or the intended typography of either language.
- Check font licensing before bundling assets; do not require a hosted font service or remote validation.
- If investigation proves there is no app defect, record the reproduction and evidence for that conclusion before closing the ticket without a code change.

## References

- related validation requirement — _bmad-output/backlog/story-fast-autonomous-flutter-validation.md, Acceptance Criteria 2
- current home appearance — screenshots/home_screen.png

## Notes

- Evidence: a sandboxed macOS run attempted Google Fonts downloads and failed; the app uses Google Fonts for its theme, widget tests disable runtime fetching, and no font files are declared as Flutter assets.
- Risk: shared font configuration affects every screen and may pass on a machine with warm caches; repeat checks from an empty cache in both local targets.
- Open question: confirm the exact failure mechanism on each platform before choosing whether to bundle fonts or use another offline-safe approach.