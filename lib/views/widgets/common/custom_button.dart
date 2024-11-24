import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // 背景色
        foregroundColor: Colors.black, // テキスト色
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
      ),
      child: Text(text),
    );
  }
}
