import 'package:flutter/material.dart';
import 'dart:ui';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 85,
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Background blur layer
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 65,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor
                          .withAlpha((255 * 0.8).round()),
                      border: Border(
                        top: BorderSide(
                          color:
                              theme.dividerColor.withAlpha((255 * 0.2).round()),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Nav Items Row
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(context, Icons.home_rounded, 'Home', 0),
                  _buildNavItem(context, Icons.menu_book_rounded, 'Stories', 1),
                  const SizedBox(width: 56), // For central play button space
                  _buildNavItem(
                      context, Icons.currency_bitcoin_rounded, 'Crypto', 3),
                  _buildNavItem(context, Icons.person_rounded, 'Profile', 4),
                ],
              ),
            ),
            // Play button
            Positioned(
              bottom: 20,
              child: _buildPlayButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedIndex == 2;

    return GestureDetector(
      onTap: () => onItemTapped(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isSelected
                ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                : [
                    theme.colorScheme.surface.withAlpha((255 * 0.9).round()),
                    theme.colorScheme.surface,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withAlpha((255 * 0.4).round()),
              blurRadius: 15,
              spreadRadius: isSelected ? 3 : 0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? Colors.white.withAlpha((255 * 0.5).round())
                : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: isSelected ? Colors.white : theme.colorScheme.primary,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final theme = Theme.of(context);
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.unselectedWidgetColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.7,
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.unselectedWidgetColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
