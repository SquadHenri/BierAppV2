
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {

  IconTextButton({required this.OnPressed, required this.icon, required this.text, this.fontSize = 30, this.iconSize = 150});

  final String text;
  final Widget icon;
  final double iconSize;
  final double fontSize;
  final VoidCallback OnPressed;


  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        IconButton(
          icon: icon,
          iconSize: this.iconSize,
          onPressed: this.OnPressed,
        ),
        TextButton(
          onPressed: this.OnPressed,
          style: TextButton.styleFrom(
            primary: Colors.black,
          ),
            child: Text(
          '${this.text}',
          style: TextStyle(fontSize: 30)
          )
        )
      ]
    );
  }
}
