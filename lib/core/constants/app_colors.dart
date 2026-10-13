// Centralized color palette. Every widget should reference these constants
// instead of hard-coding colors, so a brand restyle touches one file.

import 'package:flutter/material.dart';

/// Centralized color palette for the app.
/// All color references should come from here.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3F51B5);
  static const Color primaryLight = Color(0xFF757DE8);
  static const Color primaryDark = Color(0xFF002984);

  static const Color secondary = Color(0xFF009688);
  static const Color secondaryLight = Color(0xFF52C7B8);
  static const Color secondaryDark = Color(0xFF00675B);

  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFF6659);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFB0BEC5);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3F51B5), Color(0xFF283593), Color(0xFF002984)],
  );
}
