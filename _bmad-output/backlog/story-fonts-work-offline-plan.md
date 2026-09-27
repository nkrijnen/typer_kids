---
title: 'App typography works without Google Fonts network access'
type: 'bugfix'
ticket: 2
created: '2026-09-27'
status: done
baseline_revision: '97d3477c72f84d1dd71ca0bcdab217d92e4ba452'
route: 'full'
route_source: 'auto'
review: 'thorough'
review_source: 'auto'
lenses_ran: ['blind-hunter', 'edge-case-hunter', 'verification-gap', 'intent-alignment']
review_loop_iteration: 1
followup_review_recommended: false
context: []
warnings: []
deferred:
	- 'Automate the release-browser request matrix if it becomes a recurring release gate.'
	- 'Add a generated immutable manifest for all upstream font assets as supply-chain hardening.'
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
- [x] `assets/fonts/`, `pubspec.yaml` -- obtain official OFL variable sources and license files; generate static weight files with fonttools and GoogleFonts-compatible names, declare asset directory and preserve source/provenance.
- [x] `lib/main.dart` -- turn off fetching before theme initialization and register license text with Flutter's license registry.
- [x] `test/widget_test.dart` -- assert each required asset is listed and loadable, await GoogleFonts.pendingFonts with fetching disabled, and test English/Dutch home, profile, lesson in compact/wide viewports.
- [x] `_bmad-output/backlog/story-fonts-work-offline-plan.md` -- record reproducible cold-cache Chrome/macOS diagnosis, offline runs, and any environment limitations in Implementation Notes.

**Acceptance Criteria:**
- Given an empty local font cache and blocked font servers, when Chrome and macOS start, then both render intended faces on English/Dutch home, profile, lesson without runtime font fetches or substitutions.
- Given a missing or malformed bundled font file, when automated font and visual checks run on a machine with cached fonts, then a diagnostic identifies the missing family, weight, and asset path.
- Given compact and wide viewports in both languages, when those screens render offline, then labels fit their controls and typography stays consistent with the existing appearance.

## Implementation Notes

- Bundled 18 static Fredoka, Nunito, JetBrains Mono, and Roboto Mono faces from official OFL sources in `assets/fonts/`; registered licenses and disabled `GoogleFonts` runtime fetches in `lib/main.dart`. Asset-manifest, font-byte/weight, and bilingual compact/wide widget checks passed (19 tests); `flutter analyze` and the self-contained web build passed.
- Browser reproduction: on the default Chrome web build at `http://localhost:8765/#/profiles`, blocking `fonts.gstatic.com` produced failed Roboto, Noto Sans Symbols 2, and Noto Color Emoji WOFF2 requests and Flutter Web fallback warnings, even with the four app font families bundled. A subsequent `flutter build web --no-web-resources-cdn` served Roboto from a local asset and made no new intercepted host requests during one reload, but a fresh-cache end-to-end Chrome run, the macOS offline run, and the platform-level matrix test remain unverified. The default web build still has an engine fallback dependency.
- Other ticket and initiative files changed concurrently; they were left untouched and excluded from the staged offline-font diff.
- Corrected the engine-level fallback by setting `fontFallbackBaseUrl` in a custom web bootstrap and bundling all 12 official Noto Color Emoji plus six Noto Sans Symbols 2 WOFF2 subsets at Flutter's expected paths. Fresh Chromium cache reloads of home, profiles, lessons, sandbox, and games made 20, 17, 15, 20, and 19 requests respectively; every request was local, with no failed requests, HTTP errors, warnings, or page errors. The macOS debug app built and hot restarted in 283 ms without runtime output errors; DTD did not discover the terminal-launched app, and native network blocking remained unavailable in the sandbox.

## Plan Change Log

- Review iteration 1 added the reachable Nunito italic face and Noto Sans Symbols 2 subsets, made compact home rows resilient during cold font loading, and removed redundant variation selectors that Flutter reported as unsupported despite local base-glyph coverage.

## Review Triage Log

| Lens | Finding | Verdict | Route / action |
|------|---------|---------|----------------|
| Blind Hunter | Story is `in-review` although native network-block proof is unavailable. | Rejected | `in-review` is the required review state; the Verification section explicitly permits recording unavailable platform evidence. |
| Blind Hunter | The platform-evidence task is checked despite the native limitation. | Rejected | The task requires evidence *and limitations* to be recorded, which was done. |
| Blind Hunter | Notes claim no DTD runtime errors although DTD did not attach. | Confirmed | Patch the note to claim only observed process output. |
| Blind Hunter | Browser evidence covers only the profiles route. | Confirmed | Patch evidence by cold-reloading the reachable home, profiles, lessons, sandbox, and games routes. |
| Blind Hunter | Offline widget tests do not intercept networking. | Rejected | Runtime fetching is asserted disabled and every requested app-font asset is independently checked, so a missing asset cannot be hidden by HTTP or a warm cache. |
| Blind Hunter | Rendered-family assertions cover only Fredoka. | Confirmed | Patch focused style assertions for the other requested app families. |
| Blind Hunter | TTF checks do not prove names, glyph coverage, or immutable hashes. | Rejected | The checks parse each file and verify its expected weight; name tables and full glyph coverage are beyond the frozen missing-face acceptance criterion. |
| Blind Hunter | WOFF2 checks do not decode files or prove Unicode ranges. | Confirmed | Patch the reachable release-route browser evidence; defer a general WOFF2 parser because the fallback files are Flutter-version-owned and browser decoding is authoritative for this ticket. |
| Blind Hunter | There is no automated release-bundle network test. | Confirmed | No patch; the frozen verification plan requires a recorded cold-cache browser run, not browser automation in the repository. |
| Blind Hunter | Font provenance lacks immutable hashes and a reproduction script. | Confirmed | Defer as supply-chain hardening outside this ticket's frozen runtime acceptance. |
| Blind Hunter | License registry behavior is untested. | Confirmed | Patch a focused registry assertion for all bundled OFL families. |
| Edge Case Hunter | Reachable sandbox text requests missing `Nunito-Italic.ttf`. | Confirmed | Patch the official w400 italic asset and required-face test matrix. |
| Edge Case Hunter | The local fallback base can 404 for reachable non-emoji glyphs. | Confirmed | Browser reproduction found a 404 for Noto Sans Symbols 2 subset 3 on `/games`; patch the six engine-defined subsets. |
| Edge Case Hunter | The correctly-named-variants claim is false while Nunito italic is absent. | Confirmed duplicate | Covered by the Nunito italic patch. |
| Verification Gap | The startup fetch-policy test sets fetching false before invoking `main()`. | Confirmed | Patch the test to start from `true`, invoke `main()`, then assert `false`. |
| Verification Gap | Bootstrap fallback routing has no automated runtime verification. | Confirmed | No repository patch; verify the generated bootstrap URL and cold-cache route requests in the required browser run. |
| Intent Alignment | Automated checks operate below the deployed runtime. | Confirmed limitation | The required release-browser and macOS launch evidence complement the asset/widget tests. |
| Intent Alignment | Browser proof covers only one route. | Confirmed duplicate | Covered by the route-matrix browser evidence patch. |
| Intent Alignment | Native network blocking and substitution proof remain unavailable. | Confirmed limitation | Preserve the explicit sandbox limitation; native startup and local asset checks remain required. |

Resolution: all patch-routed findings are fixed and reverified. No blocking review findings remain; the two deferred hardening items do not change the frozen acceptance contract.

## Design Notes

google_fonts 6.x first searches bundled asset filenames (`Family-Weight.ttf`), then disk cache, then HTTP; disabling HTTP alone still permits a silent cached-font pass. Assert the asset manifest and bytes independently. The official google/fonts `ofl/{fredoka,nunito,jetbrainsmono,robotomono}` directories contain variable fonts and OFL.txt, not ready-made static variants; use fonttools to instantiate only weights actually requested.

## Verification

**Commands:**
- `flutter test test/widget_test.dart` -- bundled faces load with runtime fetching disabled and bilingual layouts do not overflow.
- `flutter analyze` -- no diagnostics introduced by font configuration or tests.
- `flutter build web --no-web-resources-cdn` -- all declared fonts and engine fallback resources ship in the web bundle.
- Offline Chrome and macOS launches from clean browser/app font caches -- record any failed font requests, rendered faces, and compact/wide screenshots; if unavailable, state that limitation explicitly.

## Auto Run Result

Previous attempt blocked by an untracked render directory; the tree was clean before this planning pass.

Status: blocked pending offline Flutter Web fallback fonts. Browser verification and the cold-offline matrix row fail while the engine requests hosted Roboto/Noto fallback assets.

Current run: review passed after one patch iteration. The cold-cache five-route browser matrix made no external or failed requests and emitted no warnings; 19 tests, analysis, the self-contained web build, and a macOS hot restart all pass.
