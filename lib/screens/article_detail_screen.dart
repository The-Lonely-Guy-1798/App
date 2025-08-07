import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models.dart';
import '../widgets/common/app_background.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  List<Article> _recommendedArticles = [];
  bool _isLoadingRecommendations = true;

  @override
  void initState() {
    super.initState();
    _incrementArticleViews();
    _fetchRecommendations();
  }

  Future<void> _incrementArticleViews() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.article.id);
      await docRef.update({'views': FieldValue.increment(1)});
    } catch (e) {
      // Optionally log or handle error
    }
  }

  Future<void> _fetchRecommendations() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .where('status', isEqualTo: 'Published')
          .get();
      final allArticles = querySnapshot.docs
          .map((doc) => FirebaseArticle.fromFirestore(doc).toLegacyArticle())
          .where((a) => a.id != widget.article.id)
          .toList();
      allArticles.shuffle();
      if (mounted) {
        setState(() {
          _recommendedArticles = allArticles.take(3).toList();
          _isLoadingRecommendations = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recommendedArticles = [];
          _isLoadingRecommendations = false;
        });
      }
    }
  }

  void _shareArticle(BuildContext context) {
    final String textToShare =
        'Check out this article: ${widget.article.title}\n\nRead more at: https://yourapp.com/articles/${widget.article.id}';
    Share.share(textToShare, subject: 'An interesting article from Fabula');
  }

  void _navigateToArticle(Article article) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ArticleDetailScreen(article: article),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.article.category,
                  style: GoogleFonts.orbitron(
                    shadows: const [Shadow(blurRadius: 8)],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.image_not_supported)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(150)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Share Article',
                  onPressed: () => _shareArticle(context),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.title,
                      style: GoogleFonts.orbitron(
                        textStyle: theme.textTheme.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Views: ${widget.article.views}',
                      style: GoogleFonts.exo2(
                        textStyle: theme.textTheme.bodyMedium,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const Divider(height: 32),
                    Html(
                      data: widget.article.content,
                      style: {
                        "body": Style(
                          fontSize: FontSize(16.0),
                          color: theme.textTheme.bodyLarge?.color,
                          fontFamily: GoogleFonts.exo2().fontFamily,
                          lineHeight: LineHeight(1.6),
                        ),
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildReadAlsoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadAlsoSection() {
    if (_isLoadingRecommendations || _recommendedArticles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        Text(
          'Read Also',
          style: GoogleFonts.orbitron(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._recommendedArticles.map((article) => _RecommendedArticleCard(
              article: article,
              onTap: () => _navigateToArticle(article),
            )),
      ],
    );
  }
}

class _RecommendedArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const _RecommendedArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.network(
              article.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: theme.scaffoldBackgroundColor,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: GoogleFonts.exo2(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By ${article.author}',
                      style: GoogleFonts.exo2(
                          fontSize: 12,
                          color: theme.textTheme.bodySmall?.color),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
