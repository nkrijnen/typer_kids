# Bundled typefaces

Original variable TTFs and OFL license texts: `google/fonts`,
`https://github.com/google/fonts/tree/main/ofl/`, retrieved 2026-09-27:

| Family | Upstream directory | Source | Bundled static weights |
| --- | --- | --- | --- |
| Fredoka | `ofl/fredoka` | `Fredoka[wdth,wght].ttf` | 400, 500, 600, 700 |
| Nunito | `ofl/nunito` | `Nunito[wght].ttf` | 400, 500, 600, 700, 800 |
| JetBrains Mono | `ofl/jetbrainsmono` | `JetBrainsMono[wght].ttf` | 400, 500, 600, 700 |
| Roboto Mono | `ofl/robotomono` | `RobotoMono[wght].ttf` | 400, 500, 600, 700 |

Flutter Web's 12 Noto Color Emoji and six Noto Sans Symbols 2 WOFF2 subsets are
bundled under `fallback/` using the paths in Flutter's
`font_fallback_data.dart`. They were retrieved from `fonts.gstatic.com` on
2026-09-27 and use their respective bundled OFL licenses (`notoemoji-OFL.txt`
and `notosanssymbols2-OFL.txt`). The Symbols 2 license comes from
`https://github.com/google/fonts/tree/main/ofl/notosanssymbols2`. The custom
web bootstrap points Flutter's fallback service at these local assets.

`Nunito-Italic.ttf` is the canonical GoogleFonts w400 italic asset retrieved
from `fonts.gstatic.com/s/a/df3c491d67e881e1b0c6265a7a8364f07e38d7a25893e9b2beac1439e1c2efd9.ttf`;
its SHA-256 is the hash embedded in that URL.

Each static TTF in the parent directory was instantiated with fonttools
4.66.0 using `wght=<weight> --static` (Fredoka's width axis defaults to 100).
Some sources lack STAT entries for every weight, so the optional
`--update-name-table` flag was omitted for those instances. The originals
remain here for reproducibility; only the static faces and OFL texts are
declared as Flutter assets. The static filenames follow google_fonts' asset
lookup convention, `<Family>-<Weight>.ttf`.