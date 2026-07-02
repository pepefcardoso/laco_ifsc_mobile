import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../core/services/firestore_service.dart';
import '../core/services/storage_service.dart';
import 'auth_provider.dart';
import 'group_provider.dart';

class ProfileProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<PostModel> _userPosts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PostModel> get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserPosts(String uid, String groupId) async {
    if (groupId.isEmpty) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userPosts = await _firestoreService.getUserPosts(groupId, uid);
    } catch (e) {
      _errorMessage = 'Erro ao carregar os posts do usuário: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String uid,
    required String name,
    File? photoFile,
    required AuthProvider authProvider,
    required GroupProvider groupProvider,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? photoUrl;
      final oldPhotoUrl = authProvider.userModel?.photoUrl ?? '';
      
      if (photoFile != null) {
        if (oldPhotoUrl.isNotEmpty) {
          await CachedNetworkImage.evictFromCache(oldPhotoUrl);
        }
        
        final storagePath = 'avatars/$uid';
        photoUrl = await _storageService.uploadImage(photoFile, storagePath);
        if (photoUrl == null) {
          throw Exception('Falha ao fazer upload da imagem.');
        }
      }

      final Map<String, dynamic> dataToUpdate = {'name': name};
      if (photoUrl != null) {
        dataToUpdate['photoUrl'] = photoUrl;
      }

      await _firestoreService.updateUser(uid, dataToUpdate);
      
      // Refresh user data in AuthProvider
      await authProvider.refreshUser();
      
      // Refresh group members to reflect new photo in feed
      await groupProvider.refreshMembers();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao atualizar o perfil: $e';
      notifyListeners();
      return false;
    }
  }
}
