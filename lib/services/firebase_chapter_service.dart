import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemium_novels_app/models.dart';

class ChapterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'chapters';

  // Create a new chapter
  Future<String> createChapter(FirebaseChapter chapter) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(_collection).add(chapter.toFirestore());

      // Update story chapter count
      await _updateStoryChapterCount(chapter.storyId);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create chapter: $e');
    }
  }

  // Get chapters for a specific story
  Future<List<FirebaseChapter>> getChaptersByStoryId(
    String storyId, {
    String? statusFilter,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('storyId', isEqualTo: storyId);

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs
          .map((doc) => FirebaseChapter.fromFirestore(doc))
          .toList()
        ..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    } catch (e) {
      throw Exception('Failed to fetch chapters: $e');
    }
  }

  // Get a single chapter by ID
  Future<FirebaseChapter> getChapterById(String chapterId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc(chapterId).get();

      if (!doc.exists) {
        throw Exception('Chapter not found');
      }

      return FirebaseChapter.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch chapter: $e');
    }
  }

  // Get chapter content for reading
  Future<String> getChapterContent(String storyId, int chapterNumber) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('storyId', isEqualTo: storyId)
          .where('chapterNumber', isEqualTo: chapterNumber)
          .where('status', isEqualTo: 'published')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Chapter not found or not published');
      }

      FirebaseChapter chapter =
          FirebaseChapter.fromFirestore(snapshot.docs.first);
      return chapter.content;
    } catch (e) {
      throw Exception('Failed to fetch chapter content: $e');
    }
  }

  // Update a chapter
  Future<void> updateChapter(
      String chapterId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();

      if (updates.containsKey('content')) {
        updates['wordCount'] = _calculateWordCount(updates['content']);
      }

      await _firestore.collection(_collection).doc(chapterId).update(updates);
    } catch (e) {
      throw Exception('Failed to update chapter: $e');
    }
  }

  // Delete a chapter
  Future<void> deleteChapter(String chapterId) async {
    try {
      FirebaseChapter chapter = await getChapterById(chapterId);

      await _firestore.collection(_collection).doc(chapterId).delete();

      // Update story chapter count
      await _updateStoryChapterCount(chapter.storyId);
    } catch (e) {
      throw Exception('Failed to delete chapter: $e');
    }
  }

  // Delete all chapters for a story (used in cascading delete)
  Future<void> deleteChaptersByStoryId(String storyId) async {
    try {
      List<FirebaseChapter> chapters = await getChaptersByStoryId(storyId);

      WriteBatch batch = _firestore.batch();

      for (FirebaseChapter chapter in chapters) {
        batch.delete(_firestore.collection(_collection).doc(chapter.id));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete chapters for story: $e');
    }
  }

  // Get next chapter number for a story
  Future<int> getNextChapterNumber(String storyId) async {
    try {
      List<FirebaseChapter> chapters = await getChaptersByStoryId(storyId);

      if (chapters.isEmpty) return 1;

      int maxChapterNumber = chapters
          .map((chapter) => chapter.chapterNumber)
          .reduce((a, b) => a > b ? a : b);

      return maxChapterNumber + 1;
    } catch (e) {
      throw Exception('Failed to get next chapter number: $e');
    }
  }

  // Sum all chapter views for a story and update the story's views in Firestore
  Future<void> updateStoryViewsFromChapters(String storyId) async {
    try {
      final chapters = await getChaptersByStoryId(storyId);
      final totalViews =
          chapters.fold<int>(0, (sum, chapter) => sum + (chapter.views ?? 0));
      await _firestore
          .collection('stories')
          .doc(storyId)
          .update({'views': totalViews});
    } catch (e) {
      print('Failed to update story views: $e');
    }
  }

  // Helper function to update story chapter count
  Future<void> _updateStoryChapterCount(String storyId) async {
    try {
      List<FirebaseChapter> publishedChapters = await getChaptersByStoryId(
        storyId,
        statusFilter: 'published',
      );

      await _firestore.collection('stories').doc(storyId).update({
        'chapters': publishedChapters.length,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to update story chapter count: $e');
    }
  }

  // Helper function to calculate word count
  int _calculateWordCount(String content) {
    if (content.isEmpty) return 0;

    String plainText = content.replaceAll(RegExp(r'<[^>]*>'), '');
    List<String> words = plainText.trim().split(RegExp(r'\s+'));
    return words.where((word) => word.isNotEmpty).length;
  }
}
