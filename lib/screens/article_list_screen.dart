// lib/screens/article_list_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freemium_novels_app/models.dart';
import '../services/firebase_article_repository.dart'; // Firebase Repo
import 'article_detail_screen.dart';
import '../widgets/common/app_background.dart'; // App Background

class ArticleListScreen extends StatefulWidget {
  final String categoryName;

  const ArticleListScreen({super.key, required this.categoryName});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Article> _articles = [];
  final FirebaseArticleRepository _articleRepository =
      FirebaseArticleRepository(); // Firebase

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles =
          await _articleRepository.getArticlesByCategory(widget.categoryName);

      if (mounted) {
        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Failed to load articles. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildShimmer();
    if (_errorMessage != null) return _buildErrorState();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: _buildHeader(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        if (_articles.isEmpty)
          SliverFillRemaining(child: _buildEmptyState())
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListItemAnimation(
                    index: index,
                    child: ArticleListItem(
                      article: _articles[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleDetailScreen(article: _articles[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: _articles.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    IconData icon;
    switch (widget.categoryName) {
      case 'Finance & Crypto':
        icon = FontAwesomeIcons.moneyBillTrendUp;
        break;
      case 'Entertainment':
        icon = FontAwesomeIcons.film;
        break;
      case 'Sports':
        icon = FontAwesomeIcons.futbol;
        break;
      case 'World':
        icon = FontAwesomeIcons.globe;
        break;
      default:
        icon = Icons.article;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          widget.categoryName,
          style:
              GoogleFonts.orbitron(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(_errorMessage!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: _fetchArticles, child: const Text('Try Again'))
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No articles found in this category.',
          style: TextStyle(fontSize: 16, color: Colors.grey)),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Container(
                    height: 180, width: double.infinity, color: Colors.black),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 20,
                          width: double.infinity,
                          color: Colors.black),
                      const SizedBox(height: 8),
                      Container(height: 14, width: 150, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ArticleListItem extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleListItem({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shadowColor: theme.shadowColor.withAlpha((255 * 0.2).round()),
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: theme.colorScheme.surface,
                  child: const Icon(Icons.image_not_supported, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: GoogleFonts.exo2(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${article.author} • ${article.publishedDate}',
                    style: GoogleFonts.exo2(
                        fontSize: 12, color: theme.textTheme.bodySmall?.color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItemAnimation extends StatefulWidget {
  final int index;
  final Widget child;
  const ListItemAnimation(
      {super.key, required this.index, required this.child});

  @override
  State<ListItemAnimation> createState() => _ListItemAnimationState();
}

class _ListItemAnimationState extends State<ListItemAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    final delay = Duration(milliseconds: widget.index * 75);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
