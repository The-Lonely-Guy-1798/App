// lib/widgets/common/slide_in_animation.dart

import 'dart:async';
import 'package:flutter/material.dart';

class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const SlideInAnimation({super.key, required this.child, required this.delay});

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // MODIFIED: Increased duration for a gentler animation
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      // MODIFIED: Changed curve for a smoother deceleration
      curve: Curves.easeOutQuart,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}