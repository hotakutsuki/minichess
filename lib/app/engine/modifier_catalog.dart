import '../data/enums.dart';
import 'rule_modifier.dart';

/// How a modifier is meant to be used in the campaign.
enum ModifierUse { bossPower, joker }

/// Human-readable metadata for a [RuleModifier] — so every power/joker lives in
/// ONE place. A future debug screen, the joker-pick UI and the boss config can
/// all read from here instead of hardcoding names/descriptions. Pure data plus a
/// [build] factory that constructs the modifier for a chosen [ModifierSide].
class ModifierInfo {
  ModifierInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.uses,
    required this.build,
    required this.defaultSide,
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

  /// The side it naturally targets (a joker → protagonist, a boss power →
  /// antagonist or the player it debuffs).
  final ModifierSide defaultSide;

  /// Builds the modifier targeting [side].
  final RuleModifier Function(ModifierSide side) build;

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
        'normal de 1.',
    uses: {ModifierUse.joker},
    defaultSide: ModifierSide.protagonist,
    build: (side) => DoubleStepModifier(side: side),
  ),
  ModifierInfo(
    id: 'transform-all-osos',
    name: 'Todas se vuelven osos',
    description:
        'Todas las fichas del bando afectado se mueven (y se ven) como el oso, '
        'sin importar qué pieza sean. El rey no cambia.',
    uses: {ModifierUse.bossPower},
    source: 'Oso · vida 2',
    defaultSide: ModifierSide.antagonist,
    build: (side) =>
        TransformAllPiecesModifier(target: chrt.knight, side: side),
  ),
  ModifierInfo(
    id: 'return-captured',
    name: 'Invertir posesión de captura',
    description:
        'Las fichas capturadas no pasan a quien las captura: regresan a su '
        'dueño original (sin "drops").',
    uses: {ModifierUse.joker},
    defaultSide: ModifierSide.protagonist,
    build: (side) => ReturnCapturedModifier(side: side),
  ),
  ModifierInfo(
    id: 'area-capture',
    name: 'Embestida',
    description:
        'Al capturar, elimina también las fichas enemigas ortogonalmente '
        'adyacentes (nunca reyes).',
    uses: {ModifierUse.bossPower, ModifierUse.joker},
    source: 'Oso · alternativa',
    defaultSide: ModifierSide.protagonist,
    build: (side) => AreaCaptureModifier(side: side),
  ),
  ModifierInfo(
    id: 'spawn',
    name: 'Rebrote',
    description:
        'Cada 2 turnos brota una ficha nueva del bando afectado en su fila '
        'trasera (primera casilla vacía). Un tablero lleno no genera nada.',
    uses: {ModifierUse.bossPower},
    source: 'Llama · vida 2',
    defaultSide: ModifierSide.antagonist,
    build: (side) => SpawnModifier(piece: chrt.pawn, everyTurns: 2, side: side),
  ),
  ModifierInfo(
    id: 'wind',
    name: 'Viento',
    description:
        'Cada 5 turnos una ventisca empuja las fichas del rival un paso hacia '
        'atrás; las que salen del tablero van al cementerio. El rey queda anclado '
        'y frena a las fichas detrás de él.',
    uses: {ModifierUse.bossPower},
    source: 'Cóndor · vida 2',
    defaultSide: ModifierSide.antagonist,
    build: (side) => WindModifier(everyTurns: 5, side: side),
  ),
  ModifierInfo(
    id: 'wither',
    name: 'Marchitar',
    description:
        'Una ficha del bando afectado que no se mueve durante 3 turnos se '
        'marchita y muere. El rey nunca se marchita.',
    uses: {ModifierUse.bossPower},
    source: 'Cóndor · vida 1',
    defaultSide: ModifierSide.protagonist,
    build: (side) => WitherModifier(turns: 3, side: side),
  ),
  ModifierInfo(
    id: 'felled-tiles',
    name: 'Tala el tablero',
    description:
        'Cada turno se tala una casilla nueva vecina a otra ya talada (dura 2 '
        'turnos y vuelve a normal). El bando afectado no puede pisar casillas '
        'taladas.',
    uses: {ModifierUse.bossPower},
    source: 'Leñador (Oso) · vida 1',
    defaultSide: ModifierSide.protagonist,
    build: (side) => FelledTilesModifier(side: side),
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
