import 'package:flutter_test/flutter_test.dart';
import 'package:inti_the_inka_chess_game/app/engine/modifier_catalog.dart';
import 'package:inti_the_inka_chess_game/app/engine/rule_modifier.dart';

// Keeps the modifier catalog honest: unique ids, every entry builds a real
// RuleModifier, and every entry is usable as at least a boss power or a joker.

void main() {
  group('modifierCatalog', () {
    test('is not empty', () {
      expect(modifierCatalog, isNotEmpty);
    });

    test('ids are unique', () {
      final ids = modifierCatalog.map((m) => m.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every entry builds a RuleModifier and has a use + description', () {
      for (final m in modifierCatalog) {
        expect(m.sample(), isA<RuleModifier>(), reason: m.id);
        expect(m.uses, isNotEmpty, reason: m.id);
        expect(m.name.trim(), isNotEmpty, reason: m.id);
        expect(m.description.trim(), isNotEmpty, reason: m.id);
      }
    });

    test('boss powers name their source; the split covers everything', () {
      for (final m in bossPowerCatalog) {
        expect(m.source, isNotNull, reason: '${m.id} is a boss power');
      }
      expect(bossPowerCatalog.length + jokerCatalog.length,
          greaterThanOrEqualTo(modifierCatalog.length));
    });

    test('catalogAsText lists every modifier', () {
      final text = catalogAsText();
      for (final m in modifierCatalog) {
        expect(text, contains(m.name), reason: m.id);
      }
    });
  });
}
