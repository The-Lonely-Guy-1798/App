import 'dart:math';
import 'models.dart';

class MockData {
  static List<Article> _getAllArticles() {
    final categories = ['Finance & Crypto', 'Entertainment', 'Sports', 'World'];
    final allArticles = <Article>[];
    for (var category in categories) {
      allArticles.addAll(getArticlesByCategory(category));
    }
    return allArticles;
  }

  static List<Article> getArticlesByCategory(String category) {
    final random = Random();
    return List.generate(20, (index) {
      final date = DateTime.now()
          .subtract(Duration(days: index * 2 + random.nextInt(5)));
      return Article(
        id: '$category-$index',
        title: 'Exploring the World of $category in ${date.year}',
        imageUrl: 'https://via.placeholder.com/400x250?text=$category+News',
        author: 'Jane Smith',
        publishedDate: '${date.day}/${date.month}/${date.year}',
        category: category,
        content:
            'This is the full article content about $category. It discusses various trends and provides in-depth analysis. ' *
                20,
        views: random.nextInt(95000) + 5000,
      );
    });
  }

  static List<Article> getTrendingArticles(String category) {
    final articles = getArticlesByCategory(category);
    articles.sort((a, b) => b.views.compareTo(a.views));
    return articles.take(3).toList();
  }

  static List<Article> getNewlyAddedArticles() {
    final articles = _getAllArticles();
    articles.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    return articles.take(5).toList();
  }

  static Story? getStoryById(String id) {
    try {
      String title;
      if (id.startsWith('Originals-')) {
        title = 'Originals Story ${id.split('-').last}';
      } else if (id.startsWith('Fan-Fiction-')) {
        title = 'Fan-Fiction Story ${id.split('-').last}';
      } else if (id.startsWith('newly-')) {
        title = 'Newly Added Story ${int.parse(id.split('-').last) + 1}';
      } else if (id.startsWith('daily-')) {
        title = 'Daily Story ${int.parse(id.split('-').last) + 1}';
      } else {
        title = 'Story ID: $id';
      }
      return Story(
        id: id,
        title: title,
        imageUrl:
            'https://via.placeholder.com/150x220?text=${title.replaceAll(' ', '+').substring(0, 8)}',
      );
    } catch (e) {
      return null;
    }
  }
}
