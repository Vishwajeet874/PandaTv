import 'package:flutter/material.dart';

class TextWithCircularBorder extends StatelessWidget {
  const TextWithCircularBorder({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}
