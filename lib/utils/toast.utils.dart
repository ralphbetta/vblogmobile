import 'package:flutter/material.dart';

void showToast(BuildContext context, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      elevation: 0.8,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 3),
    ),
  );
}
