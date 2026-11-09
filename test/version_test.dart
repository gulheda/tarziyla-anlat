import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tarziyla_anlat/constants.dart';

void main() {
  test('appVersion pubspec.yaml sürümüyle aynı', () {
    final line = File('pubspec.yaml')
        .readAsLinesSync()
        .firstWhere((l) => l.startsWith('version:'));
    final version = line.split(':').last.trim().split('+').first;
    expect(appVersion, version);
  });

  test('README sürüm ve bağlantılarla uyumlu', () {
    final readme = File('README.md').readAsStringSync();
    expect(readme, contains(repoUrl));
  });
}
