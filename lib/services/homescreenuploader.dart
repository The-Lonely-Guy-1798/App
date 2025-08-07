import 'package:flutter/material.dart';
import '../models.dart';
import 'package:freemium_novels_app/services/story_repository.dart';

class HomeScreenController extends ChangeNotifier {
  final StoryRepository _repository = StoryRepository();

  HomePageData? _data;
  bool _isLoading = false;
  String? _error;

  HomePageData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await _repository.getHomePageData();
    } catch (e) {
      _error = "Failed to load data";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadData();
  }
}
