// Centralized user-facing strings. Keeping copy here (instead of inline in
// widgets) makes future localization a matter of swapping this one file.

/// Centralized text constants used throughout the app.
/// Keeping them here makes future internationalization easier.
class AppStrings {
  AppStrings._();

  // App general
  static const String appName = 'App Template';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String accept = 'Accept';
  static const String close = 'Close';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String unknownError = 'An unexpected error occurred.';

  // Auth - Login
  static const String loginTitle = 'Welcome';
  static const String loginSubtitle = 'Sign in to continue';
  static const String emailLabel = 'Email';
  static const String emailHint = 'you@example.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Your password';
  static const String loginButton = 'Sign in';
  static const String loginSuccess = 'Signed in successfully';
  static const String invalidCredentials = 'Invalid credentials';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'At least 6 characters';

  // Auth - Logout
  static const String logout = 'Log out';
  static const String logoutConfirm = 'Do you want to log out?';

  // Errors
  static const String networkError = 'No internet connection. Check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String cacheError = 'Error reading local data.';
  static const String timeoutError = 'The request took too long. Please try again.';
}
