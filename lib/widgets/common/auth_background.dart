import 'dart:ui';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // MODIFIED: Check the theme's brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // MODIFIED: Define colors that change based on the theme
    final baseColor = isDarkMode ? const Color(0xff0A091E) : Colors.white;
    final topBlobColor =
        isDarkMode ? const Color(0xff583D72) : Colors.deepPurple.shade100;
    final bottomBlobColor =
        isDarkMode ? const Color(0xff2E4C6D) : Colors.teal.shade100;
    final tintColor =
        isDarkMode ? Colors.black.withAlpha(25) : Colors.white.withAlpha(100);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // MODIFIED: Use the theme-aware base color
            Container(color: baseColor),
            // MODIFIED: Use the theme-aware blob colors
            Positioned(
              top: -100,
              left: -150,
              child: _lightBlob(topBlobColor, 400),
            ),
            Positioned(
              bottom: -150,
              right: -200,
              child: _lightBlob(bottomBlobColor, 500),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              // MODIFIED: Use the theme-aware tint color
              child: Container(color: tintColor),
            ),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SafeArea(child: child),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _lightBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withAlpha(100), color.withAlpha(0)],
        ),
      ),
    );
  }
}
