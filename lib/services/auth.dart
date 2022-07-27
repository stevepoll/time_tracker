import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymously();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

///////////////////////////////////////////////////////////////////
  /// Signs in anonymously
///////////////////////////////////////////////////////////////////
  @override
  Future<User?> signInAnonymously() async {
    final userCreds = await _firebaseAuth.signInAnonymously();
    return userCreds.user;
  }

///////////////////////////////////////////////////////////////////
  /// Signs in with email, password
///////////////////////////////////////////////////////////////////
  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCreds = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCreds.user;
  }

///////////////////////////////////////////////////////////////////
  /// Registers new user with email, password
///////////////////////////////////////////////////////////////////
  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCreds = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCreds.user;
  }

///////////////////////////////////////////////////////////////////
  /// Signs in with Google auth
///////////////////////////////////////////////////////////////////
  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Signin aborted by user',
      );
    }

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) {
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: 'Missing Google ID token',
      );
    }

    final userCreds = await _firebaseAuth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      ),
    );
    return userCreds.user;
  }

///////////////////////////////////////////////////////////////////
  /// Signs out
///////////////////////////////////////////////////////////////////
  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
