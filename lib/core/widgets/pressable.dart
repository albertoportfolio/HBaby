import 'package:flutter/material.dart';

/// Wraps [child] so it gently scales down while pressed, giving tactile,
/// fluid feedback on tappable cards.
///
/// It uses a [Listener] (raw pointer events) instead of a [GestureDetector]
/// so it never competes in the gesture arena with an inner [InkWell]/button —
/// the child keeps handling the actual tap and ripple, this only adds the
/// scale. Keep the inner widget responsible for [onTap]; do not duplicate it
/// here.
class Pressable extends StatefulWidget {
  final Widget child;

  /// Scale applied while the pointer is down.
  final double pressedScale;

  const Pressable({
    super.key,
    required this.child,
    this.pressedScale = 0.96,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
