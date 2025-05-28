import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String LogoPath = "assets/icon/icon.png";

final Color themecolor = Color.fromARGB(255, 90, 30, 0);

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

String formatDate(date) {
return DateFormat('yyyy-MM-dd').format(date);
}
void showTopFlushbar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  IconData icon = Icons.info,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    message: message,
    duration: duration,
    backgroundColor: backgroundColor,
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    icon: Icon(icon, color: Colors.white),
  ).show(context);
}






  InputDecoration getInputDecoration(
    String label,
    IconData icon, {
    bool isPassword = false,
    VoidCallback? toggleVisibility,
    bool isVisible = false,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: themecolor),
      prefixIcon: Icon(icon, color: themecolor),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: themecolor,
              ),
              onPressed: toggleVisibility,
            )
          : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themecolor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themecolor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }



 