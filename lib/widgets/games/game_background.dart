import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  final Widget child;

  const GameBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: brightness == Brightness.dark
            ? const LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                colors: [Color(0xFFECEFF1), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: child,
    );
  }
}
