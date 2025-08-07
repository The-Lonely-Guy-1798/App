import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // Use gradient only in dark mode, else keep white background
        gradient: isDarkMode ? AppTheme.appBackgroundGradient : null,
        color: isDarkMode
            ? null
            : const Color(0xFFF5F5F5), // Light mode background color
      ),
      child: child,
    );
  }
}
