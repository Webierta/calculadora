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
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height * 0.91,
        left: 10,
        right: 10,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
