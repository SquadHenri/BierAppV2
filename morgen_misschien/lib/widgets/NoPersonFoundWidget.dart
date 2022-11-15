import 'package:flutter/material.dart';

class NoPersonFoundWidget extends StatelessWidget {
  const NoPersonFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Geen personen gevonden.\nMaak een persoon aan.',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
