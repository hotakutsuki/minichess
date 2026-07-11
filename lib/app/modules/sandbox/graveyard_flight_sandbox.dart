import 'package:flutter/material.dart';

import '../../data/enums.dart';
import '../../utils/utils.dart';
import '../match/widgets/graveyard_flight.dart';

/// Debug-only playground for the [flyToGraveyard] primitive, isolated from the
/// match loop. A mock board (3×4) and two graveyard strips (top = "enemy",
/// bottom = "own"); tap any cell to fly its piece to the chosen graveyard and
/// watch the translation + optional 180° flip + curtain reveal, then land the
/// piece in the strip. Nothing here touches game state.
class GraveyardFlightSandbox extends StatefulWidget {
  const GraveyardFlightSandbox({Key? key}) : super(key: key);

  @override
  State<GraveyardFlightSandbox> createState() => _GraveyardFlightSandboxState();
}

class _GraveyardFlightSandboxState extends State<GraveyardFlightSandbox>
    with TickerProviderStateMixin {
  static const int _rows = 4;
  static const int _cols = 3;
  static const double _cell = 84;

  final GlobalKey _topGraveKey = GlobalKey();
  final GlobalKey _bottomGraveKey = GlobalKey();
  late final List<List<GlobalKey>> _cellKeys = List.generate(
      _rows, (_) => List.generate(_cols, (_) => GlobalKey()));

  final List<chrt> _topBuried = [];
  final List<chrt> _bottomBuried = [];

  chrt _selected = chrt.pawn;
  bool _toEnemyGrave = true; // target: top (enemy) vs bottom (own)
  bool _rotateOverride = true; // pre-checked to match "enemy grave -> flip"

  // A neutral board-like palette, kept clearly distinct from the (blue)
  // graveyard so the flying piece and the curtain reveal stay visible.
  static const Color _pageBg = Color(0xFF2B2622); // dark warm wood
  static const Color _lightSquare = Color(0xFFEED9B6);
  static const Color _darkSquare = Color(0xFFB58863);

  static const List<chrt> _pieces = [
    chrt.pawn,
    chrt.knight,
    chrt.bishop,
    chrt.rock,
    chrt.king,
  ];

  Future<void> _fly(int i, int j) async {
    final bool toEnemy = _toEnemyGrave;
    final toKey = toEnemy ? _topGraveKey : _bottomGraveKey;
    // The piece is shown in the destination graveyard's colour.
    final gravePlayer = toEnemy ? player.black : player.white;
    final piece = _selected;

    await flyToGraveyard(
      context,
      fromKey: _cellKeys[j][i],
      toKey: toKey,
      piece: getCharAsset(piece, gravePlayer, false),
      rotate: _rotateOverride,
      // Commit the piece while it's hidden behind the curtain.
      onArrive: () {
        if (!mounted) return;
        setState(() => (toEnemy ? _topBuried : _bottomBuried).add(piece));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: brackgroundColor,
        title: const Text('Sandbox — vuelo al cementerio'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _graveStrip(_topGraveKey, _topBuried, player.black,
                  'Cementerio enemigo (arriba)'),
              const SizedBox(height: 24),
              _board(),
              const SizedBox(height: 24),
              _graveStrip(_bottomGraveKey, _bottomBuried, player.white,
                  'Cementerio propio (abajo)'),
              const SizedBox(height: 24),
              _controls(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _board() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF6B4A32), // wooden frame
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int j = _rows - 1; j >= 0; j--) // draw top row (high j) first
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < _cols; i++) _boardCell(i, j),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _boardCell(int i, int j) {
    return GestureDetector(
      onTap: () => _fly(i, j),
      child: Container(
        key: _cellKeys[j][i],
        width: _cell,
        height: _cell,
        decoration: BoxDecoration(
          color: (i + j).isEven ? _darkSquare : _lightSquare,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: getCharAsset(
              _selected, _toEnemyGrave ? player.black : player.white, false),
        ),
      ),
    );
  }

  // A graveyard strip that matches the real one's dimensions. The reveal curtain
  // is drawn by flyToGraveyard (in the overlay, above the flying piece).
  Widget _graveStrip(
      GlobalKey key, List<chrt> buried, player p, String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          key: key,
          width: graveyardTileWide,
          height: graveyardHeight,
          decoration: BoxDecoration(
            border: Border.all(color: brackgroundColor),
            color: brackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: RotatedBox(
            quarterTurns: p == player.white ? 0 : 2,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in buried)
                  SizedBox(
                    width: graveyardHeight,
                    height: graveyardHeight,
                    child: getCharAsset(c, p, false),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _controls() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final c in _pieces)
              ChoiceChip(
                label: Text(c.name),
                selected: _selected == c,
                onSelected: (_) => setState(() => _selected = c),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Volar al cementerio enemigo (arriba)',
              style: TextStyle(color: Colors.white)),
          subtitle: const Text('apagado = cementerio propio (abajo)',
              style: TextStyle(color: Colors.white54)),
          value: _toEnemyGrave,
          onChanged: (v) => setState(() {
            _toEnemyGrave = v;
            _rotateOverride = v; // default: enemy grave flips, own doesn't
          }),
        ),
        SwitchListTile(
          title: const Text('Girar 180° en el vuelo',
              style: TextStyle(color: Colors.white)),
          value: _rotateOverride,
          onChanged: (v) => setState(() => _rotateOverride = v),
        ),
        TextButton(
          onPressed: () => setState(() {
            _topBuried.clear();
            _bottomBuried.clear();
          }),
          child: const Text('Vaciar cementerios'),
        ),
        const Text('Toca cualquier casilla para volar la pieza.',
            style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
