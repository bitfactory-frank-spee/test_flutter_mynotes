import 'package:firebase_core/firebase_core.dart';
import 'package:test_flutter_mynotes/firebase_options.dart';
import 'package:test_flutter_mynotes/services/auth/auth_exceptions.dart';
import 'package:test_flutter_mynotes/services/auth/auth_provider.dart';
import 'package:test_flutter_mynotes/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider extends AuthProvider {
  @override
  Future<AuthUser> createUser({
    required email,
    required password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user == null) {
        throw UserNotLoggedInAuthException();
      }
      return user;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'channel-error':
          throw ChannelErrorAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (error) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? null : AuthUser.fromFirebase(user);
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> logIn({
    required email,
    required password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      if (user == null) {
        throw UserNotLoggedInAuthException();
      }
      return user;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-credential':
          throw InvalidCredentialAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'channel-error':
          throw ChannelErrorAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (error) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw UserNotLoggedInAuthException();
    }
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw UserNotLoggedInAuthException();
    }
    await user.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (exception) {
      throw GenericAuthException();
    }
  }
}
