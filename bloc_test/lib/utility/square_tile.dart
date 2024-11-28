import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final String text;
  final String text2;
  final Function()? onTap;
  const SquareTile(
      {super.key,
      required this.imagePath,
      required this.text,
      this.onTap,
      required this.text2});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 16,
            width: 16,
          ),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text2,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ) // Testo
        ],
      ),
    );
  }
}
