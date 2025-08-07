import 'package:cloud_firestore/cloud_firestore.dart';
import '../models.dart';
import 'firebase_chapter_service.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'stories';

  // Create a new story
  Future<String> createStory(FirebaseStory story) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(story.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create story: $e');
    }
  }

  // Get all stories with optional filters
  Future<List<FirebaseStory>> getStories({
    String? statusFilter,
    String? categoryFilter,
  }) async {
    try {
      Query query = _firestore.collection(_collection);
      
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter);
      }
      
      if (categoryFilter != null) {
        query = query.where('category', isEqualTo: categoryFilter);
      }
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }

  // Debug method to get all stories without any filters
  Future<List<FirebaseStory>> getAllStoriesDebug() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      
      print('=== DEBUG: All Stories in Database ===');
      print('Total documents found: ${snapshot.docs.length}');
      
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Document ID: ${doc.id}');
        print('  Title: ${data['title'] ?? 'NO TITLE'}');
        print('  Status: ${data['status'] ?? 'NO STATUS'}');
        print('  Category: ${data['category'] ?? 'NO CATEGORY'}');
        print('  CreatedAt: ${data['createdAt'] ?? 'NO CREATEDAT'}');
        print('  UpdatedAt: ${data['updatedAt'] ?? 'NO UPDATEDAT'}');
        print('  ---');
      }
      
      return snapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('DEBUG ERROR: $e');
      throw Exception('Failed to fetch all stories for debug: $e');
    }
  }

  // Get published stories only (for public access)
  Future<List<FirebaseStory>> getPublishedStories({
    String? categoryFilter,
  }) async {
    try {
      // Since the database has "Published" (capitalized), we need to query for that
      Query query = _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published');
      
      if (categoryFilter != null) {
        // Also handle capitalized category values
        String dbCategory = categoryFilter == 'original' ? 'Original' : 'Fan-Fiction';
        query = query.where('category', isEqualTo: dbCategory);
      }
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      throw Exception('Failed to fetch published stories: $e');
    }
  }

  // Get stories by category for the Stories screen
  Future<List<FirebaseStory>> getStoriesByCategory(String category) async {
    try {
      // Map the UI category to the database category values
      String dbCategory;
      if (category.toLowerCase() == 'originals') {
        dbCategory = 'Original';
      } else {
        dbCategory = 'Fan-Fiction';
      }
      
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published')
          .where('category', isEqualTo: dbCategory)
          .get();
      
      return snapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      throw Exception('Failed to fetch stories by category: $e');
    }
  }

  // Get a single story by ID
  Future<FirebaseStory> getStoryById(String storyId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(storyId)
          .get();
          
      if (!doc.exists) {
        throw Exception('Story not found');
      }
      
      return FirebaseStory.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch story: $e');
    }
  }

  // Get story with its chapters for detail view
  Future<StoryDetail> getStoryDetail(String storyId) async {
    try {
      FirebaseStory story = await getStoryById(storyId);
      List<FirebaseChapter> chapters = await ChapterService().getChaptersByStoryId(storyId, statusFilter: 'published');
      
      // Convert Firebase models to legacy models for compatibility
      List<Chapter> legacyChapters = chapters.map((ch) => ch.toLegacyChapter()).toList();
      
      return StoryDetail(
        id: story.id,
        title: story.title,
        imageUrl: story.coverImage.isNotEmpty ? story.coverImage : 'https://via.placeholder.com/150x220?text=${story.title.replaceAll(' ', '+').substring(0, 8)}',
        author: 'Admin', // Default author
        views: 1234, // Mock views for now
        description: story.description,
        genres: [story.category], // Use category as genre
        chapters: legacyChapters,
      );
    } catch (e) {
      throw Exception('Failed to fetch story detail: $e');
    }
  }

  // Update a story
  Future<void> updateStory(String storyId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore
          .collection(_collection)
          .doc(storyId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update story: $e');
    }
  }

  // Delete a story and all its chapters
  Future<void> deleteStory(String storyId) async {
    try {
      // Delete all chapters first
      await ChapterService().deleteChaptersByStoryId(storyId);
      
      // Then delete the story
      await _firestore
          .collection(_collection)
          .doc(storyId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete story: $e');
    }
  }

  // Get stories stream for real-time updates
  Stream<List<FirebaseStory>> getStoriesStream() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'Published')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FirebaseStory.fromFirestore(doc))
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)));
  }

  // Get newly added stories for home screen
  Future<List<FirebaseStory>> getNewlyAddedStories({int limit = 5}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published')
          .limit(limit)
          .get();
      
      // Sort in memory instead of using orderBy to avoid index requirement
      List<FirebaseStory> stories = snapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList();
      
      stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return stories.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch newly added stories: $e');
    }
  }

  // Get trending stories (most recently updated)
  Future<List<FirebaseStory>> getTrendingStories({int limit = 3}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published')
          .limit(limit)
          .get();
      
      // Sort in memory instead of using orderBy to avoid index requirement
      List<FirebaseStory> stories = snapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList();
      
      stories.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return stories.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch trending stories: $e');
    }
  }
} 