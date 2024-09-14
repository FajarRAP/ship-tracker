import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> flushbar(
  BuildContext context,
  String message,
) =>
    Flushbar(
      message: message,
      animationDuration: const Duration(milliseconds: 1200),
      duration: const Duration(seconds: 2),
    ).show(context);

ScaffoldFeatureController snackbar(
  BuildContext context,
  String message,
) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
      ),
    );
