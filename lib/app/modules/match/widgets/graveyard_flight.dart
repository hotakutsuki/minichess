import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Flies a piece sprite from any on-screen widget to any graveyard, running
/// three animations at once:
///   1. the **translation** from the source rect to the graveyard rect,
///   2. an optional **180° flip** (a piece landing in the *enemy* graveyard is
///      drawn upside-down there, so it turns over on the way; a piece going to
///      its *own* graveyard keeps its orientation), and
///   3. whatever [onLaunch] kicks off simultaneously — typically the graveyard's
///      "curtain" reveal that hides the strip for a beat while the piece lands.
///
/// Positions come from the live widgets ([fromKey], [toKey]) measured at launch,
/// so the flight is correct for any board size or layout — there are no tuned
/// pixel offsets. The flyer lives in the root [Overlay] (absolute screen space),
/// decoupled from the nested [RotatedBox]es of the board and graveyards.
///
/// Returns when the flight finishes; the caller then commits the piece into the
/// real graveyard (the overlay flyer is transient and removes itself).
Future<void> flyToGraveyard(
  BuildContext context, {
  required GlobalKey fromKey,
  required GlobalKey toKey,
  required Widget piece,
  required bool rotate,
  VoidCallback? onLaunch,
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
    return;
  }

  // Source/target centres in the overlay's local space (works even if the
  // overlay doesn't start at the screen origin).
  final start = overlayBox
      .globalToLocal(fromBox.localToGlobal(fromBox.size.center(Offset.zero)));
  final end = overlayBox
      .globalToLocal(toBox.localToGlobal(toBox.size.center(Offset.zero)));
  final startSize = fromBox.size.shortestSide;
  final endSize = toBox.size.shortestSide;

  final completer = Completer<void>();
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _GraveyardFlight(
      start: start,
      end: end,
      startSize: startSize,
      endSize: endSize,
      rotate: rotate,
      duration: duration,
      onDone: () {
        entry.remove();
        if (!completer.isCompleted) completer.complete();
      },
      child: piece,
    ),
  );

  onLaunch?.call();
  overlay.insert(entry);
  return completer.future;
}

class _GraveyardFlight extends StatefulWidget {
  const _GraveyardFlight({
    required this.start,
    required this.end,
    required this.startSize,
    required this.endSize,
    required this.rotate,
    required this.duration,
    required this.onDone,
    required this.child,
  });

  final Offset start;
  final Offset end;
  final double startSize;
  final double endSize;
  final bool rotate;
  final Duration duration;
  final VoidCallback onDone;
  final Widget child;

  @override
  State<_GraveyardFlight> createState() => _GraveyardFlightState();
}

class _GraveyardFlightState extends State<_GraveyardFlight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _t =
      CurvedAnimation(parent: _c, curve: Curves.easeInOutQuint);

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        final v = _t.value;
        final pos = Offset.lerp(widget.start, widget.end, v)!;
        final size = lerpDouble(widget.startSize, widget.endSize, v)!;
        final angle = widget.rotate ? v * pi : 0.0;
        return Positioned(
          left: pos.dx - size / 2,
          top: pos.dy - size / 2,
          width: size,
          height: size,
          child: IgnorePointer(
            child: Transform.rotate(angle: angle, child: widget.child),
          ),
        );
      },
    );
  }
}
