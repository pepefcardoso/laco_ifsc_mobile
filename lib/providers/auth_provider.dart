import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authService.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        _userModel = await _firestoreService.getUser(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> refreshUser() async {
    if (_user != null) {
      _userModel = await _firestoreService.getUser(_user!.uid);
      notifyListeners();
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'user-not-found':
        return 'Nenhuma conta encontrada com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'weak-password':
        return 'Sua senha é muito fraca. Use ao menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um momento e tente novamente.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro inesperado. Tente novamente.';
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final credential = await _authService.signInWithEmail(email, password);
      if (credential != null && credential.user != null) {
        _userModel = await _firestoreService.getUser(credential.user!.uid);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _mapFirebaseError(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Ocorreu um erro ao tentar entrar.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential != null && credential.user != null) {
        final user = credential.user!;
        final existingUser = await _firestoreService.getUser(user.uid);
        
        if (existingUser == null) {
          final newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'Usuário',
            photoUrl: user.photoURL ?? '',
            email: user.email ?? '',
            groupId: '',
          );
          await _firestoreService.createUser(newUser);
          _userModel = newUser;
        } else {
          _userModel = existingUser;
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _mapFirebaseError(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Ocorreu um erro ao entrar com Google.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final credential = await _authService.signUpWithEmail(name, email, password);
      
      if (credential != null && credential.user != null) {
        final newUser = UserModel(
          id: credential.user!.uid,
          name: name,
          photoUrl: '',
          email: email,
          groupId: '',
        );
        
        await _firestoreService.createUser(newUser);
        _userModel = newUser;
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _mapFirebaseError(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Ocorreu um erro ao cadastrar.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    await _authService.signOut();
    _userModel = null;
    
    _isLoading = false;
    notifyListeners();
  }
}
