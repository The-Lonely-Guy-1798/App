import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import 'main_screen.dart';

class _LoadingResult {
  final bool hasConnection;
  final bool isLoggedIn;
  _LoadingResult({required this.hasConnection, required this.isLoggedIn});
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _introController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _hasInternet = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _introController, curve: Curves.easeIn);
    _scaleAnimation =
        CurvedAnimation(parent: _introController, curve: Curves.easeOutBack);
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    final minSplashTime = Future.delayed(const Duration(seconds: 4));
    final loadingResult = await _loadData();
    await minSplashTime;

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasInternet = loadingResult.hasConnection;
    });

    if (loadingResult.hasConnection) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => loadingResult.isLoggedIn
              ? const MainScreen()
              : const LoginScreen(),
        ),
      );
    }
  }

  Future<_LoadingResult> _loadData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final prefs = await SharedPreferences.getInstance();
    final hasInternet =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi);
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return _LoadingResult(hasConnection: hasInternet, isLoggedIn: isLoggedIn);
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
              top: -100,
              left: -150,
              child: _buildLightBlob(theme.colorScheme.primary, 400)),
          Positioned(
              bottom: -150,
              right: -200,
              child: _buildLightBlob(theme.colorScheme.secondary, 500)),

          // FIXED: Replaced withOpacity with withAlpha
          Container(
              color:
                  theme.scaffoldBackgroundColor.withAlpha((255 * 0.5).round())),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              // FIXED: Replaced withOpacity with withAlpha
                              BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withAlpha((255 * 0.3).round()),
                                  blurRadius: 25.0,
                                  spreadRadius: 5.0),
                              BoxShadow(
                                  color: theme.colorScheme.secondary
                                      .withAlpha((255 * 0.3).round()),
                                  blurRadius: 25.0,
                                  spreadRadius: 5.0)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset('assets/logo.png',
                                width: 160, height: 160),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            "You don't need to pay a dime to read great stories",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.orbitron(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                const Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black26,
                                    offset: Offset(2.0, 2.0)),
                                // FIXED: Replaced withOpacity with withAlpha
                                Shadow(
                                    blurRadius: 15.0,
                                    color: theme.colorScheme.primary
                                        .withAlpha((255 * 0.5).round())),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "New stories dropping on 5th, 15th and 25th of every month.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.exo2(
                            fontSize: 15,
                            color: theme.textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: _isLoading
                        ? _LoadingWidget(
                            progressColor: theme.colorScheme.primary)
                        : !_hasInternet
                            ? _NoInternetWidget(onRetry: _startSplashSequence)
                            : const SizedBox(
                                key: ValueKey('empty'), height: 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          // FIXED: Replaced withOpacity with withAlpha
          colors: [color.withAlpha((255 * 0.3).round()), Colors.transparent],
        ),
      ),
    );
  }
}

class _NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const _NoInternetWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('no-internet'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              color: theme.colorScheme.primary, size: 32),
          const SizedBox(height: 12),
          const Text('No Internet Connection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Please connect to the internet to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.textTheme.bodySmall?.color, fontSize: 14)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  final Color progressColor;
  const _LoadingWidget({required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Loading...'),
        const SizedBox(height: 8),
        SizedBox(
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ),
      ],
    );
  }
}
