import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ NEW HELPER FUNCTION TO CALCULATE "TIME AGO"
String _timeAgo(DateTime timestamp) {
  final difference = DateTime.now().difference(timestamp);
  if (difference.inDays >= 7) {
    return '${(difference.inDays / 7).floor()}w ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}

// --- Story & Chapter Models ---

class Story {
  final String id;
  final String title;
  final String imageUrl;

  Story({required this.id, required this.title, required this.imageUrl});

  factory Story.fromMap(String id, Map<String, dynamic> data) {
    return Story(
      id: id,
      title: data['title'] ?? 'No Title',
      imageUrl: data['coverImage'] ?? '',
    );
  }
}

class Chapter {
  final String title;
  final int chapterNumber;

  Chapter({required this.title, required this.chapterNumber});
}

class StoryDetail extends Story {
  final String author;
  final int views;
  final String description;
  final List<String> genres;
  final List<Chapter> chapters;

  StoryDetail({
    required super.id,
    required super.title,
    required super.imageUrl,
    required this.author,
    required this.views,
    required this.description,
    required this.genres,
    required this.chapters,
  });
}

// --- FIREBASE MODELS ---

class FirebaseStory {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String coverImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorId;
  final int chapterCount;
  final int views;

  FirebaseStory({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    this.coverImage = '',
    required this.createdAt,
    required this.updatedAt,
    required this.authorId,
    this.chapterCount = 0,
    this.views = 0,
  });

  factory FirebaseStory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String status = (data['status'] ?? 'draft').toString().toLowerCase();
    String category = (data['category'] ?? 'original').toString().toLowerCase();

    return FirebaseStory(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: category,
      status: status,
      coverImage: data['coverImage'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      authorId: data['authorId'] ?? '',
      chapterCount: data['chapters'] ?? 0,
      views: data['views'] ?? 0,
    );
  }

  // ✅ THIS METHOD HAS BEEN RESTORED
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'coverImage': coverImage,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'authorId': authorId,
      'chapters': chapterCount,
      'views': views,
    };
  }

  Story toLegacyStory() {
    return Story(
        id: id,
        title: title,
        imageUrl: coverImage.isNotEmpty
            ? coverImage
            : 'https://via.placeholder.com/150x220?text=${title.replaceAll(' ', '+').substring(0, 8)}');
  }
}

// Firebase Article Model
class FirebaseArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category; // 'Finance & Crypto' | 'Entertainment' | 'Sports'
  final String status; // 'draft' | 'published'
  final String coverImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int wordCount;
  final String authorId;
  final int views;

  FirebaseArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.status,
    this.coverImage = '',
    required this.createdAt,
    required this.updatedAt,
    required this.wordCount,
    required this.authorId,
    this.views = 0,
  });

  factory FirebaseArticle.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Normalize status to lowercase
    String status = (data['status'] ?? 'draft').toString().toLowerCase();

    // Normalize category to lowercase and handle variations
    String category =
        (data['category'] ?? 'Entertainment').toString().toLowerCase();
    if (category == 'finance & crypto' || category == 'finance and crypto') {
      category = 'Finance & Crypto';
    } else if (category == 'entertainment') {
      category = 'Entertainment';
    } else if (category == 'sports') {
      category = 'Sports';
    } else if (category == 'world') {
      category = 'World';
    }

    return FirebaseArticle(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      category: category,
      status: status,
      coverImage: data['coverImage'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      wordCount: data['wordCount'] ?? 0,
      authorId: data['authorId'] ?? '',
      views: data['views'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'category': category,
      'status': status,
      'coverImage': coverImage,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'wordCount': wordCount,
      'authorId': authorId,
      'views': views,
    };
  }

  // Convert to legacy Article model for compatibility
  Article toLegacyArticle() {
    return Article(
      id: id,
      title: title,
      imageUrl: coverImage.isNotEmpty
          ? coverImage
          : 'https://via.placeholder.com/400x250?text=${category.replaceAll(' ', '+')}+News',
      author: 'Admin',
      publishedDate: '${createdAt.day}/${createdAt.month}/${createdAt.year}',
      category: category,
      content: content,
      views: views,
    );
  }
}

// Firebase Chapter Model
class FirebaseChapter {
  final String id;
  final String storyId;
  final int chapterNumber;
  final String title;
  final String content;
  final String status; // 'draft' | 'published'
  final DateTime createdAt;
  final DateTime updatedAt;
  final int wordCount;
  final String authorId;
  final int views;

  FirebaseChapter({
    required this.id,
    required this.storyId,
    required this.chapterNumber,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.wordCount,
    required this.authorId,
    this.views = 0,
  });

  factory FirebaseChapter.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Normalize status to lowercase
    String status = (data['status'] ?? 'draft').toString().toLowerCase();

    return FirebaseChapter(
      id: doc.id,
      storyId: data['storyId'] ?? '',
      chapterNumber: data['chapterNumber'] ?? 1,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      status: status,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      wordCount: data['wordCount'] ?? 0,
      authorId: data['authorId'] ?? '',
      views: data['views'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storyId': storyId,
      'chapterNumber': chapterNumber,
      'title': title,
      'content': content,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'wordCount': wordCount,
      'authorId': authorId,
      'views': views,
    };
  }

  // Convert to legacy Chapter model for compatibility
  Chapter toLegacyChapter() {
    return Chapter(
      title: title,
      chapterNumber: chapterNumber,
    );
  }
}

class HomePageData {
  final List<Story> newlyAddedStories;
  final List<TrendingStory> dailyTrending;
  final List<TrendingStory> weeklyTrending;
  final List<TrendingStory> monthlyTrending;
  final List<LatestUpdate> latestUpdates;

  HomePageData({
    required this.newlyAddedStories,
    required this.dailyTrending,
    required this.weeklyTrending,
    required this.monthlyTrending,
    required this.latestUpdates,
  });
}

class TrendingStory {
  final String id;
  final String coverImageUrl;
  final String title;
  final int views;

  TrendingStory({
    required this.id,
    required this.coverImageUrl,
    required this.title,
    required this.views,
  });
}

class LatestUpdate {
  final String id;
  final String coverImageUrl;
  final String title;
  final String chapter;
  final String time;

  LatestUpdate({
    required this.id,
    required this.coverImageUrl,
    required this.title,
    required this.chapter,
    required this.time,
  });

  // ✅ THIS CONSTRUCTOR IS NOW FULLY UPDATED
  factory LatestUpdate.fromMap(String id, Map<String, dynamic> data) {
    final DateTime updatedAt =
        (data['updatedAt'] as Timestamp? ?? Timestamp.now()).toDate();

    return LatestUpdate(
      id: id,
      coverImageUrl: data['coverImage'] ?? '',
      title: data['title'] ?? 'No Title',
      // Reads your 'latestchapter' field
      chapter: data['latestchapter'] ?? 'New Update',
      // Calculates the 'time ago' string
      time: _timeAgo(updatedAt),
    );
  }
}

// --- Article Models ---

class Article {
  final String id;
  final String title;
  final String imageUrl;
  final String author;
  final String publishedDate;
  final String category;
  final String content;
  final int views;

  Article({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.publishedDate,
    required this.category,
    required this.content,
    required this.views,
  });
}

class ArticleCategory {
  final String name;
  final String imageUrl;
  ArticleCategory({required this.name, required this.imageUrl});
}

// --- Crypto Models ---

class CryptoCurrency {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;

  CryptoCurrency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
  });
}

class ReadingListStory {
  final Story story;
  final bool isUpdated;

  ReadingListStory({required this.story, required this.isUpdated});
}
