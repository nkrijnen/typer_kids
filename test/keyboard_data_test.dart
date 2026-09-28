import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/keyboard_data.dart';

void main() {
  test('Netherlands QWERTY keys and fingers follow KBDNE', () {
    expect(KeyboardData.dutchRows[0], containsAllInOrder(['1', '2', '3']));
    expect(KeyboardData.dutchBaseKey('f'), 'f');
    expect(KeyboardData.dutchFinger('f'), 'left-index');
    expect(KeyboardData.dutchBaseKey('?'), '/');
    expect(KeyboardData.dutchBaseKey(';'), ',');
    expect(KeyboardData.dutchBaseKey(':'), '.');
    expect(KeyboardData.dutchBaseKey('['), ']');
    expect(KeyboardData.dutchBaseKey('é'), '´');
    expect(KeyboardData.dutchBaseKey('è'), '´');
    expect(KeyboardData.dutchBaseKey('ê'), '¨');
    expect(KeyboardData.dutchFinger('é'), 'right-pinky');
    expect(KeyboardData.dutchNeedsShift('?'), isTrue);
    expect(KeyboardData.dutchNeedsShift('è'), isTrue);
    expect(KeyboardData.dutchNeedsShift('ê'), isTrue);
    expect(KeyboardData.dutchNeedsShift('ï'), isFalse);
    expect(KeyboardData.dutchBaseKey('€'), isNull);
  });

  test('English guidance retains the original key positions', () {
    expect(KeyboardData.keyboardRows[0].first, '`');
    expect(KeyboardData.baseKey('?'), '/');
    expect(KeyboardData.keyToFinger[';'], 'right-pinky');
  });
}