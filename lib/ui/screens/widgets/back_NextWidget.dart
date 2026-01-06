import 'package:flutter/material.dart';
Widget buildBackPill({VoidCallback? onPressed, bool enabled = true}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 72,
          height: 44,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFF2B3348) : Colors.grey[400],
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }

Widget buildNextPill({VoidCallback? onPressed, bool enabled = true}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 72,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF2B3348) : Colors.grey[400],
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Icon(Icons.arrow_forward, color: Colors.white, size: 22),
        ),
      ),
    ),
  );
}
