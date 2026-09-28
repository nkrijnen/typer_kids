# Validation Matrix

This companion defines the required coverage and outcome semantics for `SPEC-fast-autonomous-flutter-validation`.

## Modes

| Mode | Required coverage | Runtime behavior | Completion rule |
|---|---|---|---|
| Fast | Focused behavior and visual checks for the requested screen or behavior | May reuse an already running Chrome session for capture without rebuilding | Report elapsed time and failures; warn above 15 seconds for a warm one-screen run; fail on compilation failure, zero discovered tests, or an unavailable required check |
| Final | Analysis, full test suite, deterministic visual checks, and Chrome runtime smoke | When Chrome is reachable, hot restart it, inspect browser and Flutter exceptions, and capture compact and wide viewports without human navigation | Required deterministic checks must pass; blocked Chrome smoke makes the result incomplete rather than passed |

## Outcome Semantics

Every selected check is reported as exactly one of `passed`, `failed`, `skipped`, or `blocked`. A required check that cannot run is `blocked` or `failed` as applicable, never `passed` or silently omitted. Browser unavailability must not prevent deterministic widget and visual checks from running.

## Visual Coverage

Initial approved references cover:

| Surface | Languages | Viewports | Regression signals |
|---|---|---|---|
| Home | English and Dutch | 800 by 600 and wider desktop | Mascot, activity cards, emoji, profile controls, and intended layout remain present |
| Profile picker | English and Dutch | 800 by 600 and wider desktop | Profile controls and intended layout remain present |

Each failed comparison retains actual, expected, and difference images. References are approved once by a person and are never updated automatically after a failure. The current home reference is [home_screen.png](../../../screenshots/home_screen.png); it shows the KidType identity, active profile control, mascot greeting, four activity choices, and footer shortcuts whose presence and layout are part of the visible baseline.

## Persistence Journey

The automated journey starts with a child profile containing saved English progress, then:

1. Switches to Dutch.
2. Returns to the home screen.
3. Completes the supported lesson, game, and story.
4. Changes profile.
5. Restarts the app.
6. Returns to English.

At each applicable step, visible content and stored results match the selected language. At completion, prior English progress and course access remain intact.

## Platform Boundaries

- Chrome provides fast visual feedback and runtime smoke.
- macOS remains the target for desktop-specific checks that are not browser-equivalent.
- Physical Netherlands QWERTY punctuation and dead-key output requires human validation.
- Existing local execution begins with `flutter run`; the documented self-contained web build uses `flutter build web --no-web-resources-cdn`.