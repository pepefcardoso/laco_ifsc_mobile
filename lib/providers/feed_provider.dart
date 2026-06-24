import 'package:flutter/material.dart';
import '../models/post_model.dart';

class FeedProvider with ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> createPost(String authorId, String groupId, String imagePath, String caption) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Stub post creation
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> reactToPost(String postId, String userId, String emoji) async {
    // Stub reaction logic
    notifyListeners();
  }
}
