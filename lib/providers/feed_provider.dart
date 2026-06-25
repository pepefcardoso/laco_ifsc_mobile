import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../core/services/firestore_service.dart';
import '../core/services/storage_service.dart';

class FeedProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _postsSubscription;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void loadPosts(String groupId) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _postsSubscription?.cancel();
    _postsSubscription = _firestoreService.getGroupPostsStream(groupId).listen((posts) {
      _posts = posts;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao carregar os posts: $e';
      notifyListeners();
    });
  }

  Future<bool> createPost(String authorId, String groupId, String imagePath, String caption) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final file = File(imagePath);
      final postId = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('posts').doc().id;
      final storagePath = 'groups/$groupId/posts/$postId';
      
      final imageUrl = await _storageService.uploadImage(file, storagePath);
      
      if (imageUrl == null) {
        _isLoading = false;
        _errorMessage = 'Erro ao fazer upload da imagem.';
        notifyListeners();
        return false;
      }
      
      final post = PostModel(
        id: postId,
        authorId: authorId,
        groupId: groupId,
        imageUrl: imageUrl,
        caption: caption,
        reactions: {},
        createdAt: Timestamp.now(),
      );
      
      await _firestoreService.createPost(post);
      
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

  Future<void> reactToPost(String postId, String userId, String emoji, String groupId) async {
    try {
      await _firestoreService.reactToPost(postId, userId, emoji, groupId);
    } catch (e) {
      _errorMessage = 'Erro ao reagir ao post: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _postsSubscription?.cancel();
    super.dispose();
  }
}
