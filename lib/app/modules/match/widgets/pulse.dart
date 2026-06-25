import 'package:flutter/material.dart';

/// Continuously scales its [child] between [min] and [max]. Used to make the
/// selected piece and the move hints feel alive.
class Pulse extends StatefulWidget {
  const Pulse({
    Key? key,
    required this.child,
    this.min = 1.0,
    this.max = 1.08,
    this.duration = const Duration(milliseconds: 700),
  }) : super(key: key);

  final Widget child;
  final double min;
  final double max;
  final Duration duration;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)
        ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: widget.min, end: widget.max).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}
