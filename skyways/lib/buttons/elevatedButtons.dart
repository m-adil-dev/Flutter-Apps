import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart';

class CustomButtons {
  static ElevatedButton customElevatedButton({
    required String text,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: themecolor,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.5,
                ),
              )
              : Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  static ElevatedButton customElevatedButtonSecondary({
    required String text,
    required VoidCallback onPressed,
    required bool isLoading,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: text == "Details"
              ? BorderSide(color: textColor, width: 1.5)
              : BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      ),
      child: Text(text, style: TextStyle(color: textColor,  fontSize: 12)),
    );
  }

  Widget buildStatusCard(String title, IconData icon, Color color, VoidCallback ontap) {
    return Expanded(
      child: InkWell(
        onTap: ontap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 6, left: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.85), color.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 28, color: color),
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
