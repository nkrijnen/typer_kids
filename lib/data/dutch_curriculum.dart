import '../models/lesson.dart';

/// Compact per-stage authoring data. `newKeys` are accumulated separately
/// across the required course and the optional path after the foundation.
class _Stage {
  final String id;
  final String title;
  final String description;
  final LessonCategory category;
  final LessonDifficulty difficulty;
  final String newKeys;
  final bool isOptional;
  final List<String> exercises;
  final String funTip;

  const _Stage({
    required this.id,
    required this.title,
    required this.description,
    this.category = LessonCategory.homeRow,
    required this.difficulty,
    required this.newKeys,
    this.isOptional = false,
    required this.exercises,
    required this.funTip,
  });
}

class DutchCurriculum {
  DutchCurriculum._();

  static const _stages = <_Stage>[
    _Stage(
      id: 'nl-letter-01',
      title: 'Vind de starttoetsen',
      description: 'Vind f en j en oefen tot je ze blind kunt vinden.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 'f j',
      exercises: ['ff jj fj jf'],
      funTip:
          'Voel de streepjes op f en j. Dit zijn letteroefeningen, geen woorden.',
    ),
    _Stage(
      id: 'nl-letter-02',
      title: 'D en k erbij',
      description: 'Je middelvingers leren d en k, vlak naast f en j.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 'd k',
      exercises: ['fd jk df kj'],
      funTip: 'Laat je vingers steeds terugkeren naar f en j.',
    ),
    _Stage(
      id: 'nl-letter-03',
      title: 'S en l ontdekken',
      description:
          'Je ringvingers leren s en l, terwijl de wijsvingers op f en j blijven.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 's l',
      exercises: ['sdf jkl dsf lkj'],
      funTip: 'Zes toetsen door elkaar. Kun je ze zonder te kijken vinden?',
    ),
    _Stage(
      id: 'nl-letter-04',
      title: 'Woorden op de thuisrij',
      description: 'Leer a en typ je eerste Nederlandse woorden.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 'a',
      exercises: ['jas als das kaas'],
      funTip: 'Eerst de letters, daarna echte woorden.',
    ),
    _Stage(
      id: 'nl-letter-05',
      title: 'G en h naar binnen reiken',
      description:
          'Je wijsvingers reiken naar binnen voor g en h en keren terug naar f en j.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 'g h',
      exercises: ['fg jh gf hj', 'dag had hals'],
      funTip: 'Reik naar binnen naar g en h en keer steeds terug naar f en j.',
    ),
    _Stage(
      id: 'nl-letter-06',
      title: 'E en i ontdekken',
      description:
          'Je middelvingers reiken omhoog van d en k naar e en i en keren terug naar huis.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 'e i',
      exercises: ['de die ik is'],
      funTip: 'Mix veelvoorkomende woorden met eerdere oefeningen.',
    ),
    _Stage(
      id: 'nl-letter-07',
      title: 'R en u erbij',
      description:
          'Je wijsvingers reiken omhoog van f en j naar r en u en keren terug.',
      difficulty: LessonDifficulty.beginner,
      newKeys: 'r u',
      exercises: ['fr ju rf uj', 'reis deur kleur'],
      funTip: 'Haal e/i en r/u samen op zonder de andere vingers op te tillen.',
    ),
    _Stage(
      id: 'nl-letter-08',
      title: 'T en n afwisselen',
      description:
          'De linker wijsvinger reikt omhoog en naar binnen naar t; de rechter wijsvinger reikt omlaag naar n.',
      difficulty: LessonDifficulty.intermediate,
      newKeys: 't n',
      exercises: ['tuin trein neus hand'],
      funTip: 'Wissel bovenste en onderste wijsvingerreiken af.',
    ),
    _Stage(
      id: 'nl-letter-09',
      title: 'O en w met de ringvinger',
      description:
          'Je ringvingers reiken omhoog van s en l naar w en o en keren terug naar huis.',
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'o w',
      exercises: ['sw lo ws ol', 'hond woord stoel water'],
      funTip:
          'Herhaal eerst de wijsvingerreiken, mix dan de twee ringvingerreiken erdoorheen.',
    ),
    _Stage(
      id: 'nl-letter-10',
      title: 'M en c op de onderste rij',
      description:
          'De rechter wijsvinger reikt omlaag naar m; de linker middelvinger reikt omlaag naar c.',
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'm c',
      exercises: ['muis room school cirkel'],
      funTip:
          'Mix bovenste en onderste rij terwijl je steeds terugkeert naar f en j.',
    ),
    _Stage(
      id: 'nl-letter-11',
      title: 'V en b onderscheiden',
      description:
          'De linker wijsvinger reikt omlaag naar v en b en keert na elke druk terug naar f.',
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'v b',
      exercises: ['fv fb vf bf', 'vis vijf boom brief'],
      funTip: 'Onderscheid v van b zonder je hele linkerhand te verschuiven.',
    ),
    _Stage(
      id: 'nl-letter-12',
      title: 'P met de rechter pink',
      description:
          'De rechter pink reikt omhoog vanaf de thuispositie naar p en keert terug.',
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'p',
      exercises: ['pen poes appel soep'],
      funTip:
          'Mix p met de eerdere o/w ringvingerreiken en laat de pink weer thuiskomen.',
    ),
    _Stage(
      id: 'nl-letter-13',
      title: 'Z met de linker pink',
      description: 'De linker pink reikt omlaag vanaf a naar z en keert terug.',
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'z',
      exercises: ['zon zes zee zout'],
      funTip: 'Wissel a en z af in woorden en herhaal daarna beide pinkreiken.',
    ),
    _Stage(
      id: 'nl-letter-14',
      title: 'X met de linker ringvinger',
      description:
          'De linker ringvinger reikt omlaag vanaf s naar x en keert terug.',
      difficulty: LessonDifficulty.advanced,
      newKeys: 'x',
      exercises: ['sx xs sax', 'taxi extra mix'],
      funTip: 'Typ x alleen in korte, bekende Nederlandse woorden.',
    ),
    _Stage(
      id: 'nl-letter-15',
      title: 'Q met de linker pink',
      description: 'De linker pink reikt omhoog vanaf a naar q en keert terug.',
      difficulty: LessonDifficulty.advanced,
      newKeys: 'q',
      exercises: ['aq qa', 'quiz aqua'],
      funTip:
          'Vergelijk de bovenste q-reik met de onderste z-reik zonder je pols te bewegen.',
    ),
    _Stage(
      id: 'nl-letter-16',
      title: 'Y als laatste letter',
      description:
          'De rechter wijsvinger reikt omhoog en naar binnen vanaf j naar y en keert terug.',
      difficulty: LessonDifficulty.advanced,
      newKeys: 'y',
      exercises: ['yoga baby pony'],
      funTip:
          'Mix y met de recente zeldzame letters en herhaal daarna eerdere controlepunten.',
    ),
    _Stage(
      id: 'nl-shift-01',
      title: 'Shift met F en J',
      description: 'Houd Shift met de andere hand vast en typ F en J.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.beginner,
      newKeys: 'F J',
      exercises: ['FF JJ FJ JF', 'Fleur leest', 'Jan fietst'],
      funTip: 'Gebruik de Shift-toets aan de andere kant van je lettervinger.',
    ),
    _Stage(
      id: 'nl-shift-02',
      title: 'D en K met Shift',
      description: 'Reik naar d en k terwijl de andere hand Shift vasthoudt.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.beginner,
      newKeys: 'D K',
      exercises: ['DD KK DK KD', 'Daan kijkt', 'Kees fietst'],
      funTip: 'Je middelvinger reikt; je andere hand bedient Shift.',
    ),
    _Stage(
      id: 'nl-shift-03',
      title: 'S, L en A met Shift',
      description: 'Oefen de hoofdletters op de buitenkant van de thuisrij.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.beginner,
      newKeys: 'S L A',
      exercises: ['SS LL AA SL AS', 'Sara leest', 'Als Jan lacht'],
      funTip: 'Wissel je ringvingers en pink af met de andere Shift.',
    ),
    _Stage(
      id: 'nl-shift-04',
      title: 'G, H, E en I',
      description: 'Mix binnenwaartse en bovenste reiken met Shift.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'G H E I',
      exercises: ['GG HH EE II', 'Gijs helpt', 'Ik lees het'],
      funTip: 'Keer na elke hoofdletter terug naar de thuisrij.',
    ),
    _Stage(
      id: 'nl-shift-05',
      title: 'R, U, T en N',
      description: 'Oefen langere reiken met de tegenoverliggende Shift.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'R U T N',
      exercises: ['RR UU TT NN', 'Ruben rent', 'Tina ruikt'],
      funTip: 'Laat de Shift-toets los na iedere hoofdletter.',
    ),
    _Stage(
      id: 'nl-shift-06',
      title: 'O, W, M en C',
      description: 'Mix hoofdletters op de bovenste en onderste rij.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.intermediate,
      newKeys: 'O W M C',
      exercises: ['OO WW MM CC', 'Wim woont', 'Mona komt'],
      funTip: 'Laat je vingers na de reik terugkeren naar f en j.',
    ),
    _Stage(
      id: 'nl-shift-07',
      title: 'V, B, P en Z',
      description: 'Haal de nieuwe hoofdletters op met beide handen.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.advanced,
      newKeys: 'V B P Z',
      exercises: ['VV BB PP ZZ', 'Piet ziet vis', 'Bram pakt ze'],
      funTip: 'Houd Shift vast met de hand die niet de letter typt.',
    ),
    _Stage(
      id: 'nl-shift-08',
      title: 'X, Q en Y',
      description: 'Oefen de laatste drie hoofdletters.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.advanced,
      newKeys: 'X Q Y',
      exercises: ['XX QQ YY', 'Yara doet yoga', 'Quinn mixt sap'],
      funTip: 'Zoek ook bij zeldzame letters de Shift van de andere hand.',
    ),
    _Stage(
      id: 'nl-shift-09',
      title: 'Alle hoofdletters herhalen',
      description: 'Mix alle hoofdletters in korte Nederlandse woorden.',
      category: LessonCategory.uppercase,
      difficulty: LessonDifficulty.advanced,
      newKeys: '',
      exercises: [
        'FJ DK SL AG HE IR TU NO WM CV BP ZX QY',
        'Jan en Sara lezen',
        'Quinn en Yara fietsen',
      ],
      funTip:
          'Begin ieder woord met de juiste Shift en typ daarna rustig door.',
    ),
    _Stage(
      id: 'nl-digit-01',
      title: 'De eerste cijfers',
      description: 'Reik naar 1, 2 en 3 en keer terug naar de thuisrij.',
      category: LessonCategory.numbers,
      difficulty: LessonDifficulty.beginner,
      newKeys: '1 2 3',
      exercises: ['11 22 33 12 23', 'Ik tel 1 2 3'],
      funTip: 'Voor cijfers gebruik je geen Shift.',
    ),
    _Stage(
      id: 'nl-digit-02',
      title: 'Verder tellen',
      description: 'Oefen 4, 5 en 6 samen met de eerste cijfers.',
      category: LessonCategory.numbers,
      difficulty: LessonDifficulty.beginner,
      newKeys: '4 5 6',
      exercises: ['44 55 66 14 25 36', 'Er zijn 5 vissen'],
      funTip: 'Laat je vingers na ieder cijfer terugkeren.',
    ),
    _Stage(
      id: 'nl-digit-03',
      title: 'De laatste cijfers',
      description: 'Leer 7, 8, 9 en 0 en mix alle tien cijfers.',
      category: LessonCategory.numbers,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '7 8 9 0',
      exercises: ['77 88 99 00 79 80', 'Op 8 juni is het 20 graden'],
      funTip: 'Reik naar de rechterkant van de cijferrij.',
    ),
    _Stage(
      id: 'nl-digit-04',
      title: 'De cijferrij herhalen',
      description: 'Typ cijfers en korte Nederlandse getallen door elkaar.',
      category: LessonCategory.numbers,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '',
      exercises: ['10 23 45 67 89', 'Er liggen 12 boeken en 3 pennen'],
      funTip: 'Kijk niet naar je handen als je van letters naar cijfers gaat.',
    ),
    _Stage(
      id: 'nl-punct-01',
      title: 'Komma en punt',
      description: 'Schrijf zinnen met een komma en een punt.',
      category: LessonCategory.punctuation,
      difficulty: LessonDifficulty.beginner,
      newKeys: '. ,',
      exercises: [
        '., ,. .. ,,',
        'Ik tel 1, 2 en 3.',
        'Sara leest, Jan tekent.',
      ],
      funTip: 'De komma en punt hebben elk een eigen toets.',
    ),
    _Stage(
      id: 'nl-punct-02',
      title: 'Vragen en uitroepen',
      description: 'Gebruik Shift voor een vraagteken en uitroepteken.',
      category: LessonCategory.punctuation,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '? !',
      exercises: ['?? !! ?!', 'Kom je mee? Ja, ik kom!', 'Is het 8 uur?'],
      funTip: 'Houd de andere Shift vast bij / voor ? en 1 voor !.',
    ),
    _Stage(
      id: 'nl-punct-03',
      title: 'Lijsten en aanhalingstekens',
      description: 'Oefen dubbele punten, puntkommas en citaten.',
      category: LessonCategory.punctuation,
      difficulty: LessonDifficulty.intermediate,
      newKeys: ': ; \' "',
      exercises: [
        ':: ;; \'\' ""',
        'Ik zeg: "Dag!"',
        'Een lijst: jas; pen; boek.',
      ],
      funTip: 'De dubbele punt en het aanhalingsteken gebruiken Shift.',
    ),
    _Stage(
      id: 'nl-punct-04',
      title: 'Streepje en haakjes',
      description: 'Typ een koppelteken en tekst tussen haakjes.',
      category: LessonCategory.punctuation,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '- ( )',
      exercises: [
        '-- () (-)',
        'Mijn broer (12) leest.',
        'Een doe-het-zelf les.',
      ],
      funTip: 'De haakjes staan op 9 en 0 met de andere Shift.',
    ),
    _Stage(
      id: 'nl-punct-05',
      title: 'Leestekens door elkaar',
      description: 'Herhaal leestekens in korte Nederlandse zinnen.',
      category: LessonCategory.punctuation,
      difficulty: LessonDifficulty.advanced,
      newKeys: '',
      exercises: [
        '"Kom je?" vroeg Jan.',
        'Ik heb 2 pennen, 1 boek en een tas.',
        'Dag! Tot morgen.',
      ],
      funTip: 'Lees de zin eerst en typ dan ieder leesteken rustig.',
    ),
    _Stage(
      id: 'nl-punct-06',
      title: 'Leestekens toepassen',
      description: 'Typ korte teksten met alle gewone leestekens.',
      category: LessonCategory.punctuation,
      difficulty: LessonDifficulty.advanced,
      newKeys: '',
      exercises: [
        '"Is het al 9 uur?" vroeg Sara.',
        'Mijn zus (10) schrijft: "Ja, hoor!"',
        'Neem een pen, een boek en een tas mee.',
      ],
      funTip: 'Controleer na iedere zin of de komma en punt goed staan.',
    ),
    _Stage(
      id: 'nl-text-01',
      title: 'Namen en woorden',
      description: 'Mix bekende woorden en namen met een hoofdletter.',
      category: LessonCategory.commonWords,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '',
      exercises: [
        'Sara leest een boek',
        'Jan en Bram spelen samen',
        'Yara fietst naar huis',
      ],
      funTip: 'Kijk naar de eerste letter van elke naam.',
    ),
    _Stage(
      id: 'nl-text-02',
      title: 'Cijfers in woorden',
      description: 'Typ korte teksten met aantallen en dagen.',
      category: LessonCategory.commonWords,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '',
      exercises: [
        'Op 12 juni gaan we zwemmen',
        'Wim heeft 3 boeken en 2 pennen',
        'De trein komt om 8 uur',
      ],
      funTip: 'Blijf rustig als je tussen letters en cijfers wisselt.',
    ),
    _Stage(
      id: 'nl-text-03',
      title: 'Korte zinnen',
      description: 'Schrijf hele zinnen met hoofdletters en leestekens.',
      category: LessonCategory.sentences,
      difficulty: LessonDifficulty.intermediate,
      newKeys: '',
      exercises: [
        'Sara schrijft een brief.',
        'Jan leest, Wim tekent.',
        'De kat slaapt op de bank.',
      ],
      funTip: 'Begin met een hoofdletter en eindig met een punt.',
    ),
    _Stage(
      id: 'nl-text-04',
      title: 'Zinnen met vragen',
      description: 'Oefen vragen, citaten en getallen in langere zinnen.',
      category: LessonCategory.sentences,
      difficulty: LessonDifficulty.advanced,
      newKeys: '',
      exercises: [
        '"Kom je om 4 uur?" vraagt Bram.',
        'Yara roept: "Ik heb 2 kaarten!"',
        'Neem je jas (en een boek) mee?',
      ],
      funTip: 'Lees de zin eerst en let op ieder aanhalingsteken.',
    ),
    _Stage(
      id: 'nl-text-05',
      title: 'Schrijven in het echt',
      description:
          'Herhaal alle vereiste toetsen in praktische Nederlandse tekst.',
      category: LessonCategory.sentences,
      difficulty: LessonDifficulty.advanced,
      newKeys: '',
      exercises: [
        'Op 5 mei gaan Sara en Jan naar het park. Ze nemen 2 boeken mee.',
        '"Heb je een pen?" vraagt Wim. "Ja, hier!" zegt Yara.',
        'Mijn zus (12) maakt een kaart voor haar vriend.',
      ],
      funTip: 'Gebruik je hele toetsenbord zonder naar je handen te kijken.',
    ),
    _Stage(
      id: 'nl-symbol-01',
      title: 'Toetsen aan de rand',
      description: 'Oefen de buitenste ISO-toetsen en hun Shift-tekens.',
      category: LessonCategory.advancedSymbols,
      difficulty: LessonDifficulty.advanced,
      isOptional: true,
      newKeys: '§ ± ` ~',
      exercises: ['§§ ±± `` ~~', '§a ±a `a ~a'],
      funTip: 'Houd de andere Shift vast voor ± en ~.',
    ),
    _Stage(
      id: 'nl-symbol-02',
      title: 'Haken en tekens',
      description: 'Mix haakparen en tekens rechts op de bovenste rij.',
      category: LessonCategory.advancedSymbols,
      difficulty: LessonDifficulty.advanced,
      isOptional: true,
      newKeys: '= _ + [ { ] }',
      exercises: ['== __ ++', '[a] {a} [jas] {jas}'],
      funTip: 'De krulhaken vragen Shift op dezelfde fysieke toetsen.',
    ),
    _Stage(
      id: 'nl-symbol-03',
      title: 'Schuine streep en pipe',
      description: 'Oefen de ISO-toets naast de thuisrij.',
      category: LessonCategory.advancedSymbols,
      difficulty: LessonDifficulty.advanced,
      isOptional: true,
      newKeys: r'\ |',
      exercises: [r'\\ || \| |\', r'jas\das | jas'],
      funTip: 'Voor de pipe houd je de andere Shift vast.',
    ),
    _Stage(
      id: 'nl-symbol-04',
      title: 'Tekens op de cijferrij',
      description: 'Gebruik Shift voor tekens boven de cijfers.',
      category: LessonCategory.advancedSymbols,
      difficulty: LessonDifficulty.advanced,
      isOptional: true,
      newKeys: r'@ # $ % ^ & *',
      exercises: [r'@@ ## $$ %% ^^ && **', 'jas@huis #jas *jas*'],
      funTip: 'De cijferrij blijft hetzelfde; Shift verandert de uitvoer.',
    ),
    _Stage(
      id: 'nl-symbol-05',
      title: 'Slash en vergelijkingen',
      description: 'Oefen slash, kleiner dan en groter dan.',
      category: LessonCategory.advancedSymbols,
      difficulty: LessonDifficulty.advanced,
      isOptional: true,
      newKeys: '/ < >',
      exercises: ['// << >>', 'a/b a<b a>b'],
      funTip: 'Typ < en > met de komma- en punttoets met Shift.',
    ),
    _Stage(
      id: 'nl-symbol-06',
      title: 'Euro met AltGr',
      description: 'Typ het euroteken met AltGr en 2.',
      category: LessonCategory.advancedSymbols,
      difficulty: LessonDifficulty.advanced,
      isOptional: true,
      newKeys: '€',
      exercises: ['€€ €', '€a €jas'],
      funTip: 'Houd AltGr vast en druk op 2 voor €.',
    ),
  ];

  static final List<Lesson> allLessons = List.unmodifiable(_buildLessons());

  static List<Lesson> _buildLessons() {
    final taught = <String>[];
    final optionalTaught = <String>[];
    return [
      for (var i = 0; i < _stages.length; i++)
        _toLesson(
          _stages[i],
          i,
          _stages[i].isOptional ? optionalTaught : taught,
        ),
    ];
  }

  static Lesson _toLesson(_Stage stage, int orderIndex, List<String> taught) {
    if (stage.isOptional && taught.isEmpty) {
      taught.addAll(
        _stages.take(16).expand((stage) => stage.newKeys.split(' ')),
      );
    }
    taught.addAll(stage.newKeys.split(' ').where((key) => key.isNotEmpty));
    return Lesson(
      id: stage.id,
      title: stage.title,
      description: stage.description,
      category: stage.category,
      difficulty: stage.difficulty,
      orderIndex: orderIndex,
      isOptional: stage.isOptional,
      focusKeys: List.unmodifiable(taught),
      exercises: stage.exercises,
      funTip: stage.funTip,
      emoji: '⌨️',
    );
  }
}
