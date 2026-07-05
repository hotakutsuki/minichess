import '../data/enums.dart';
import 'rule_modifier.dart';

/// How a modifier is meant to be used in the campaign.
enum ModifierUse { bossPower, joker }

/// Human-readable metadata for a [RuleModifier] — so every power/joker lives in
/// ONE place. A future debug screen, the joker-pick UI and the boss config can
/// all read from here instead of hardcoding names/descriptions. Pure data plus a
/// [sample] factory that builds a representative instance.
class ModifierInfo {
  ModifierInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.uses,
    required this.sample,
    this.source,
  });

  /// Stable machine id (kebab-case).
  final String id;

  /// Short display name.
  final String name;

  /// What it does, in plain language.
  final String description;

  /// Whether it's used as a boss power, a joker, or both.
  final Set<ModifierUse> uses;

  /// For boss powers: which guardian/life it belongs to (e.g. 'Cóndor · vida 1').
  /// Null for pure jokers.
  final String? source;

  /// Builds a representative instance (default tuning) of the modifier.
  final RuleModifier Function() sample;

  bool get isBossPower => uses.contains(ModifierUse.bossPower);
  bool get isJoker => uses.contains(ModifierUse.joker);
}

/// Every rule modifier in the game and what it does — the single source of truth.
///
/// Note: "jaque mate real" and the boss's N-lives are NOT modifiers; they are
/// engine primitives (`isCheckmate`) / match-loop state wired at campaign
/// integration, so they don't appear here.
final List<ModifierInfo> modifierCatalog = [
  ModifierInfo(
    id: 'double-step',
    name: 'Doble paso',
    description:
        'Las fichas ganan la opción de avanzar 2 casillas, además de su paso '
        'normal de 1. (El poder del Sol · vida 2 es una variante que reemplaza '
        'el paso de 1 por 2.)',
    uses: {ModifierUse.joker},
    sample: () => const DoubleStepModifier(side: ModifierSide.protagonist),
  ),
  ModifierInfo(
    id: 'transform-all-osos',
    name: 'Todas se vuelven osos',
    description:
        'Todas las fichas del bando afectado se mueven como el oso (caballo), '
        'sin importar qué pieza sean. El rey no cambia.',
    uses: {ModifierUse.bossPower},
    source: 'Oso · vida 2',
    sample: () => const TransformAllPiecesModifier(
        target: chrt.knight, side: ModifierSide.antagonist),
  ),
  ModifierInfo(
    id: 'return-captured',
    name: 'Invertir posesión de captura',
    description:
        'Las fichas capturadas no pasan a quien las captura: regresan a su '
        'dueño original (sin "drops" del enemigo).',
    uses: {ModifierUse.joker},
    sample: () => const ReturnCapturedModifier(),
  ),
  ModifierInfo(
    id: 'area-capture',
    name: 'Embestida',
    description:
        'Al capturar, también elimina las fichas enemigas ortogonalmente '
        'adyacentes a donde cae la ficha.',
    uses: {ModifierUse.bossPower, ModifierUse.joker},
    source: 'Oso · alternativa',
    sample: () => const AreaCaptureModifier(side: ModifierSide.antagonist),
  ),
  ModifierInfo(
    id: 'spawn',
    name: 'Rebrote',
    description:
        'Cada turno brota una ficha nueva del bando afectado en la primera '
        'casilla vacía. Un tablero lleno no genera nada.',
    uses: {ModifierUse.bossPower},
    source: 'Llama · vida 2',
    sample: () =>
        const SpawnModifier(piece: chrt.pawn, side: ModifierSide.antagonist),
  ),
  ModifierInfo(
    id: 'wind',
    name: 'Viento',
    description:
        'Empuja todas las fichas un paso en una dirección. Las que salen del '
        'tablero se van al cementerio de su dueño.',
    uses: {ModifierUse.bossPower},
    source: 'Cóndor · vida 2',
    sample: () =>
        const WindModifier(di: 0, dj: 1, side: ModifierSide.antagonist),
  ),
  ModifierInfo(
    id: 'wither',
    name: 'Marchitar',
    description:
        'Una ficha que su dueño deja sin mover durante N turnos se marchita y '
        'muere (va al cementerio). El rey nunca se marchita.',
    uses: {ModifierUse.bossPower},
    source: 'Cóndor · vida 1',
    sample: () =>
        const WitherModifier(turns: 3, side: ModifierSide.antagonist),
  ),
  ModifierInfo(
    id: 'felled-tiles',
    name: 'Tala el tablero',
    description:
        'Marca casillas "taladas" que el bando afectado (por defecto el '
        'protagonista) no puede pisar; el leñador sí puede.',
    uses: {ModifierUse.bossPower},
    source: 'Leñador (Oso) · vida 1',
    sample: () => FelledTilesModifier(const [
      [1, 2]
    ]),
  ),
];

/// Only the boss powers, in catalog order.
List<ModifierInfo> get bossPowerCatalog =>
    modifierCatalog.where((m) => m.isBossPower).toList();

/// Only the jokers, in catalog order.
List<ModifierInfo> get jokerCatalog =>
    modifierCatalog.where((m) => m.isJoker).toList();

/// A plain-text dump of the whole catalog — handy for a debug print/screen until
/// there's real UI.
String catalogAsText() {
  final b = StringBuffer();
  for (final m in modifierCatalog) {
    final tags = m.uses.map((u) => u.name).join(', ');
    b.writeln('• ${m.name}  [$tags]${m.source == null ? '' : ' — ${m.source}'}');
    b.writeln('    ${m.description}');
  }
  return b.toString();
}
