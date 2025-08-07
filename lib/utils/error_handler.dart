import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom Exception Classes
class FirebaseException implements Exception {
  final String message;
  final String code;

  FirebaseException(this.message, this.code);

  @override
  String toString() => 'FirebaseException: $message (Code: $code)';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  ValidationException(this.message, [this.fieldErrors]);

  @override
  String toString() => 'ValidationException: $message';
}

// Error Handler Utility
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You don\'t have permission to perform this action.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'unavailable':
          return 'Service temporarily unavailable. Please try again.';
        default:
          return error.message;
      }
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is FirebaseFirestore) {
      return 'Database error. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(error)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// Data Validation
class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Content is required';
    }
    if (value.length < 10) {
      return 'Content must be at least 10 characters';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    const validCategories = ['original', 'fan-fiction'];
    if (value == null || !validCategories.contains(value.toLowerCase())) {
      return 'Please select a valid category';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
} 