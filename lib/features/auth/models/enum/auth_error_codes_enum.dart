enum AuthErrorCodes {
  invalidEmail(message: "Email is invalid", code: "invalid-email"),
  userDisabled(message: "Email is disabled", code: "user-disabled"),
  userNotFound(message: "User not found", code: "user-not-found"),
  wrongPassword(message: "Wrong password", code: "wrong-password"),
  networkError(
      message: "Logging in without Wifi", code: "network-request-failed");

  final String message;
  final String code;

  const AuthErrorCodes({required this.message, required this.code});
}
