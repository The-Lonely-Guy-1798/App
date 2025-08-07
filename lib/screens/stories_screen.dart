// lib/screens/stories_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../models.dart';
import '../services/story_repository.dart';
import 'story_detail_screen.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = "Originals";

  final TextEditingController _searchController = TextEditingController();
  List<Story> _allStoriesForCategory = [];
  List<Story> _filteredStories = [];

  Timer? _debounce;

  bool _isShowingSuggestions = false;
  int _currentPage = 1;
  final int _storiesPerPage = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStories(_selectedCategory);
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _filterStories);
  }

  Future<void> _fetchStories(String category) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = context.read<StoryRepository>();
      final fetchedStories = await repository.getStoriesForCategory(category);

      if (mounted) {
        setState(() {
          _allStoriesForCategory = fetchedStories;
          _filterStories(isInitialLoad: true);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load stories.";
        });
      }
    }
  }

  // ✅ NEW NAVIGATION FUNCTION
  Future<void> _navigateToDetail(Story story) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StoryDetailScreen(story: story),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    if (mounted) {
      _fetchStories(_selectedCategory);
    }
  }

  void _filterStories({bool isInitialLoad = false}) {
    final query = _searchController.text.toLowerCase();

    if (isInitialLoad) {
      setState(() {
        _filteredStories = List.from(_allStoriesForCategory);
        _isShowingSuggestions = false;
        _currentPage = 1;
      });
      return;
    }

    final results = _allStoriesForCategory
        .where((story) => story.title.toLowerCase().contains(query))
        .toList();

    if (query.isNotEmpty && results.isEmpty) {
      final suggestions = List.from(_allStoriesForCategory)..shuffle();
      _filteredStories = List<Story>.from(suggestions.take(3));
      _isShowingSuggestions = true;
    } else {
      _filteredStories = results;
      _isShowingSuggestions = false;
    }

    if (mounted) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

  int get _totalPages => (_filteredStories.length / _storiesPerPage).ceil();

  List<Story> get _paginatedStories {
    final int startIndex = (_currentPage - 1) * _storiesPerPage;
    int endIndex = startIndex + _storiesPerPage;
    if (endIndex > _filteredStories.length) {
      endIndex = _filteredStories.length;
    }
    return _filteredStories.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories',
            style: GoogleFonts.orbitron(
                fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategorySelector(),
              const SizedBox(height: 10),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildGridShimmer();
    if (_errorMessage != null) return _buildErrorState();
    if (_allStoriesForCategory.isEmpty) return _buildEmptyState();

    return Column(
      children: [
        if (_isShowingSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
            child: Text(
              'No results found. Maybe you\'d like...',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontStyle: FontStyle.italic),
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            itemCount: _paginatedStories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              // ✅ UPDATED TO USE THE NEW NAVIGATION FUNCTION
              return StoryCard(
                story: _paginatedStories[index],
                onTap: () => _navigateToDetail(_paginatedStories[index]),
              );
            },
          ),
        ),
        if (!_isShowingSuggestions)
          PaginationControls(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPageChanged: (page) => setState(() => _currentPage = page),
          ),
        const SizedBox(height: 85),
      ],
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final hintColor =
        theme.colorScheme.onSurface.withAlpha((255 * 0.5).round());

    return TextField(
      controller: _searchController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Search for stories...',
        hintStyle: TextStyle(color: hintColor),
        prefixIcon: Icon(Icons.search, color: hintColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.zero,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: hintColor),
                onPressed: () {
                  _searchController.clear();
                },
              )
            : null,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCategoryButton("Originals"),
        const SizedBox(width: 20),
        _buildCategoryButton("Fan-Fiction"),
      ],
    );
  }

  Widget _buildCategoryButton(String label) {
    final isSelected = label == _selectedCategory;
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_selectedCategory != label) {
                _searchController.clear();
                setState(() {
                  _selectedCategory = label;
                });
                _fetchStories(label);
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? theme.colorScheme.primary : theme.cardColor,
        foregroundColor: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildGridShimmer() {
    final theme = Theme.of(context);
    final placeholderColor = theme.cardColor;

    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.dark
          ? Colors.grey[900]!
          : Colors.grey[200]!,
      highlightColor: theme.brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[100]!,
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: placeholderColor,
                        borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 8),
            Container(height: 14, width: 120, color: placeholderColor),
            const SizedBox(height: 4),
            Container(height: 14, width: 80, color: placeholderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 60),
      const SizedBox(height: 20),
      Text(_errorMessage!,
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: () => _fetchStories(_selectedCategory),
          child: const Text('Try Again'))
    ]));
  }

  Widget _buildEmptyState() {
    return const Center(
        child: Text('No stories found in this category.',
            style: TextStyle(fontSize: 16)));
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap; // ✅ UPDATED
  const StoryCard(
      {super.key, required this.story, required this.onTap}); // ✅ UPDATED

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ UPDATED
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              story.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Theme.of(context).colorScheme.surface,
                child: Icon(Icons.image_not_supported,
                    color: Theme.of(context).dividerColor, size: 40),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary));
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((255 * 0.8).round())
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                story.title,
                style: GoogleFonts.exo2(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  const PaginationControls(
      {super.key,
      required this.currentPage,
      required this.totalPages,
      required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox(height: 48);

    final theme = Theme.of(context);
    final enabledColor = theme.colorScheme.onSurface;
    final disabledColor = theme.disabledColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton(
              context,
              Icons.first_page,
              currentPage > 1 ? () => onPageChanged(1) : null,
              enabledColor,
              disabledColor),
          _buildNavButton(
              context,
              Icons.chevron_left,
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              enabledColor,
              disabledColor),
          const SizedBox(width: 16),
          Text('Page $currentPage of $totalPages',
              style:
                  GoogleFonts.exo2(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          _buildNavButton(
              context,
              Icons.chevron_right,
              currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              enabledColor,
              disabledColor),
          _buildNavButton(
              context,
              Icons.last_page,
              currentPage < totalPages ? () => onPageChanged(totalPages) : null,
              enabledColor,
              disabledColor),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon,
      VoidCallback? onPressed, Color enabledColor, Color disabledColor) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: onPressed != null ? enabledColor : disabledColor),
      splashRadius: 20,
    );
  }
}
