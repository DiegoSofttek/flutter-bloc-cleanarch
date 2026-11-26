import 'package:flutter/material.dart';

/// Creates the standard outlined border used by app text inputs.
OutlineInputBorder appInputBorder(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: width),
  );
}
