import 'dart:math';
import 'package:flutter/material.dart';
import 'package:freemium_novels_app/widgets/common/app_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'word_connect_data.dart';

class LetterNode {
  final String letter;
  Offset position;
  final int index;
  bool isSelected = false;

  LetterNode(this.letter, this.position, this.index);
}

class WordConnectScreen extends StatefulWidget {
  const WordConnectScreen({super.key});

  @override
  State<WordConnectScreen> createState() => _WordConnectScreenState();
}

class _WordConnectScreenState extends State<WordConnectScreen>
    with TickerProviderStateMixin {
  int _currentLevelIndex = 0;
  late WordConnectLevel _currentLevel;

  final Set<String> _foundWords = {};
  final List<LetterNode> _letterNodes = [];
  final List<LetterNode> _currentPath = [];
  Offset? _panPosition;
  String _currentWord = "";

  Color _feedbackColor = Colors.transparent;
  late AnimationController _feedbackController;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {});
      });
    _loadLevel();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _loadLevel() {
    setState(() {
      _currentLevel = wordConnectLevels[_currentLevelIndex];
      _foundWords.clear();
      _currentPath.clear();
      _currentWord = "";
      _letterNodes.clear();
      for (int i = 0; i < _currentLevel.letters.length; i++) {
        _letterNodes.add(LetterNode(_currentLevel.letters[i], Offset.zero, i));
      }
    });
  }

  void _updateLetterNodePositions(Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.35;
    final angleStep = (2 * pi) / _letterNodes.length;

    for (int i = 0; i < _letterNodes.length; i++) {
      final angle = i * angleStep - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      _letterNodes[i].position = Offset(x, y);
    }
  }

  void _onPanStart(DragStartDetails details) {
    _checkLetterInteraction(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _panPosition = details.localPosition;
    });
    _checkLetterInteraction(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _submitWord();
    setState(() {
      for (var node in _letterNodes) {
        node.isSelected = false;
      }
      _currentPath.clear();
      _panPosition = null;
    });
  }

  void _checkLetterInteraction(Offset position) {
    for (var node in _letterNodes) {
      if (node.position != Offset.zero) {
        final distance = (position - node.position).distance;
        if (distance < 30 && !node.isSelected) {
          setState(() {
            node.isSelected = true;
            _currentPath.add(node);
            _currentWord = _currentPath.map((n) => n.letter).join();
          });
        }
      }
    }
  }

  void _submitWord() {
    if (_currentWord.isEmpty) return;

    if (_currentLevel.solutions.contains(_currentWord) &&
        !_foundWords.contains(_currentWord)) {
      setState(() {
        _foundWords.add(_currentWord);
        _feedbackColor = Colors.greenAccent;
      });
      if (_foundWords.length == _currentLevel.solutions.length) {
        _showLevelCompleteDialog();
      }
    } else if (_foundWords.contains(_currentWord)) {
      _feedbackColor = Colors.amber;
    } else {
      _feedbackColor = Colors.redAccent;
    }
    _feedbackController.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentWord = "";
        });
      }
    });
  }

  void _showLevelCompleteDialog() {
    // MODIFIED: Check theme brightness to set dialog colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor =
        (isDarkMode ? Colors.grey[900] : Colors.white)!.withOpacity(0.95);
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final contentColor = isDarkMode ? Colors.white70 : Colors.black54;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
        ),
        title: Text("Level Complete!",
            style: GoogleFonts.orbitron(color: titleColor)),
        content: Text("You found all the words!",
            style: GoogleFonts.exo2(color: contentColor)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentLevelIndex =
                    (_currentLevelIndex + 1) % wordConnectLevels.length;
                _loadLevel();
              });
            },
            child: Text("Next Level",
                style: GoogleFonts.orbitron(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MODIFIED: Check theme brightness to set colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultTextColor = isDarkMode ? Colors.white : Colors.black;
    final adPlaceholderBg = isDarkMode ? Colors.black54 : Colors.white70;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Word Connect',
            style: GoogleFonts.orbitron(color: defaultTextColor)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // MODIFIED: Make icon theme-aware and remove const
        iconTheme: IconThemeData(color: defaultTextColor),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildFoundWordsGrid(),
              _buildCurrentWordDisplay(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _updateLetterNodePositions(constraints.biggest);
                    return GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: CustomPaint(
                        // MODIFIED: Pass theme info to the painter
                        painter: _WordCirclePainter(
                          nodes: _letterNodes,
                          currentPath: _currentPath,
                          panPosition: _panPosition,
                          isDarkMode: isDarkMode,
                        ),
                        child: Container(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: adPlaceholderBg, // MODIFIED
                margin: const EdgeInsets.all(8),
                child: Center(
                  child: Text('Ad Placeholder',
                      style: TextStyle(color: defaultTextColor)), // MODIFIED
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWordDisplay() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultTextColor = isDarkMode ? Colors.white : Colors.black;

    final isAnimating = _feedbackController.isAnimating;
    // MODIFIED: Use the theme-aware default color
    final displayColor = isAnimating
        ? Color.lerp(
            _feedbackColor, defaultTextColor, _feedbackController.value)!
        : defaultTextColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Text(
        _currentWord.isEmpty ? " " : _currentWord,
        style: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: displayColor,
          letterSpacing: 4,
          shadows: [
            Shadow(color: displayColor.withOpacity(0.4), blurRadius: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFoundWordsGrid() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final notFoundBg = isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.1);
    final borderColor =
        (isDarkMode ? Colors.white : Colors.black).withOpacity(0.2);
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.25,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 120,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _currentLevel.solutions.length,
        itemBuilder: (context, index) {
          final word = _currentLevel.solutions.elementAt(index);
          final isFound = _foundWords.contains(word);
          return Container(
            decoration: BoxDecoration(
              color: isFound ? Colors.cyanAccent.withOpacity(0.2) : notFoundBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            alignment: Alignment.center,
            child: Text(
              isFound ? word : "•" * word.length,
              style: GoogleFonts.exo2(
                color: textColor,
                fontSize: 18,
                fontWeight: isFound ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WordCirclePainter extends CustomPainter {
  final List<LetterNode> nodes;
  final List<LetterNode> currentPath;
  final Offset? panPosition;
  final bool isDarkMode; // NEW: Receive theme info

  _WordCirclePainter({
    required this.nodes,
    required this.currentPath,
    required this.panPosition,
    required this.isDarkMode, // NEW
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.35;

    final linePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.7)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // MODIFIED: Make painter colors theme-aware
    final circlePaint = Paint()
      ..color = isDarkMode ? Colors.white24 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final selectedCirclePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, circlePaint);

    for (var node in nodes) {
      final isSelected = currentPath.contains(node);

      if (isSelected) {
        canvas.drawCircle(node.position, 30, selectedCirclePaint);
      }

      // MODIFIED: Make text color theme-aware
      final letterColor = isSelected
          ? (isDarkMode ? Colors.black : Colors.white)
          : (isDarkMode ? Colors.white70 : Colors.black87);

      final textSpan = TextSpan(
        text: node.letter,
        style: GoogleFonts.orbitron(
          color: letterColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        node.position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    if (currentPath.length > 1) {
      for (int i = 0; i < currentPath.length - 1; i++) {
        canvas.drawLine(
            currentPath[i].position, currentPath[i + 1].position, linePaint);
      }
    }

    if (currentPath.isNotEmpty && panPosition != null) {
      canvas.drawLine(currentPath.last.position, panPosition!, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
