import "package:test_flutter_mynotes/services/auth/auth_user.dart";

abstract class AuthProvider {
  Future<AuthUser> createUser({
    required email,
    required password,
  });
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> logIn({
    required email,
    required password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
