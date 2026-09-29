import 'dart:math';

import 'lesson_curriculum_selector.dart';
import 'word_lists.dart';

/// Sentence pools for the Story Sprint game, organized by difficulty.
///
/// Easy sentences are short and lowercase; medium adds capitals and commas;
/// hard adds questions, exclamations, and apostrophes — matching the skills
/// taught in the capitals and punctuation lessons.
class SentenceLists {
  SentenceLists._();

  static const List<String> dutchEasy = [
    'de kat slaapt op de mat.',
    'een rode bus rijdt voorbij.',
    'we rennen naar het park.',
    'de zon schijnt nu fel.',
    'mijn hond graaft een gat.',
    'een kikker springt op een blad.',
    'we eten rijst en bonen.',
    'de vlieger vliegt hoog.',
    'een vis zwemt heel snel.',
    'de bel gaat twee keer.',
    'we huppelen naar huis.',
    'een kever zit op een blad.',
    'de maan gloeit in de nacht.',
    'we lezen een leuk boek.',
    'een vogel zingt een lied.',
    'de melk is erg koud.',
    'we tekenen met stiften.',
    'een krab loopt zijwaarts.',
    'de trein rijdt heel snel.',
    'we klappen voor het team.',
  ];

  static const List<String> dutchMedium = [
    'De puppy jaagde achter zijn eigen staart aan.',
    'We pakten appels, brood en sap in.',
    'Mijn zus vond een glimmende blauwe schelp.',
    'De robot piepte twee keer en reed weg.',
    'Papa maakte vandaag pannenkoeken voor het ontbijt.',
    'Een regenboog verscheen na de storm.',
    'De bibliotheek gaat om negen uur open.',
    'We plantten zaden, gaven water en wachtten.',
    'De eekhoorn verstopte eikels onder de boom.',
    'Oma vertelt de beste verhaaltjes voor het slapengaan.',
    'Ons team scoorde in de laatste minuut.',
    'De bakker verkoopt muffins, broodjes en taarten.',
    'Een zachte bries bewoog het hoge gras.',
    'We bouwden een fort van oude dozen.',
    'De astronaut zwaaide vanuit de raket.',
    'Mijn lievelingskleur is fel groen.',
    'De schildpad won de race uiteindelijk.',
    'We zagen eenden, ganzen en een zwaan.',
    'De goochelaar haalde een konijn uit zijn hoed.',
    'Iedereen juichte toen de lichten aangingen.',
  ];

  static const List<String> dutchHard = [
    'Waar verstopte de kleine vos zich? Hij zit achter het blok!',
    'Vergeet je paraplu niet, want het kan vandaag gaan regenen!',
    'Wie liet het hek open? De geiten zijn los!',
    "'t Is bijna tijd voor de show, dus zoek je plaats op.",
    'Kun je het geloven dat we wonnen? Wat een geweldige wedstrijd!',
    'Was de grot van de draak niet donker, diep en akelig stil?',
    'Laten we de tent, de kaart en de zaklamp inpakken!',
    'Wat is het snelste dier? Het is de slechtvalk!',
    'We moesten lachen om de piepkleine auto van de clown!',
    'Hoorde je dat geluid? Misschien was het een uil.',
    'De kok riep, en de keuken kwam in actie!',
    'Het is niet makkelijk om te jongleren, maar oefenen helpt veel!',
    'Hoeveel sterren kun je tellen? Meer dan honderd!',
    'De papegaai van de kapitein krijste luid en vloog naar de mast!',
    'Was die achtbaan niet snel? Laten we hem nog een keer doen!',
    'Waarom veranderen bladeren van kleur? Vraag het je juf.',
    'De rechercheur bekeek de aanwijzingen: iets klopte niet!',
    'Je bent bijna bij de finish, dus geef niet op!',
    'Van wie zijn deze voetstappen? Ze leiden naar de tuin.',
    'Dat is de grootste pompoen die ik ooit heb gezien!',
  ];

  static const List<String> easy = [
    'the cat naps on the mat.',
    'a red bus rolls by.',
    'we run to the park.',
    'the sun is up now.',
    'my dog digs a hole.',
    'a frog hops on a log.',
    'we eat rice and beans.',
    'the kite flies high.',
    'a fish swims fast.',
    'the bell rings twice.',
    'we hop and skip home.',
    'a bug sits on a leaf.',
    'the moon glows at night.',
    'we read a fun book.',
    'a bird sings a song.',
    'the milk is very cold.',
    'we draw with crayons.',
    'a crab walks sideways.',
    'the train goes fast.',
    'we clap for the team.',
  ];

  static const List<String> medium = [
    'The puppy chased its tail in circles.',
    'We packed apples, bread, and juice.',
    'My sister found a shiny blue shell.',
    'The robot beeped twice and rolled away.',
    'Dad made pancakes for breakfast today.',
    'A rainbow appeared after the storm.',
    'The library opens at nine in the morning.',
    'We planted seeds, watered them, and waited.',
    'The squirrel hid acorns under the tree.',
    'Grandma tells the best bedtime stories.',
    'Our team scored in the final minute.',
    'The baker sells muffins, rolls, and pies.',
    'A gentle breeze moved the tall grass.',
    'We built a fort out of old boxes.',
    'The astronaut waved from the rocket.',
    'My favorite color is bright green.',
    'The turtle won the race in the end.',
    'We saw ducks, geese, and one swan.',
    'The magician pulled a rabbit from his hat.',
    'Everyone cheered when the lights came on.',
  ];

  static const List<String> hard = [
    "Where did the little fox hide? It's behind the log!",
    "Don't forget your umbrella; it might rain today.",
    'Who left the gate open? The goats are loose!',
    "It's almost time for the show, so find your seats.",
    'Can you believe we won? What an amazing game!',
    "The dragon's cave was dark, deep, and very quiet.",
    "Let's pack the tent, the map, and the flashlight.",
    "What's the fastest animal? It's the peregrine falcon!",
    "We couldn't stop laughing at the clown's tiny car.",
    'Did you hear that sound? Maybe it was an owl.',
    "The chef shouted, and the kitchen burst into action!",
    "It isn't easy to juggle, but practice helps a lot.",
    'How many stars can you count? More than a hundred!',
    "The captain's parrot squawked, then flew to the mast.",
    "Wasn't that roller coaster fast? Let's ride it again!",
    'Why do leaves change color? Ask your science teacher.',
    "The detective checked the clues; something didn't fit.",
    "You're almost at the finish line, so don't give up!",
    'Whose footprints are these? They lead to the garden.',
    "That's the biggest pumpkin I've ever seen!",
  ];

  static List<String> forDifficulty(ContentDifficulty d) =>
      LessonCurriculum.isDutch ? switch (d) {
        ContentDifficulty.easy => dutchEasy,
        ContentDifficulty.medium => dutchMedium,
        ContentDifficulty.hard => dutchHard,
      } : switch (d) {
    ContentDifficulty.easy => easy,
    ContentDifficulty.medium => medium,
    ContentDifficulty.hard => hard,
  };

  static final _random = Random();

  /// A shuffled copy of the pool for one game round.
  static List<String> shuffledFor(ContentDifficulty d) {
    final list = List<String>.from(forDifficulty(d));
    list.shuffle(_random);
    return list;
  }
}
