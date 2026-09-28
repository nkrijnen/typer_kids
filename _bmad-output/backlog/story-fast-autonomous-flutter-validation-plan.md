---
title: 'An agent validates Flutter changes with fast, reliable visual feedback'
type: 'feature'
ticket: 1
created: '2026-09-28'
status: 'draft'
route: 'full'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Analysis and unit/widget tests can pass while visible Flutter layouts are broken, and runtime inspection currently depends on slow manual navigation or network-hosted resources. Agents need a truthful local entry point for focused feedback and a comprehensive final gate.

**Approach:** Add fast and final local validation modes, deterministic bilingual visual regression and persistence coverage, plus optional Chrome runtime smoke that reports unavailable checks as blocked. Preserve manual macOS and physical-keyboard validation where Chrome cannot represent the target behavior.

## Boundaries & Constraints

**Always:** Keep required assets offline; report elapsed time and each check as passed, failed, skipped, or blocked; fail on compilation failure, zero discovered tests, and unavailable required checks; never update references automatically; retain actual, expected, and difference images for comparison failures.

**Never:** Change lesson scoring, English course selection or saves, navigation, approved English styling, add CI/remote services, claim Chrome covers macOS-specific or physical Netherlands QWERTY behavior, or treat blocked Chrome smoke as a complete pass.

## Decisions

- Use the locally installed Chrome version as the pinned reference renderer; record its exact version with the approved references and validation results.
- Use a small documented image-comparison threshold, calibrated during initial human review to tolerate minor rasterization noise without accepting visible content or layout regressions.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Focused validation | Changed screen/behavior; warm checkout | Run scoped behavior and visual checks; report failures and duration; reuse reachable Chrome without rebuild; warn above 15 seconds for a warm one-screen run | Compilation failure, zero tests, or unavailable required check fails mode |
| Final validation | Review-ready change; Chrome reachable or unavailable | Run analysis, full suite, deterministic visuals; restart/inspect/capture Chrome when reachable; summarize all selected checks | Chrome access/capture is blocked; deterministic checks still run |
| Visual mismatch | English or Dutch home/profile at compact or wide viewport | Compare to human-approved reference | Fail and retain actual, expected, and diff; never replace baseline |
| Persistence journey | Existing English progress | Switch to Dutch; finish supported lesson, game, story; change profile; restart; return to English | Report visible/stored language mismatch or changed English progress as failure |

</frozen-after-approval>

## Parking Note

Park this work before implementation. The proposed visual, runtime, and persistence harness may over-constrain the app and make feature changes harder instead of providing quick feedback. The current validation flow is sufficient while other features are built. Revisit this plan after that work produces better evidence about which checks are valuable and how to keep them lightweight; do not treat this plan as authorization to build the harness now.

## Code Map

- `test/widget_test.dart` -- reuse real-app bilingual home/profile setup, offline font checks, and overflow assertions; add the contract's 800x600 and wide viewport captures/assertions.
- `test/visual_regression_test.dart` and `test/goldens/` -- add deterministic bilingual home/profile image checks with approved references and retained comparison artifacts.
- `test/features_test.dart` -- reuse provider and SharedPreferences patterns for language/profile-scoped saves; compose the specified lesson/game/story persistence journey without changing product behavior.
- `tool/validate.dart` -- new local fast/final CLI entry point; `tool/` currently contains Dart asset-generation utilities and has no validation runner.
- `lib/main.dart` and `lib/providers/{language_provider,profile_provider,progress_provider}.dart` -- app bootstrap and existing state APIs; tests should inject providers and avoid product-code changes unless an actual testability gap requires a narrowly justified seam.
- `pubspec.yaml`, `assets/fonts/`, `web/index.html`, and `screenshots/home_screen.png` -- existing offline fonts/fallback configuration and English home baseline; preserve them and add only deliberately reviewed references.
- `README.md` -- existing `flutter run` and self-contained `flutter build web --no-web-resources-cdn` instructions; document the local validation entry point here.
- `_bmad-output/specs/spec-fast-autonomous-flutter-validation/SPEC.md` and `validation-matrix.md` -- canonical acceptance contract, viewport/language coverage, outcomes, and platform boundaries.
- `_bmad-output/backlog/story-fonts-work-offline-plan.md` -- prerequisite evidence for network-independent assets, Flutter web fallback, and prior Chrome/macOS limitations.

## Tasks & Acceptance

**Execution:**
- [ ] Add `tool/validate.dart` -- implement fast/final mode selection, focused test targeting, check discovery/compilation gates, timing, per-check outcomes, and optional reuse of a reachable Chrome session without rebuilding.
- [ ] Add `test/visual_regression_test.dart` and `test/goldens/` -- exercise English/Dutch home and profile offline at compact 800x600 and wide viewports; compare against human-approved references with the agreed small threshold, never update baselines automatically, and retain actual/expected/diff evidence on mismatch.
- [ ] Extend `test/features_test.dart` -- validate the saved-English to Dutch lesson/game/story, profile change, restart, and return-to-English journey, including visible content, persisted results, English progress, and course access.
- [ ] Document the fast/final command and check semantics in `README.md` -- make local use and blocked/manual platform limitations explicit.
- [ ] Validate the entry point and update this plan's Verification/Implementation Notes -- record commands, outcomes, timing, browser environment, and unavailable checks accurately.

**Acceptance Criteria:**
- Given a warm checkout and changed screen/behavior, when fast mode runs, then only its required focused checks run, elapsed time/failures are reported, reuse of an existing Chrome session requires no rebuild, and a warm one-screen run over 15 seconds warns.
- Given a compile error, no discovered tests, or unavailable required check, when either applicable mode runs, then it fails rather than reporting success.
- Given approved English/Dutch home and profile references at compact and wide sizes, when expected content/layout regresses offline, then comparison fails with inspectable actual, expected, and diff images and does not alter references.
- Given approved references, when visual validation runs, then it records the locally installed Chrome version used to render them and reports renderer-version differences.
- Given saved English progress, when the Dutch journey and restart complete, then displayed and stored results follow the selected language while English progress and course access remain intact.
- Given final mode and reachable Chrome, when validation runs, then it restarts, checks browser/Flutter exceptions, and captures compact and wide screens; if Chrome access/capture is unavailable, that check is blocked and deterministic checks still run.
- Given a review-ready change, when final mode runs, then analysis, full tests, and deterministic visual checks must pass and the summary distinguishes passed, failed, skipped, and blocked; blocked Chrome smoke is incomplete verification.

## Implementation Notes

## Plan Change Log

## Review Triage Log

## Design Notes

Keep deterministic widget/screenshot checks independent from optional Chrome attachment so browser unavailability cannot suppress them. A blocked runtime smoke is an incomplete final result, not a pass; keep reference approval separate from normal comparisons.

## Verification

**Commands:**
- `flutter analyze` -- no diagnostics.
- `flutter test` -- all discovered tests pass; selected modes fail if discovery is empty.
- `flutter build web --no-web-resources-cdn` -- self-contained web build succeeds for local Chrome smoke.
- Documented fast command targeting home/profile -- reports elapsed time and all selected outcomes; warm one-screen threshold is 15 seconds.
- Documented final command -- analysis, complete test suite, and deterministic visuals pass; Chrome smoke is passed or explicitly blocked and reported incomplete.