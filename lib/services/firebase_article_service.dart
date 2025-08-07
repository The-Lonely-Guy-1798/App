// lib/services/firebase_article_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemium_novels_app/models.dart';

class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'articles';

  Future<List<FirebaseArticle>> getNewlyAddedArticles({int limit = 3}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => FirebaseArticle.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FirebaseArticle>> getTrendingArticles(
      {required String category, int limit = 3}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published')
          .where('category', isEqualTo: category)
          .orderBy('views', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => FirebaseArticle.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ ADD THIS METHOD BACK FOR THE ARTICLE LIST SCREEN
  Future<List<FirebaseArticle>> getArticlesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Published')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => FirebaseArticle.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
