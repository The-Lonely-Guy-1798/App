import '../models.dart';
import 'firebase_article_service.dart';

class FirebaseArticleRepository {
  final ArticleService _articleService = ArticleService();

  Future<List<Article>> getNewlyAddedArticles({int limit = 5}) async {
    try {
      final firebaseArticles =
          await _articleService.getNewlyAddedArticles(limit: limit);
      return firebaseArticles.map((fa) => fa.toLegacyArticle()).toList();
    } catch (e) {
      print('Repository Error fetching newly added articles: $e');
      rethrow;
    }
  }

  // ✅ THIS METHOD HAS BEEN ADDED BACK TO FIX THE ERROR
  Future<List<Article>> getTrendingArticles({
    required String category,
    int limit = 2,
  }) async {
    try {
      final firebaseArticles = await _articleService.getTrendingArticles(
          category: category, limit: limit);
      return firebaseArticles.map((fa) => fa.toLegacyArticle()).toList();
    } catch (e) {
      print('Repository Error fetching trending articles: $e');
      rethrow;
    }
  }

  // This method is still needed for the ArticleListScreen
  Future<List<Article>> getArticlesByCategory(String categoryName) async {
    try {
      final firebaseArticles =
          await _articleService.getArticlesByCategory(categoryName);
      return firebaseArticles.map((fa) => fa.toLegacyArticle()).toList();
    } catch (e) {
      print(
          'Repository Error fetching articles for category "$categoryName": $e');
      rethrow;
    }
  }
}
