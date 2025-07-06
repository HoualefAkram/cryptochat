import 'dart:math';
import 'dart:developer' as dev;

class Cipher {
  static final int _asciiLen = _CustomAscii.asciiLen;
  static const int _maxShift = 10000;

  static String encode(String text, int? seed) {
    if (seed == null) return text;
    final Random rng = Random(seed);
    final List<int> ascii = text.toCustomAscii();
    final List<int> shifted = ascii
        .map((e) => _addToCode(e, rng.nextInt(_maxShift)))
        .toList();
    dev.log(shifted.toString());
    return _CustomAscii.string(shifted);
  }

  static String decode(String hash, int? seed) {
    if (seed == null) return hash;
    final Random rng = Random(seed);
    final List<int> ascii = hash.toCustomAscii();
    final List<int> shifted = ascii.map((e) {
      final int shiftedAscii = _substractFromCode(e, rng.nextInt(_maxShift));
      return shiftedAscii;
    }).toList();
    return _CustomAscii.string(shifted);
  }

  static int _addToCode(int code, int value) {
    int output = (code + value) % _asciiLen;
    // return _removedAscii.contains(output) ? _spaceAscii : output;
    return output;
  }

  static int _substractFromCode(int code, int value) {
    final int sub = code - value;
    final output = (sub % _asciiLen + _asciiLen) % _asciiLen;
    // return _removedAscii.contains(output) ? _spaceAscii : output;
    return output;
  }
}

extension _CustomAscii on String {
  static const int _charStart = 33;
  static const String _space = " ";
  static const int _spaceAscii = 94;

  static final Map<int, String> _customAsciiMap = {
    for (int i = 0; i <= 93; i++) i: String.fromCharCode(i + _charStart),
  }..addEntries([MapEntry(_spaceAscii, _space)]);

  static final Map<String, int> _customAsciiMapReversed = {
    for (int i = 0; i <= 93; i++) String.fromCharCode(i + _charStart): i,
  }..addEntries([MapEntry(_space, _spaceAscii)]);

  static int get asciiLen => _customAsciiMap.entries.length;

  List<int> toCustomAscii() {
    final List<int> output = List.empty(growable: true);
    for (int i = 0; i < length; i++) {
      final int unit = codeUnitAt(i);
      final String char = String.fromCharCode(unit);
      final int ascii = _customAsciiMapReversed[char] ?? _spaceAscii;
      output.add(ascii);
    }
    return output;
  }

  static String string(List<int> values) {
    final List<String> decodedValues = List.empty(growable: true);
    for (int value in values) {
      final String txt = _customAsciiMap[value] ?? _space;
      decodedValues.add(txt);
    }
    final String output = decodedValues.join();
    return output;
  }
}
