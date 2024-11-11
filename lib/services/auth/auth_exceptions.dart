// General exceptions
class InvalidEmailAuthException implements Exception {}

class ChannelErrorAuthException implements Exception {}

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

// Login exceptions
class InvalidCredentialAuthException implements Exception {}

// Register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}
