// lib/services/story_repository.dart

import 'package:freemium_novels_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Assuming these service files exist for other parts of the app
import 'firebase_story_service.dart';
import 'firebase_chapter_service.dart';

class StoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StoryService _storyService = StoryService();
  final ChapterService _chapterService = ChapterService();

  Future<HomePageData> getHomePageData() async {
    try {
      print("--- STARTING HOMEPAGE DATA FETCH ---");

      // 1. Fetch all published stories
      final storiesSnapshot = await _firestore
          .collection('stories')
          .where('status', isEqualTo: 'Published')
          .get();
      final allPublishedStories = storiesSnapshot.docs
          .map((doc) => FirebaseStory.fromFirestore(doc))
          .toList();
      print("✅ Step 1: Found ${allPublishedStories.length} Published stories.");

      // 2. Fetch Newly Added Stories (Last 5 created)
      final newlyAddedSnapshot = await _firestore
          .collection('stories')
          .where('status', isEqualTo: 'Published')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();
      final newlyAddedStories = newlyAddedSnapshot.docs
          .map((doc) =>
              Story.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      print("✅ Step 2: Found ${newlyAddedStories.length} newly added stories.");

      // 3. Fetch all chapters for trending calculation
      final chaptersSnapshot = await _firestore.collection('chapters').get();
      final allChapters = chaptersSnapshot.docs
          .map((doc) => FirebaseChapter.fromFirestore(doc))
          .toList();
      print(
          "✅ Step 3: Found ${allChapters.length} total chapters in the database.");

      // 4. Calculate Trending based on chapter views in time windows
      print("--- Calculating Trending Stories ---");
      final now = DateTime.now();

      List<TrendingStory> calculateTrending(Duration duration) {
        final timeLimit = now.subtract(duration);
        Map<String, int> storyViewCounts = {};

        final recentChapters = allChapters.where((c) {
          return c.updatedAt.isAfter(timeLimit);
        });
        print(
            "Found ${recentChapters.length} chapters viewed within the last ${duration.inDays > 0 ? '${duration.inDays} days' : '${duration.inHours} hours'}.");

        for (var chapter in recentChapters) {
          storyViewCounts.update(
              chapter.storyId, (value) => value + chapter.views,
              ifAbsent: () => chapter.views);
        }

        return allPublishedStories
            .map((story) {
              return TrendingStory(
                id: story.id,
                title: story.title,
                coverImageUrl: story.coverImage,
                views: storyViewCounts[story.id] ?? 0,
              );
            })
            .where((s) => s.views > 0)
            .toList()
          ..sort((a, b) => b.views.compareTo(a.views));
      }

      final dailyTrending =
          calculateTrending(const Duration(hours: 24)).take(3).toList();
      final weeklyTrending =
          calculateTrending(const Duration(days: 7)).take(3).toList();
      final monthlyTrending =
          calculateTrending(const Duration(days: 28)).take(3).toList();
      print(
          "✅ Step 4: Calculated trending stories. Daily: ${dailyTrending.length}, Weekly: ${weeklyTrending.length}, Monthly: ${monthlyTrending.length}");

      // 5. Fetch Latest Updates (Last 5 stories whose documents were updated)
      final latestUpdatesSnapshot = await _firestore
          .collection('stories')
          .where('status', isEqualTo: 'Published')
          .orderBy('updatedAt', descending: true)
          .limit(5)
          .get();
      final latestUpdates = latestUpdatesSnapshot.docs
          .map((doc) =>
              LatestUpdate.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      print("✅ Step 5: Found ${latestUpdates.length} latest update stories.");

      print("--- HOMEPAGE DATA FETCH COMPLETE ---");
      return HomePageData(
        newlyAddedStories: newlyAddedStories,
        dailyTrending: dailyTrending,
        weeklyTrending: weeklyTrending,
        monthlyTrending: monthlyTrending,
        latestUpdates: latestUpdates,
      );
    } catch (e) {
      print("❌ CRITICAL ERROR fetching home page data: $e");
      rethrow;
    }
  }

  // ✅ METHOD RESTORED for AllUpdatesScreen
  Future<List<LatestUpdate>> getRecentUpdates() async {
    try {
      final timeLimit = DateTime.now().subtract(const Duration(hours: 48));
      final snapshot = await _firestore
          .collection('stories')
          .where('status', isEqualTo: 'Published')
          .where('updatedAt', isGreaterThanOrEqualTo: timeLimit)
          .orderBy('updatedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) =>
              LatestUpdate.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ METHOD RESTORED for StoriesScreen
  Future<List<Story>> getStoriesForCategory(String category,
      {int page = 1, int storiesPerPage = 10}) async {
    try {
      List<FirebaseStory> firebaseStories =
          await _storyService.getStoriesByCategory(category);
      int start = (page - 1) * storiesPerPage;
      int end = (start + storiesPerPage).clamp(0, firebaseStories.length);
      if (start >= firebaseStories.length) return [];
      return firebaseStories
          .sublist(start, end)
          .map((fs) => fs.toLegacyStory())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ METHOD RESTORED for StoryDetailScreen
  Future<StoryDetail> getStoryDetail(
      String storyId, String title, String imageUrl) async {
    try {
      return await _storyService.getStoryDetail(storyId);
    } catch (e) {
      rethrow;
    }
  }

  // This method is not in your error list, but it's good to keep
  Future<String> getChapterContent(String storyId, int chapterNumber) async {
    try {
      return await _chapterService.getChapterContent(storyId, chapterNumber);
    } catch (e) {
      rethrow;
    }
  }

  // ✅ METHOD RESTORED for ReadingListScreen
  Future<List<Story>> getStoriesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      final snapshot = await _firestore
          .collection('stories')
          .where(FieldPath.documentId, whereIn: ids)
          .get();
      return snapshot.docs
          .map((doc) => Story.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ METHOD RESTORED for ReadingListScreen
  Future<List<String>> getReadingListStoryIds(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('readingList')
          .orderBy('savedAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      rethrow;
    }
  }
}
