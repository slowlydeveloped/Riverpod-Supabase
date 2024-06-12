import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.width = 100,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: Size(
            width,
            42,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              11,
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ));
  }
}
