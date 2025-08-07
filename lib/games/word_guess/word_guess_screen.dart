import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'word_guess_data.dart';
import '../../widgets/games/game_background.dart';

class WordGuessScreen extends StatefulWidget {
  const WordGuessScreen({super.key});

  @override
  State<WordGuessScreen> createState() => _WordGuessScreenState();
}

class _WordGuessScreenState extends State<WordGuessScreen>
    with TickerProviderStateMixin {
  static const int _maxLives = 3;
  static const Duration _lifeRegenDuration = Duration(minutes: 10);

  int _currentLevel = 0;
  int _lives = _maxLives;
  late String _wordToGuess;
  late String _hint;
  late List<String> _guessedLetters;
  late List<String> _keyboardLetters;

  late AnimationController _wordShakeController;
  late Animation<double> _wordShakeAnimation;
  late List<AnimationController> _keyPressControllers;
  late AnimationController _levelStartController;

  Timer? _lifeRegenTimer;
  Duration? _timeUntilNextLife;

  // --- NEW: Flag to prevent duplicate dialogs ---
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _wordShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _wordShakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _wordShakeController,
        curve: Curves.elasticIn,
      ),
    );

    _levelStartController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _loadAndCalculateLives();
    _startLevel(_currentLevel);
  }

  @override
  void dispose() {
    _wordShakeController.dispose();
    _levelStartController.dispose();
    for (var controller in _keyPressControllers) {
      controller.dispose();
    }
    _lifeRegenTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAndCalculateLives() async {
    final prefs = await SharedPreferences.getInstance();
    int savedLives = prefs.getInt('wordguess_lives') ?? _maxLives;
    int lastLostTimestamp = prefs.getInt('wordguess_lastLostTimestamp') ?? 0;

    if (savedLives < _maxLives && lastLostTimestamp > 0) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeSinceLastLoss = Duration(milliseconds: now - lastLostTimestamp);

      if (timeSinceLastLoss >= _lifeRegenDuration) {
        int livesRegenerated =
            timeSinceLastLoss.inMinutes ~/ _lifeRegenDuration.inMinutes;
        savedLives = min(_maxLives, savedLives + livesRegenerated);

        if (savedLives == _maxLives) {
          await prefs.remove('wordguess_lastLostTimestamp');
        } else {
          final newTimestamp = lastLostTimestamp +
              (livesRegenerated * _lifeRegenDuration.inMilliseconds);
          await prefs.setInt('wordguess_lastLostTimestamp', newTimestamp);
        }
      }
    }

    if (mounted) {
      setState(() {
        _lives = savedLives;
      });
      await prefs.setInt('wordguess_lives', _lives);
      _startLifeRegenTimer();
    }
  }

  Future<void> _saveLifeState({required bool lifeWasLost}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wordguess_lives', _lives);
    if (lifeWasLost && _lives < _maxLives) {
      await prefs.setInt(
          'wordguess_lastLostTimestamp', DateTime.now().millisecondsSinceEpoch);
    }
    _startLifeRegenTimer();
  }

  void _startLifeRegenTimer() {
    _lifeRegenTimer?.cancel();
    if (_lives >= _maxLives) {
      setState(() => _timeUntilNextLife = null);
      return;
    }

    SharedPreferences.getInstance().then((prefs) {
      final lastLostTimestamp =
          prefs.getInt('wordguess_lastLostTimestamp') ?? 0;
      if (lastLostTimestamp == 0) return;

      _lifeRegenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final nextLifeTime =
            lastLostTimestamp + _lifeRegenDuration.inMilliseconds;
        final remaining = nextLifeTime - now;

        if (remaining <= 0) {
          _loadAndCalculateLives();
        } else {
          if (mounted) {
            setState(
                () => _timeUntilNextLife = Duration(milliseconds: remaining));
          }
        }
      });
    });
  }

  void _startLevel(int level) {
    if (level >= wordGuessLevels.length) {
      if (!_isDialogShowing) _showGameWonDialog();
      return;
    }
    setState(() {
      _currentLevel = level;
      final currentLevelData = wordGuessLevels[level];
      _wordToGuess = currentLevelData.word;
      _hint = currentLevelData.hint;
      _guessedLetters = [];
      _keyboardLetters = currentLevelData.keyboardLetters ??
          _generateKeyboardLetters(_wordToGuess);

      _keyPressControllers = List.generate(
        _keyboardLetters.length,
        (index) => AnimationController(
          duration: const Duration(milliseconds: 150),
          vsync: this,
        ),
      );

      _levelStartController.forward(from: 0.0);
    });
  }

  List<String> _generateKeyboardLetters(String word, {int totalLetters = 8}) {
    List<String> letters = word.toUpperCase().split('').toSet().toList();
    String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    Random random = Random();
    while (letters.length < totalLetters) {
      String randomChar = alphabet[random.nextInt(alphabet.length)];
      if (!letters.contains(randomChar)) {
        letters.add(randomChar);
      }
    }
    letters.shuffle();
    return letters;
  }

  void _handleGuess(String letter, int keyIndex) {
    if (_guessedLetters.contains(letter) || _lives <= 0 || _isDialogShowing)
      return;

    _keyPressControllers[keyIndex]
        .forward()
        .then((_) => _keyPressControllers[keyIndex].reverse());

    setState(() {
      _guessedLetters.add(letter);
      if (!_wordToGuess.toUpperCase().contains(letter)) {
        _lives--;
        _wordShakeController.forward(from: 0.0);
        _saveLifeState(lifeWasLost: true);
      }
    });

    _checkGameState();
  }

  void _checkGameState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      // --- MODIFIED: Check if a dialog is already showing ---
      if (!mounted || _isDialogShowing) return;

      bool wordGuessed = _wordToGuess
          .toUpperCase()
          .split('')
          .every((char) => _guessedLetters.contains(char));

      if (wordGuessed) {
        _showLevelCompleteDialog();
      } else if (_lives <= 0) {
        _showGameOverDialog();
      }
    });
  }

  void _watchAdForLives() {
    Navigator.of(context).pop();

    setState(() {
      _lives = min(_maxLives, _lives + 2);
    });
    _saveLifeState(lifeWasLost: false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('You received 2 extra lives!'),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarTextColor = isDarkMode ? Colors.white : Colors.black87;
    final appBarIconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Guess the Word',
            style: GoogleFonts.orbitron(color: appBarTextColor, shadows: [
              const Shadow(
                color: Colors.black54,
                blurRadius: 2.0,
                offset: Offset(1.0, 1.0),
              )
            ])),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: appBarIconColor),
      ),
      body: GameBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: AppBar().preferredSize.height),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildHint(),
                      const SizedBox(height: 30),
                      _buildWordDisplay(),
                      const SizedBox(height: 40),
                      _buildKeyboard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.black.withAlpha(100),
                margin: const EdgeInsets.all(8),
                child: const Center(
                  child: Text(
                    'Ad Placeholder',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final levelTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Level ${_currentLevel + 1}",
            style: GoogleFonts.exo2(fontSize: 18, color: levelTextColor)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: List.generate(_maxLives, (index) {
                return AnimatedScale(
                  scale: _lives > index ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedOpacity(
                    opacity: _lives > index ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _lives > index ? Icons.favorite : Icons.favorite_border,
                      color: Colors.redAccent,
                      shadows: const [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(1, 1))
                      ],
                    ),
                  ),
                );
              }),
            ),
            if (_timeUntilNextLife != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Next in: ${_timeUntilNextLife!.inMinutes}:${(_timeUntilNextLife!.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.orbitron(
                      fontSize: 12, color: Colors.cyanAccent),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(60),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Text(
        "Hint: $_hint",
        textAlign: TextAlign.center,
        style: GoogleFonts.exo2(
            fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
      ),
    );
  }

  Widget _buildWordDisplay() {
    return AnimatedBuilder(
      animation: _wordShakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(sin(_wordShakeAnimation.value * pi * 10) * 10, 0),
          child: child,
        );
      },
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(_wordToGuess.length, (index) {
          final char = _wordToGuess.toUpperCase()[index];
          final isGuessed = _guessedLetters.contains(char);

          return ScaleTransition(
            scale: CurvedAnimation(
              parent: _levelStartController,
              curve: Interval(0.2 + (index * 0.05), 0.8,
                  curve: Curves.easeOutBack),
            ),
            child: Container(
              width: 45,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withAlpha(70)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withAlpha(isGuessed ? 100 : 0),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: isGuessed
                    ? Text(
                        char,
                        key: ValueKey(char),
                        style: GoogleFonts.orbitron(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(_keyboardLetters.length, (index) {
        final letter = _keyboardLetters[index];
        final isGuessed = _guessedLetters.contains(letter);
        final isCorrect = _wordToGuess.toUpperCase().contains(letter);

        Color keyColor;
        if (isGuessed) {
          keyColor = isCorrect ? Colors.green.shade700 : Colors.red.shade700;
        } else {
          keyColor = Colors.black.withAlpha(75);
        }

        return ScaleTransition(
          scale: CurvedAnimation(
            parent: _levelStartController,
            curve:
                Interval(0.4 + (index * 0.05), 1.0, curve: Curves.easeOutBack),
          ),
          child: AnimatedBuilder(
            animation: _keyPressControllers[index],
            builder: (context, child) {
              final scale = 1.0 - (_keyPressControllers[index].value * 0.15);
              return Transform.scale(scale: scale, child: child);
            },
            child: GestureDetector(
              onTap: isGuessed ? null : () => _handleGuess(letter, index),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      keyColor,
                      Color.lerp(keyColor, Colors.black, 0.4)!
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withAlpha(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: GoogleFonts.exo2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(1, 1))
                      ]),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // --- MODIFIED: Made the function async to manage the dialog flag ---
  Future<void> _showThemedDialog({
    required String title,
    required String content,
    required List<Widget> actions,
    required IconData icon,
    required Color iconColor,
  }) async {
    _isDialogShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScaleTransition(
        scale: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInCubic,
        ),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A222C).withAlpha(230),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: iconColor.withAlpha(120))),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Flexible(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(title,
                        style: GoogleFonts.orbitron(color: Colors.white))),
              )
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: GoogleFonts.exo2(color: Colors.white70),
              ),
            ),
          ),
          actions: actions,
        ),
      ),
    );

    _isDialogShowing = false;
  }

  void _showLevelCompleteDialog() {
    _showThemedDialog(
        title: "Level Complete",
        content: "You guessed the word: $_wordToGuess",
        icon: Icons.check_circle,
        iconColor: Colors.greenAccent,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startLevel(_currentLevel + 1);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Next Level",
                style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
          ),
        ]);
  }

  void _showGameOverDialog() {
    _showThemedDialog(
        title: "Out of Lives!",
        content:
            "Watch an ad to get 2 more lives, or wait for them to regenerate.",
        icon: Icons.heart_broken,
        iconColor: Colors.redAccent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close",
                style: GoogleFonts.orbitron(color: Colors.white70)),
          ),
          ElevatedButton.icon(
            onPressed: _watchAdForLives,
            icon: const Icon(Icons.slow_motion_video),
            label: Text("Watch Ad (+2 Lives)",
                style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ]);
  }

  void _showGameWonDialog() {
    _showThemedDialog(
        title: "VICTORY!",
        content: "You have completed all the levels!",
        icon: Icons.emoji_events,
        iconColor: Colors.amber,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Awesome!",
                style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
          ),
        ]);
  }
}
