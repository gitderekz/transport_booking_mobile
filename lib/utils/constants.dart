import 'package:flutter/cupertino.dart';

class AppConstants {
  static const String appName = 'Multi-Transport Booking';

  // API Endpoints
  static const String baseUrl = 'http://your-api-url.com/api';

  // Colors
  static const Color primaryColor = Color(0xFF461B93);
  static const Color secondaryColor = Color(0xFF6A3CBC);
  static const Color accentColor = Color(0xFFD4ADFC);
  static const Color successColor = Color(0xFF00b894);
  static const Color errorColor = Color(0xFFd63031);

  // Assets
  static const String logoPath = 'assets/images/logo.png';

  // Localization
  static const List<String> supportedLanguages = ['en', 'sw', 'es', 'fr'];
  static const String defaultLanguage = 'en';
}