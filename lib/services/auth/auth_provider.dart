import "package:test_flutter_mynotes/services/auth/auth_user.dart";

abstract class AuthProvider {
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
