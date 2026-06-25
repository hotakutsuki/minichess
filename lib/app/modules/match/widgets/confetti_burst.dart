import 'dart:math';

import 'package:flutter/material.dart';

/// A self-contained confetti rain (no external package). Drop it on top of a
/// screen inside a Stack; it plays once and then sits idle.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    Key? key,
    this.count = 90,
    this.duration = const Duration(seconds: 3),
    this.colors = const [
      Color(0xFFCCAC4B), // sun gold
      Color(0xFFEE6136), // moon orange
      Colors.white,
      Color(0xFF6CB9F1), // sky blue
      Colors.redAccent,
    ],
  }) : super(key: key);

  final int count;
  final Duration duration;
  final List<Color> colors;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)..forward();
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _particles = List.generate(widget.count, (_) {
      return _Particle(
        startX: rnd.nextDouble(),
        startY: -0.1 - rnd.nextDouble() * 0.3,
        driftX: (rnd.nextDouble() - 0.5) * 0.5,
        fallSpeed: 0.7 + rnd.nextDouble() * 0.8,
        size: 6 + rnd.nextDouble() * 9,
        color: widget.colors[rnd.nextInt(widget.colors.length)],
        rotation: rnd.nextDouble() * pi * 2,
        spin: (rnd.nextDouble() - 0.5) * 8,
        delay: rnd.nextDouble() * 0.25,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(_particles, _controller.value),
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.startX,
    required this.startY,
    required this.driftX,
    required this.fallSpeed,
    required this.size,
    required this.color,
    required this.rotation,
    required this.spin,
    required this.delay,
  });

  final double startX; // 0..1 of width
  final double startY; // fraction of height (can be negative = above screen)
  final double driftX; // horizontal drift in fractions of width
  final double fallSpeed; // fractions of height per unit time
  final double size;
  final Color color;
  final double rotation;
  final double spin;
  final double delay; // 0..1, when this particle starts falling
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles, this.t);

  final List<_Particle> particles;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final local = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final x = (p.startX + p.driftX * local) * size.width +
          sin(local * pi * 4 + p.rotation) * 6;
      final y = (p.startY + p.fallSpeed * local) * size.height;
      if (y > size.height) continue;
      paint.color = p.color.withOpacity((1 - local).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + p.spin * local);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: p.size, height: p.size * 0.5),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
