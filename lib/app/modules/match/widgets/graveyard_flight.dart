import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../data/enums.dart';

/// Flies a piece sprite from any on-screen widget to any graveyard, running the
/// whole sequence in one full-screen [Overlay] so nothing is left behind the
/// nested [RotatedBox]es of the board and graveyards:
///   1. the **translation** from the source rect to the graveyard rect (shrinking
///      to graveyard size), plus an optional **180° flip** (a piece landing in
///      the *enemy* graveyard is drawn upside-down, so it turns over on the way;
///      a piece going to its *own* graveyard keeps its orientation);
///   2. a **curtain** that rises over the destination graveyard — drawn *above*
///      the flying piece — and covers it just as it lands;
///   3. while fully hidden, [onArrive] commits the piece into the real graveyard;
///   4. the curtain retracts, revealing the strip with the piece settled in.
///
/// Positions come from the live widgets ([fromKey], [toKey]) measured at launch,
/// so it's correct for any board size or layout — there are no tuned offsets.
///
/// Returns when the curtain finishes retracting.
Future<void> flyToGraveyard(
  BuildContext context, {
  required GlobalKey fromKey,
  required GlobalKey toKey,
  required Widget piece,
  required bool rotate,
  required VoidCallback onArrive,
  Color? curtainColor,
  Duration duration = const Duration(milliseconds: 800),
}) async {
  final overlay = Overlay.of(context);
  final fromBox = fromKey.currentContext?.findRenderObject() as RenderBox?;
  final toBox = toKey.currentContext?.findRenderObject() as RenderBox?;
  final overlayBox = overlay.context.findRenderObject() as RenderBox?;
  if (fromBox == null ||
      toBox == null ||
      overlayBox == null ||
      !fromBox.hasSize ||
      !toBox.hasSize) {
    onArrive();
    return;
  }

  // Everything in the overlay's local space (works even if it doesn't start at
  // the screen origin).
  final start = overlayBox
      .globalToLocal(fromBox.localToGlobal(fromBox.size.center(Offset.zero)));
  final end = overlayBox
      .globalToLocal(toBox.localToGlobal(toBox.size.center(Offset.zero)));
  final curtainRect =
      overlayBox.globalToLocal(toBox.localToGlobal(Offset.zero)) & toBox.size;
  final startSize = fromBox.size.shortestSide;
  final endSize = toBox.size.shortestSide;

  final completer = Completer<void>();
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _FlightOverlay(
      start: start,
      end: end,
      startSize: startSize,
      endSize: endSize,
      rotate: rotate,
      curtainRect: curtainRect,
      curtainColor: curtainColor ?? brackgroundColorSolid,
      flightDuration: duration,
      onArrive: onArrive,
      onDone: () {
        entry.remove();
        if (!completer.isCompleted) completer.complete();
      },
      child: piece,
    ),
  );

  overlay.insert(entry);
  return completer.future;
}

class _FlightOverlay extends StatefulWidget {
  const _FlightOverlay({
    required this.start,
    required this.end,
    required this.startSize,
    required this.endSize,
    required this.rotate,
    required this.curtainRect,
    required this.curtainColor,
    required this.flightDuration,
    required this.onArrive,
    required this.onDone,
    required this.child,
  });

  final Offset start;
  final Offset end;
  final double startSize;
  final double endSize;
  final bool rotate;
  final Rect curtainRect;
  final Color curtainColor;
  final Duration flightDuration;
  final VoidCallback onArrive;
  final VoidCallback onDone;
  final Widget child;

  @override
  State<_FlightOverlay> createState() => _FlightOverlayState();
}

class _FlightOverlayState extends State<_FlightOverlay>
    with TickerProviderStateMixin {
  // Drives the piece from source to graveyard; the curtain rises over its tail.
  late final AnimationController _flight =
      AnimationController(vsync: this, duration: widget.flightDuration);
  late final Animation<double> _flightT =
      CurvedAnimation(parent: _flight, curve: Curves.easeInOutQuint);
  // Retracts the curtain once the piece has landed and been committed.
  late final AnimationController _retract =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 350));

  // The curtain starts covering the last 45% of the flight, so it's fully up
  // exactly as the piece arrives.
  static const double _coverFrom = 0.55;

  bool _landed = false;

  @override
  void initState() {
    super.initState();
    _flight.forward().whenComplete(_land);
  }

  Future<void> _land() async {
    // Piece is now fully hidden by the curtain — commit it into the real
    // graveyard, hold a beat, then reveal.
    setState(() => _landed = true);
    widget.onArrive();
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    await _retract.forward();
    widget.onDone();
  }

  @override
  void dispose() {
    _flight.dispose();
    _retract.dispose();
    super.dispose();
  }

  double get _curtainValue {
    if (_landed) return 1 - _retract.value; // retracting
    final v = _flightT.value;
    return ((v - _coverFrom) / (1 - _coverFrom)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: Listenable.merge([_flight, _retract]),
          builder: (context, _) {
            final v = _flightT.value;
            final pos = Offset.lerp(widget.start, widget.end, v)!;
            final size = lerpDouble(widget.startSize, widget.endSize, v)!;
            final angle = widget.rotate ? v * pi : 0.0;
            return Stack(
              children: [
                // The flying piece — hidden once it has landed behind the curtain.
                if (!_landed)
                  Positioned(
                    left: pos.dx - size / 2,
                    top: pos.dy - size / 2,
                    width: size,
                    height: size,
                    child: Transform.rotate(angle: angle, child: widget.child),
                  ),
                // The curtain — always ABOVE the piece, so it covers the landing.
                Positioned.fromRect(
                  rect: widget.curtainRect,
                  child: Center(
                    child: Transform.scale(
                      scaleY: _curtainValue,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: widget.curtainColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
