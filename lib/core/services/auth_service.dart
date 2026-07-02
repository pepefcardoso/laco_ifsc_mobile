import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleInitialized = false;

  Future<void> _initGoogleSignIn() async {
    if (!_isGoogleInitialized) {
      await _googleSignIn.initialize(
        serverClientId: '510383029326-l1v2p2a7ando5mu0b10ocuhnqp0kube2.apps.googleusercontent.com',
      );
      _isGoogleInitialized = true;
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Tratada na camada de provider/UI
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await credential.user?.updateDisplayName(name);
      return credential;
    } catch (e) {
      // Tratada na camada de provider/UI
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _initGoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final authorization = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignora erro caso o usuário não esteja logado pelo google
    }
    await _auth.signOut();
  }
}
