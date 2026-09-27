---
title: 'App typography works without Google Fonts network access'
type: 'bugfix'
ticket: 2
created: '2026-09-27'
status: blocked
baseline_revision: '97d3477c72f84d1dd71ca0bcdab217d92e4ba452'
route: 'full'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
blocked_at: "2026-09-27"
blocked_reason: "implementation verification failed: Flutter Web requests hosted Roboto/Noto fallback fonts offline; cold-offline matrix test cannot pass"
---

<intent-contract>

## Intent

**Problem:** Fresh Chrome and macOS installs cannot reliably display the app's intended Fredoka, Nunito, JetBrains Mono, and Roboto Mono typography offline. Google Fonts attempts runtime downloads because the app declares no font assets; tests disable downloads but do not check the bundled faces.

**Approach:** Bundle licensed, correctly named static font variants and disable runtime fetching in the app. Verify each asset independently of machine caches, exercise bilingual screens at compact and wide sizes, and record platform-specific offline evidence.

## Boundaries & Constraints

**Always:** Preserve existing GoogleFonts style calls and language behavior, include required weights used across the app, register the bundled OFL license texts, and prevent missing assets from passing through a warm font cache.

**Never:** Substitute system fonts, rely on hosted fonts or remote validation, or modify lesson progress or language selection.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|---------------|---------------------------|----------------|
| Cold offline | Empty font cache, network blocked, app started in Chrome/macOS | Home, profile, lesson render intended faces in English and Dutch | No font fetch/error |
| Missing face | Asset absent or manifest entry broken, machine cache warm | Font check fails with missing family/weight/path | Diagnostic names face |
| Layout | Compact and wide viewport, both languages | Text remains legible inside controls | Overflow is a test failure |

</intent-contract>

## Code Map

- `lib/core/theme/app_theme.dart` and `lib/screens/**`, `lib/widgets/**` -- GoogleFonts style calls for four families; keep styles unchanged, enumerate actually used weights.
- `lib/main.dart` -- startup location to disable runtime font fetching and register license assets.
- `pubspec.yaml`, `assets/fonts/` -- font asset directory absent; bundle static variants as assets, not `fonts:` (google_fonts matches file names from AssetManifest).
- `test/widget_test.dart` -- existing bilingual home/profile/lesson test; add cache-independent asset and loaded-font checks with fetching off.
- `web/index.html`, `macos/Runner/*.entitlements` -- platform evidence only; avoid network-specific workarounds.
- `_bmad-output/backlog/story-fonts-work-offline.md` -- acceptance contract; do not edit ticket.

## Tasks & Acceptance

**Execution:**
- [ ] `assets/fonts/`, `pubspec.yaml` -- obtain official OFL variable sources and license files; generate static weight files with fonttools and GoogleFonts-compatible names, declare asset directory and preserve source/provenance.
- [ ] `lib/main.dart` -- turn off fetching before theme initialization and register license text with Flutter's license registry.
- [ ] `test/widget_test.dart` -- assert each required asset is listed and loadable, await GoogleFonts.pendingFonts with fetching disabled, and test English/Dutch home, profile, lesson in compact/wide viewports.
- [ ] `_bmad-output/backlog/story-fonts-work-offline-plan.md` -- record reproducible cold-cache Chrome/macOS diagnosis, offline runs, and any environment limitations in Implementation Notes.

**Acceptance Criteria:**
- Given an empty local font cache and blocked font servers, when Chrome and macOS start, then both render intended faces on English/Dutch home, profile, lesson without runtime font fetches or substitutions.
- Given a missing or malformed bundled font file, when automated font and visual checks run on a machine with cached fonts, then a diagnostic identifies the missing family, weight, and asset path.
- Given compact and wide viewports in both languages, when those screens render offline, then labels fit their controls and typography stays consistent with the existing appearance.

## Implementation Notes

- Bundled 17 static Fredoka, Nunito, JetBrains Mono, and Roboto Mono weights from official OFL variable sources in `assets/fonts/`; registered licenses and disabled `GoogleFonts` runtime fetches in `lib/main.dart`. Asset-manifest, font-byte/weight, and bilingual compact/wide widget checks passed (19 tests); `flutter analyze` and `flutter build web` passed. macOS app hot restart succeeded with no DTD runtime errors.
- Browser reproduction: on the default Chrome web build at `http://localhost:8765/#/profiles`, blocking `fonts.gstatic.com` produced failed Roboto, Noto Sans Symbols 2, and Noto Color Emoji WOFF2 requests and Flutter Web fallback warnings, even with the four app font families bundled. A subsequent `flutter build web --no-web-resources-cdn` served Roboto from a local asset and made no new intercepted host requests during one reload, but a fresh-cache end-to-end Chrome run, the macOS offline run, and the platform-level matrix test remain unverified. The default web build still has an engine fallback dependency.
- Other ticket and initiative files changed concurrently; they were left untouched and excluded from the staged offline-font diff.

## Plan Change Log

## Review Triage Log

## Design Notes

google_fonts 6.x first searches bundled asset filenames (`Family-Weight.ttf`), then disk cache, then HTTP; disabling HTTP alone still permits a silent cached-font pass. Assert the asset manifest and bytes independently. The official google/fonts `ofl/{fredoka,nunito,jetbrainsmono,robotomono}` directories contain variable fonts and OFL.txt, not ready-made static variants; use fonttools to instantiate only weights actually requested.

## Verification

**Commands:**
- `flutter test test/widget_test.dart` -- bundled faces load with runtime fetching disabled and bilingual layouts do not overflow.
- `flutter analyze` -- no diagnostics introduced by font configuration or tests.
- `flutter build web` -- all declared fonts ship in the web bundle.
- Offline Chrome and macOS launches from clean browser/app font caches -- record any failed font requests, rendered faces, and compact/wide screenshots; if unavailable, state that limitation explicitly.

## Auto Run Result

Previous attempt blocked by an untracked render directory; the tree was clean before this planning pass.

Status: blocked pending offline Flutter Web fallback fonts. Browser verification and the cold-offline matrix row fail while the engine requests hosted Roboto/Noto fallback assets.
