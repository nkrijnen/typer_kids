import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/dutch_curriculum.dart';

const _outlinePath =
    '_bmad-output/specs/spec-dutch-touch-typing-curriculum/'
    'curriculum-outline.md';
const _alphabet = 'abcdefghijklmnopqrstuvwxyz';
const _tableHeader =
    '| Order | ID | New keys | Previously taught | Movement | Practice type | Difficulty | Examples | Review checkpoint |';
const _tableSeparator =
    '| --- | --- | --- | --- | --- | --- | --- | --- | --- |';
const _expectedNewKeyGroups = [
  'f j',
  'd k',
  's l',
  'a',
  'g h',
  'e i',
  'r u',
  't n',
  'o w',
  'm c',
  'v b',
  'p',
  'z',
  'x',
  'q',
  'y',
];
const _approvedDutchWords = {
  'jas',
  'als',
  'das',
  'kaas',
  'dag',
  'had',
  'hals',
  'de',
  'die',
  'ik',
  'is',
  'reis',
  'deur',
  'kleur',
  'tuin',
  'trein',
  'neus',
  'hand',
  'hond',
  'woord',
  'stoel',
  'water',
  'muis',
  'room',
  'school',
  'cirkel',
  'vis',
  'vijf',
  'boom',
  'brief',
  'pen',
  'poes',
  'appel',
  'soep',
  'zon',
  'zes',
  'zee',
  'zout',
  'taxi',
  'extra',
  'mix',
  'quiz',
  'aqua',
  'yoga',
  'baby',
  'pony',
};

void main() {
  group('Dutch curriculum plan', () {
    test('documents a complete, cumulative letter-key progression', () {
      final parsed = _parseStages(File(_outlinePath).readAsStringSync());

      expect(parsed.errors, isEmpty);
      expect(_validateStages(parsed.stages), isEmpty);
      expect(parsed.stages, hasLength(16));
      expect(
        parsed.stages.map((stage) => stage.newKeys.join(' ')),
        _expectedNewKeyGroups,
      );
    });

    test('preserves the three-lesson runtime boundary', () {
      expect(DutchCurriculum.allLessons.length, lessThanOrEqualTo(3));
    });

    test('aggregates actionable errors for malformed stage data', () {
      const malformed =
          '''
$_tableHeader
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | nl-letter-01 | f j | none | anchors | introduction | beginner | drill: fj | checkpoint |
| 3 |  | f | x |  |  |  | Dutch: fax! |  |
| 3 | nl-letter-03 | a | f j | reach | words | beginner | Dutch: fafa | checkpoint |
| 4 | nl-letter-03 | b | f j a a | reach | words | beginner | Dutch: bal<br>Dutch: | checkpoint |
| 0 | nl-letter-00 | c | f j a b | reach | words | beginner | Dutch: cirkel | checkpoint |
''';
      final parsed = _parseStages(malformed);
      final errors = [...parsed.errors, ..._validateStages(parsed.stages)];

      expect(errors, contains(contains('Missing stage order 2')));
      expect(errors, contains(contains('Duplicate stage order 3')));
      expect(errors, contains(contains('missing ID')));
      expect(errors, contains(contains('Duplicate stage ID nl-letter-03')));
      expect(errors, contains(contains('expected ID nl-letter-04')));
      expect(errors, contains(contains('missing movement')));
      expect(
        errors,
        contains(contains('Letter f is introduced more than once')),
      );
      expect(errors, contains(contains('Letter d is never introduced')));
      expect(errors, contains(contains('unavailable letter x')));
      expect(errors, contains(contains('unsupported character !')));
      expect(errors, contains(contains('must be positive')));
      expect(errors, contains(contains('Missing stage order 16')));
      expect(errors, contains(contains('duplicate prior key a')));
      expect(errors, contains(contains('empty example')));
      expect(errors, contains(contains('unapproved Dutch word fafa')));
    });

    test('reports malformed table framing without dropping stage rows', () {
      const missingSeparator =
          '''
$_tableHeader
| 1 | nl-letter-01 | f j | none | anchors | introduction | beginner | drill: fj | checkpoint |
''';
      final missing = _parseStages(missingSeparator);
      expect(missing.errors, contains(contains('Missing table separator')));
      expect(missing.stages, hasLength(1));

      const shortRow =
          '''
$_tableHeader
$_tableSeparator
|
''';
      final short = _parseStages(shortRow);
      expect(short.errors, contains(contains('Malformed table row')));
    });
  });
}

class _Stage {
  const _Stage({
    required this.order,
    required this.id,
    required this.newKeys,
    required this.priorKeys,
    required this.movement,
    required this.practiceType,
    required this.difficulty,
    required this.examples,
    required this.checkpoint,
  });

  final int order;
  final String id;
  final List<String> newKeys;
  final List<String> priorKeys;
  final String movement;
  final String practiceType;
  final String difficulty;
  final List<_Example> examples;
  final String checkpoint;
}

class _Example {
  const _Example(this.label, this.text);

  final String label;
  final String text;
}

class _ParseResult {
  const _ParseResult(this.stages, this.errors);

  final List<_Stage> stages;
  final List<String> errors;
}

_ParseResult _parseStages(String markdown) {
  final lines = markdown.split('\n');
  final headerIndex = lines.indexWhere((line) => line.trim() == _tableHeader);
  if (headerIndex < 0) {
    return const _ParseResult([], ['Missing curriculum stage table']);
  }

  final stages = <_Stage>[];
  final errors = <String>[];
  var firstRowIndex = headerIndex + 1;
  if (firstRowIndex < lines.length &&
      lines[firstRowIndex].trim() == _tableSeparator) {
    firstRowIndex++;
  } else {
    errors.add('Missing table separator after curriculum stage header');
  }
  for (var lineIndex = firstRowIndex; lineIndex < lines.length; lineIndex++) {
    final line = lines[lineIndex].trim();
    if (!line.startsWith('|')) break;
    if (!line.endsWith('|') || line.length < 2) {
      errors.add('Malformed table row ${lineIndex + 1}');
      continue;
    }
    final cells = line.substring(1, line.length - 1).split('|').map((cell) {
      return cell.trim();
    }).toList();
    if (cells.length != 9) {
      errors.add(
        'Table row ${lineIndex + 1} has ${cells.length} cells, expected 9',
      );
      continue;
    }

    final order = int.tryParse(cells[0]);
    if (order == null) {
      errors.add('Table row ${lineIndex + 1} has invalid order ${cells[0]}');
      continue;
    }
    stages.add(
      _Stage(
        order: order,
        id: cells[1],
        newKeys: _parseKeys(cells[2]),
        priorKeys: _parseKeys(cells[3]),
        movement: cells[4],
        practiceType: cells[5],
        difficulty: cells[6],
        examples: cells[7].split(RegExp(r'<br\s*/?>')).map((entry) {
          final separator = entry.indexOf(':');
          return separator < 0
              ? _Example('', entry.trim())
              : _Example(
                  entry.substring(0, separator).trim(),
                  entry.substring(separator + 1).trim(),
                );
        }).toList(),
        checkpoint: cells[8],
      ),
    );
  }
  return _ParseResult(stages, errors);
}

List<String> _parseKeys(String value) {
  if (value == 'none' || value.isEmpty) return [];
  return value.split(RegExp(r'\s+'));
}

List<String> _validateStages(List<_Stage> stages) {
  final errors = <String>[];
  final orders = <int, int>{};
  final ids = <String, int>{};
  final introductions = <String, int>{};
  final taught = <String>{};

  for (final stage in stages) {
    orders[stage.order] = (orders[stage.order] ?? 0) + 1;
    if (stage.order < 1) {
      errors.add('Stage order ${stage.order} must be positive');
    }
    if (stage.id.isEmpty) {
      errors.add('Stage ${stage.order} is missing ID');
    } else {
      ids[stage.id] = (ids[stage.id] ?? 0) + 1;
    }
  }

  for (var order = 1; order <= _expectedNewKeyGroups.length; order++) {
    if (!orders.containsKey(order)) errors.add('Missing stage order $order');
  }
  for (final entry in orders.entries.where((entry) => entry.value > 1)) {
    errors.add('Duplicate stage order ${entry.key}');
  }
  for (final entry in ids.entries.where((entry) => entry.value > 1)) {
    errors.add('Duplicate stage ID ${entry.key}');
  }

  for (var stageIndex = 0; stageIndex < stages.length; stageIndex++) {
    final stage = stages[stageIndex];
    final expectedOrder = stageIndex + 1;
    if (stage.order != expectedOrder) {
      errors.add(
        'Stage row $expectedOrder has order ${stage.order}, expected $expectedOrder',
      );
    }
    _requireMetadata(stage, errors);
    final expectedId = 'nl-letter-${stage.order.toString().padLeft(2, '0')}';
    if (stage.id.isNotEmpty && stage.id != expectedId) {
      errors.add(
        'Stage ${stage.order} has ID ${stage.id}, expected ID $expectedId',
      );
    }
    final expectedPrior = taught.toList()..sort();
    final actualPrior = stage.priorKeys.toSet().toList()..sort();
    if (actualPrior.length != stage.priorKeys.length) {
      final seen = <String>{};
      for (final key in stage.priorKeys) {
        if (!seen.add(key)) {
          errors.add('Stage ${stage.order} has duplicate prior key $key');
        }
      }
    }
    if (!_sameItems(expectedPrior, actualPrior)) {
      errors.add(
        'Stage ${stage.order} prior keys are ${actualPrior.join(' ')}, '
        'expected ${expectedPrior.join(' ')}',
      );
    }

    for (final key in stage.newKeys) {
      introductions[key] = (introductions[key] ?? 0) + 1;
    }
    final available = {...taught, ...stage.newKeys};
    _validateExamples(stage, available, errors);
    taught.addAll(stage.newKeys);
  }

  for (final letter in _alphabet.split('')) {
    final count = introductions[letter] ?? 0;
    if (count == 0) errors.add('Letter $letter is never introduced');
    if (count > 1) errors.add('Letter $letter is introduced more than once');
  }
  for (final key in introductions.keys.where((key) {
    return key.length != 1 || !_alphabet.contains(key);
  })) {
    errors.add('Unsupported introduced key $key');
  }

  return errors;
}

void _requireMetadata(_Stage stage, List<String> errors) {
  final fields = {
    'new keys': stage.newKeys.join(),
    'movement': stage.movement,
    'practice type': stage.practiceType,
    'difficulty': stage.difficulty,
    'examples': stage.examples.map((example) => example.text).join(),
    'review checkpoint': stage.checkpoint,
  };
  for (final entry in fields.entries) {
    if (entry.value.isEmpty) {
      errors.add('Stage ${stage.order} is missing ${entry.key}');
    }
  }
  for (final example in stage.examples) {
    if (example.text.isEmpty) {
      errors.add('Stage ${stage.order} has an empty example');
    }
  }
  if (!const {
    'beginner',
    'intermediate',
    'advanced',
  }.contains(stage.difficulty)) {
    errors.add(
      'Stage ${stage.order} has invalid difficulty ${stage.difficulty}',
    );
  }
}

void _validateExamples(
  _Stage stage,
  Set<String> available,
  List<String> errors,
) {
  for (final example in stage.examples) {
    if (!const {'drill', 'Dutch'}.contains(example.label)) {
      errors.add('Stage ${stage.order} example is missing a valid label');
    }
    if (example.label == 'Dutch') {
      for (final word in example.text.split(RegExp(r'\s+'))) {
        if (word.isNotEmpty && !_approvedDutchWords.contains(word)) {
          errors.add(
            'Stage ${stage.order} example "${example.text}" has unapproved Dutch word $word',
          );
        }
      }
    }
    for (final character in example.text.split('')) {
      if (character == ' ') continue;
      if (!_alphabet.contains(character)) {
        errors.add(
          'Stage ${stage.order} example "${example.text}" has unsupported character $character',
        );
      } else if (!available.contains(character)) {
        errors.add(
          'Stage ${stage.order} example "${example.text}" uses unavailable letter $character',
        );
      }
    }
  }
}

bool _sameItems(List<String> left, List<String> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
