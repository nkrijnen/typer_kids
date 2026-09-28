import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/keyboard_data.dart';

void main() {
  test('Dutch rows match the canonical ISO QWERTY matrix', () {
    expect(KeyboardData.dutchRows, [
      ['§', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '='],
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '\\'],
      ['`', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/'],
      [' '],
    ]);

    for (final key in KeyboardData.dutchRows.expand((row) => row)) {
      expect(KeyboardData.dutchFinger(key), KeyboardData.keyToFinger[key]);
    }
    expect(KeyboardData.dutchFinger('§'), 'left-pinky');
  });

  test('Dutch shifted outputs resolve to their physical base keys', () {
    const shiftedOutputs = {
      '±': '§',
      '!': '1',
      '@': '2',
      '#': '3',
      r'$': '4',
      '%': '5',
      '^': '6',
      '&': '7',
      '*': '8',
      '(': '9',
      ')': '0',
      '_': '-',
      '+': '=',
      'Q': 'q',
      'W': 'w',
      'E': 'e',
      'R': 'r',
      'T': 't',
      'Y': 'y',
      'U': 'u',
      'I': 'i',
      'O': 'o',
      'P': 'p',
      '{': '[',
      '}': ']',
      'A': 'a',
      'S': 's',
      'D': 'd',
      'F': 'f',
      'G': 'g',
      'H': 'h',
      'J': 'j',
      'K': 'k',
      'L': 'l',
      ':': ';',
      '"': "'",
      '|': '\\',
      '~': '`',
      'Z': 'z',
      'X': 'x',
      'C': 'c',
      'V': 'v',
      'B': 'b',
      'N': 'n',
      'M': 'm',
      '<': ',',
      '>': '.',
      '?': '/',
    };

    for (final entry in shiftedOutputs.entries) {
      expect(KeyboardData.dutchBaseKey(entry.key), entry.value);
      expect(KeyboardData.dutchNeedsShift(entry.key), isTrue);
      expect(
        KeyboardData.dutchFinger(entry.key),
        KeyboardData.dutchFinger(entry.value),
      );
    }
  });

  test('Euro uses AltGr on 2 and unlisted characters have no mapping', () {
    expect(KeyboardData.dutchBaseKey('€'), '2');
    expect(KeyboardData.dutchFinger('€'), 'left-ring');
    expect(KeyboardData.dutchNeedsAltGr('€'), isTrue);
    expect(KeyboardData.dutchNeedsShift('€'), isFalse);
    expect(KeyboardData.dutchBaseKey('é'), isNull);
    expect(KeyboardData.dutchBaseKey('ï'), isNull);
    expect(KeyboardData.dutchNeedsShift('é'), isFalse);
  });

  test('English guidance retains the original key positions', () {
    expect(KeyboardData.keyboardRows[0].first, '`');
    expect(KeyboardData.baseKey('?'), '/');
    expect(KeyboardData.keyToFinger[';'], 'right-pinky');
  });
}
