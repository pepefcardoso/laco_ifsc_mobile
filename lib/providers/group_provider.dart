import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/services/firestore_service.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class GroupProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  GroupModel? _currentGroup;
  List<UserModel> _members = [];
  bool _isLoading = false;
  String? _errorMessage;

  GroupModel? get currentGroup => _currentGroup;
  List<UserModel> get members => _members;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _loadMembers(List<String> memberUids) async {
    _members = await _firestoreService.getGroupMembers(memberUids);
    notifyListeners();
  }

  Future<bool> createGroup(String name, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      String code = _generateCode();
      bool isUnique = false;
      while (!isUnique) {
        final existing = await _firestoreService.getGroupByCode(code);
        if (existing == null) {
          isUnique = true;
        } else {
          code = _generateCode();
        }
      }

      final groupId = FirebaseFirestore.instance.collection('groups').doc().id;
      final newGroup = GroupModel(
        id: groupId,
        name: name,
        code: code,
        createdBy: userId,
        members: [userId],
        createdAt: Timestamp.now(),
      );

      await _firestoreService.createGroup(newGroup);
      
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'groupId': groupId
      });

      _currentGroup = newGroup;
      await _loadMembers(newGroup.members);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao criar grupo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinGroup(String code, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final normalizedCode = code.trim().toUpperCase();
    
    try {
      final currentUserDoc = await _firestoreService.getUser(userId);
      if (currentUserDoc != null && currentUserDoc.groupId.isNotEmpty) {
        _errorMessage = 'Você já pertence a um grupo. Saia do grupo atual para entrar em outro.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final group = await _firestoreService.getGroupByCode(normalizedCode);
      if (group == null) {
        _isLoading = false;
        _errorMessage = 'Código inválido. Grupo não encontrado.';
        notifyListeners();
        return false;
      }

      if (group.members.contains(userId)) {
        _currentGroup = group;
        await _loadMembers(group.members);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      await _firestoreService.joinGroup(group.id, userId);
      
      final updatedMembers = List<String>.from(group.members)..add(userId);
      _currentGroup = GroupModel(
        id: group.id,
        name: group.name,
        code: group.code,
        createdBy: group.createdBy,
        members: updatedMembers,
        createdAt: group.createdAt,
      );
      
      await _loadMembers(updatedMembers);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao entrar no grupo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadGroup(String groupId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final group = await _firestoreService.getGroup(groupId);
      if (group != null) {
        _currentGroup = group;
        await _loadMembers(group.members);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Grupo não encontrado.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao carregar grupo: $e';
      notifyListeners();
      return false;
    }
  }

  void clearGroup() {
    _currentGroup = null;
    _members = [];
    notifyListeners();
  }
}
