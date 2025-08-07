// lib/screens/chapter_content_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemium_novels_app/widgets/common/app_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models.dart';

class ChapterContentScreen extends StatefulWidget {
  final StoryDetail storyDetail;
  final int initialChapterIndex;

  const ChapterContentScreen({
    super.key,
    required this.storyDetail,
    required this.initialChapterIndex,
  });

  @override
  State<ChapterContentScreen> createState() => _ChapterContentScreenState();
}

class _ChapterContentScreenState extends State<ChapterContentScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  String _chapterContent = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialChapterIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _loadChapterContent(_currentIndex);
  }

  Future<void> _loadChapterContent(int index) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final chapterNumber = widget.storyDetail.chapters[index].chapterNumber;
      final content = await _getChapterContentFromFirebase(chapterNumber);

      if (mounted) {
        setState(() {
          _chapterContent = content;
          _isLoading = false;
        });
        _incrementViews(chapterNumber);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _chapterContent = "Failed to load chapter content.";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _incrementViews(int chapterNumber) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final storyRef =
          firestore.collection('stories').doc(widget.storyDetail.id);

      // Find the specific chapter document to update its views
      final chapterQuery = await firestore
          .collection('chapters')
          .where('storyId', isEqualTo: widget.storyDetail.id)
          .where('chapterNumber', isEqualTo: chapterNumber)
          .limit(1)
          .get();

      if (chapterQuery.docs.isEmpty) return; // Chapter not found
      final chapterRef = chapterQuery.docs.first.reference;

      // Use a batched write to update all fields at once
      final batch = firestore.batch();

      // 1. Increment the story's total view count
      batch.update(storyRef, {'views': FieldValue.increment(1)});

      // 2. Increment this chapter's view count
      batch.update(chapterRef, {'views': FieldValue.increment(1)});

      // ✅ ADDED: Update the chapter's timestamp to the current time for trending calculation
      batch.update(chapterRef, {'updatedAt': FieldValue.serverTimestamp()});

      await batch.commit();
    } catch (e) {
      print("Failed to increment chapter/story views: $e");
      // Silently fail to not interrupt the user experience
    }
  }

  Future<String> _getChapterContentFromFirebase(int chapterNumber) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chapters')
        .where('storyId', isEqualTo: widget.storyDetail.id)
        .where('chapterNumber', isEqualTo: chapterNumber)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data()['content'] ?? 'Content not available.';
    }
    return 'Chapter not found.';
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _loadChapterContent(index);
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.storyDetail.chapters[_currentIndex];
    // ✅ DEFINE THE COLOR HERE
    final Color appBarTextColor =
        Theme.of(context).appBarTheme.foregroundColor ?? Colors.white;

    return AppBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.storyDetail.title,
              style: GoogleFonts.exo2(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: appBarTextColor, // ✅ APPLY THE COLOR
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              chapter.title,
              style: GoogleFonts.exo2(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: appBarTextColor, // ✅ APPLY THE COLOR
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: appBarTextColor,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.storyDetail.chapters.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          if (index != _currentIndex || _isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Html(data: _chapterContent),
          );
        },
      ),
    ));
  }
}
