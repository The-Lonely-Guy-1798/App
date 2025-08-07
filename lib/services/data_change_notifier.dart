// lib/services/data_change_notifier.dart

import 'package:flutter/material.dart';

class DataChangeNotifier extends ChangeNotifier {
  void dataChanged() {
    notifyListeners();
  }
}