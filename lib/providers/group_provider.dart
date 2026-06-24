import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class GroupProvider with ChangeNotifier {
  GroupModel? _currentGroup;
  List<UserModel> _members = [];
  bool _isLoading = false;
  String? _errorMessage;

  GroupModel? get currentGroup => _currentGroup;
  List<UserModel> get members => _members;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> createGroup(String name, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Stub group creation
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

  Future<bool> joinGroup(String code, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Stub joining group
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

  void clearGroup() {
    _currentGroup = null;
    _members = [];
    notifyListeners();
  }
}
