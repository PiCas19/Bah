import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String text;
  final Color color;
  final Color? iconColor;
  final VoidCallback onPressed;

  const MyButton({
    super.key,
    required this.icon,
    required this.imagePath,
    required this.text,
    required this.color,
    required this.iconColor,
    required this.onPressed,
  });

  // Helper method to build either an Icon or an Image
  Widget _buildIconOrImage() {
    if (icon != null) {
      return Icon(
        icon,
        color: iconColor,
        size: 30,
      );
    } else if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 30,
        height: 30,
      );
    } else {
      return const SizedBox(); // Return empty space if neither is provided
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        icon: _buildIconOrImage(),
        label: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.cyan,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}