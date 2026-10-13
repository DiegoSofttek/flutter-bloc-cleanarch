// Reusable form field with validation and an obscure-text toggle, used by
// any feature that needs a styled text input instead of a bare TextFormField.

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_input_borders.dart';
import '../constants/app_text_styles.dart';

/// Reusable text field with label, validation, and optional obscure-text toggle.
class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.labelText),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          validator: widget.validator,
          style: AppTextStyles.bodyText,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyText.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: AppInputBorders.base(),
            enabledBorder: AppInputBorders.base(),
            focusedBorder: AppInputBorders.focused(),
            errorBorder: AppInputBorders.error(),
            focusedErrorBorder: AppInputBorders.focusedError(),
          ),
        ),
      ],
    );
  }
}
