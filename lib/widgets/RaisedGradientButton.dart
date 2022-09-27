import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const RaisedGradientButton({
    required Key key,
    required this.child,
    required this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(6, 6), blurRadius: 5),
            BoxShadow(
                color: Colors.white12, offset: Offset(-4, -4), blurRadius: 3),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
