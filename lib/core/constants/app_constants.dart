// API constants

class AppConstants {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String characterEndpoint = '/character';

  static const int itemsPerPage = 20;
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
