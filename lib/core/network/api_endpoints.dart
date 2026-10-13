// Single source of truth for API paths, so datasources never hardcode URLs.

/// REST API endpoint constants.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com';

  // Auth
  static const String login = '/api/auth/login';
}
