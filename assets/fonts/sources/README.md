# Bundled typefaces

Original variable TTFs and OFL license texts: `google/fonts`,
`https://github.com/google/fonts/tree/main/ofl/`, retrieved 2026-09-27:

| Family | Upstream directory | Source | Bundled static weights |
| --- | --- | --- | --- |
| Fredoka | `ofl/fredoka` | `Fredoka[wdth,wght].ttf` | 400, 500, 600, 700 |
| Nunito | `ofl/nunito` | `Nunito[wght].ttf` | 400, 500, 600, 700, 800 |
| JetBrains Mono | `ofl/jetbrainsmono` | `JetBrainsMono[wght].ttf` | 400, 500, 600, 700 |
| Roboto Mono | `ofl/robotomono` | `RobotoMono[wght].ttf` | 400, 500, 600, 700 |

Each static TTF in the parent directory was instantiated with fonttools
4.66.0 using `wght=<weight> --static` (Fredoka's width axis defaults to 100).
Some sources lack STAT entries for every weight, so the optional
`--update-name-table` flag was omitted for those instances. The originals
remain here for reproducibility; only the static faces and OFL texts are
declared as Flutter assets. The static filenames follow google_fonts' asset
lookup convention, `<Family>-<Weight>.ttf`.