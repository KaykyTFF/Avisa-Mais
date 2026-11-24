import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const int maxLogicLines = 250;
const int maxUiLines = 300;

List<File> collectLibDartFiles() {
  final libDir = Directory('lib');
  return libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList(growable: false);
}

String normalizeRelativePath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final libIndex = normalized.indexOf('lib/');
  return libIndex >= 0 ? normalized.substring(libIndex) : normalized;
}

/// Definição objetiva de linha efetiva (alinhada ao AGENTS.md):
/// conta toda linha não vazia após `trim()`, excluindo comentários de linha
/// (`//`, `///`) e linhas de comentário em bloco (`/*`, `*`, `*/`).
/// Imports, declarações, código e chaves de fechamento são contabilizados.
int countEffectiveLines(String content) {
  return content
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where(
        (line) =>
            line.isNotEmpty &&
            !line.startsWith('//') &&
            !line.startsWith('/*') &&
            !line.startsWith('*') &&
            !line.startsWith('*/'),
      )
      .length;
}

bool isUiPath(String relativePath) {
  return relativePath.startsWith('lib/widgets/') ||
      relativePath.contains('/views/') ||
      relativePath.contains('/widgets/') ||
      relativePath == 'lib/routes/home_screen.dart';
}

bool isViewModelPath(String relativePath) {
  return relativePath.contains('/viewmodels/');
}

void main() {
  final libFiles = collectLibDartFiles();

  group('Flutter Architecture & Code-Quality Guardrails', () {
    test('keeps AGENTS.md present at the Flutter repository root', () {
      expect(File('AGENTS.md').existsSync(), isTrue);
    });

    test('centralizes theme infrastructure exclusively in lib/core/theme/', () {
      expect(Directory('lib/theme').existsSync(), isFalse);
      expect(File('lib/core/theme/app_colors.dart').existsSync(), isTrue);
      expect(File('lib/core/theme/app_theme.dart').existsSync(), isTrue);
      expect(File('lib/core/theme/app_typography.dart').existsSync(), isTrue);
      expect(File('lib/core/theme/app_spacing.dart').existsSync(), isTrue);
    });

    test('forbids legacy lib/screens/ and lib/viewmodels/ directories', () {
      expect(Directory('lib/screens').existsSync(), isFalse);
      expect(Directory('lib/viewmodels').existsSync(), isFalse);
    });

    test('enforces strict file size limits (<= 300 UI / <= 250 logic) across all of lib/', () {
      final violations = <String>[];

      for (final file in libFiles) {
        final relPath = normalizeRelativePath(file.path);
        final lines = countEffectiveLines(file.readAsStringSync());
        final limit = isUiPath(relPath) ? maxUiLines : maxLogicLines;

        if (lines > limit) {
          violations.add('$relPath: $lines linhas (limite: $limit)');
        }
      }

      expect(violations, isEmpty);
    });

    test('forbids hidden singletons inside ViewModels (enforce explicit DI)', () {
      final singletonPattern = RegExp(r'static\s+final\s+\w+\s+_instance');
      final offenders = <String>[];

      for (final file in libFiles) {
        final relPath = normalizeRelativePath(file.path);
        if (!isViewModelPath(relPath)) continue;
        if (singletonPattern.hasMatch(file.readAsStringSync())) {
          offenders.add(relPath);
        }
      }

      expect(offenders, isEmpty);
    });

    test('forbids storing sensitive credentials in SharedPreferences', () {
      final sharedPrefsSensitive = RegExp(
        r'SharedPreferences[\s\S]{0,400}(token|jwt|password|secret|refresh)',
        caseSensitive: false,
      );
      final offenders = <String>[];

      for (final file in libFiles) {
        final codeOnly = file
            .readAsLinesSync()
            .where((line) => !line.trimLeft().startsWith('//'))
            .join('\n');
        if (sharedPrefsSensitive.hasMatch(codeOnly)) {
          offenders.add(normalizeRelativePath(file.path));
        }
      }

      expect(offenders, isEmpty);
    });

    test('centralizes logging and routing infrastructure', () {
      expect(File('lib/core/logging/app_logger.dart').existsSync(), isTrue);
      expect(File('lib/routes/app_routes.dart').existsSync(), isTrue);
      expect(File('lib/routes/app_router.dart').existsSync(), isTrue);
    });

    test('forbids print() and direct debugPrint() calls in lib/', () {
      final forbiddenLogPattern = RegExp(r'(^|[^\w.])(print|debugPrint)\s*\(');
      final offenders = <String>[];

      for (final file in libFiles) {
        final relPath = normalizeRelativePath(file.path);
        final lines = file.readAsLinesSync();
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.startsWith('//')) continue;
          if (forbiddenLogPattern.hasMatch(trimmed)) {
            offenders.add(relPath);
            break;
          }
        }
      }

      expect(offenders, isEmpty);
    });

    test('forbids disabling critical analyzer rules via inline ignore', () {
      final forbiddenIgnore = RegExp(
        r'//\s*ignore(_for_file)?:[^\n]*(avoid_print|use_build_context_synchronously|cancel_subscriptions|close_sinks)',
      );
      final offenders = <String>[];

      for (final file in libFiles) {
        final content = file.readAsStringSync();
        if (forbiddenIgnore.hasMatch(content)) {
          offenders.add(normalizeRelativePath(file.path));
        }
      }

      expect(offenders, isEmpty);
    });

    test('forbids UI files from importing HTTP clients, dart:io, or services', () {
      final forbiddenImport = RegExp(
        r'''import\s+['"](dart:io|package:(http|dio)/|[^'"]*data/services/)''',
      );
      final offenders = <String>[];

      for (final file in libFiles) {
        final relPath = normalizeRelativePath(file.path);
        if (!isUiPath(relPath)) continue;
        if (forbiddenImport.hasMatch(file.readAsStringSync())) {
          offenders.add(relPath);
        }
      }

      expect(offenders, isEmpty);
    });

    test('forbids hardcoded http/https URLs in UI screens and widgets', () {
      final hardcodedUrl = RegExp(r'''['"]https?://''');
      final offenders = <String>[];

      for (final file in libFiles) {
        final relPath = normalizeRelativePath(file.path);
        if (!isUiPath(relPath)) continue;
        if (hardcodedUrl.hasMatch(file.readAsStringSync())) {
          offenders.add(relPath);
        }
      }

      expect(offenders, isEmpty);
    });

    test('forbids cross-feature direct imports inside lib/features/', () {
      final featurePathPattern = RegExp(r'^lib/features/([^/]+)/');
      final importFeaturePattern = RegExp(
        r'''import\s+['"][^'"]*features/([^/'"]+)/''',
      );
      final offenders = <String>[];

      for (final file in libFiles) {
        final relPath = normalizeRelativePath(file.path);
        final ownMatch = featurePathPattern.firstMatch(relPath);
        if (ownMatch == null) continue;
        final ownFeature = ownMatch.group(1);

        final content = file.readAsStringSync();
        for (final match in importFeaturePattern.allMatches(content)) {
          final targetFeature = match.group(1);
          if (targetFeature != null && targetFeature != ownFeature) {
            offenders.add('$relPath -> features/$targetFeature/');
          }
        }
      }

      expect(offenders, isEmpty);
    });

    test('forbids duplicate *_model.dart files outside lib/data/models/', () {
      final misplacedModels = libFiles
          .map((file) => normalizeRelativePath(file.path))
          .where(
            (relPath) =>
                relPath.endsWith('_model.dart') &&
                !relPath.startsWith('lib/data/models/'),
          )
          .toList(growable: false);

      expect(misplacedModels, isEmpty);
    });
  });
}
