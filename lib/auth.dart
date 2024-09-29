import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      accessToken: credential.authorizationCode,
      idToken: credential.identityToken,
    );

    return await _firebaseAuth.signInWithCredential(oauthCredential);
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Password reset function
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isEmailRegistered({
    required String email,
  }) async {
    try {
      // Try to create a user with a temporary password
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: '!temp!', // Use a temporary password
      );

      // If user creation succeeds, the email is not registered
      await userCredential.user!.delete(); // Delete the temporary user
      return false; // Email is not registered
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // The email is already registered
        return true;
      }
      // Handle other FirebaseAuthExceptions if needed
      print('ErrorA: ${e.message}');
    } catch (e) {
      // Handle non-Firebase errors
      print('ErrorB: $e');
    }

    print("AAAAAAAAAAAAAAA");
    return false; // Default to not registered in case of other failures
  }


}