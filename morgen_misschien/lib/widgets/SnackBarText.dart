import 'package:flutter/material.dart';

class SnackBarText extends StatelessWidget {
  const SnackBarText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        )
    );
  }
}
