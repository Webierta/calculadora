import 'package:flutter/material.dart';

class SnackBarHelper {
  static void show({
    required BuildContext context,
    required String msg,
    bool? error,
  }) {
    if (!context.mounted) return;
    Color? colorError = error == true ? Color(0xffE78388) : null;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackbar = SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorError,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
