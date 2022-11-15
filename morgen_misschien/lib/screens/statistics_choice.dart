

import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/StaticIcons.dart';
import '../widgets/IconTextButton.dart';

class StatisticsChoice extends StatelessWidget {
  const StatisticsChoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morgen Misschien'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 5.0,
          runSpacing: 5.0,
          children: <Widget> [
            IconTextButton(
                OnPressed: () {
                  Navigator.pushNamed(context, '/statistics-choice/fun-statistics');
                },
                icon: const Icon(StaticIcons.funStatistics),
                text: "Leuke statistieken"
            ),
            IconTextButton(
                OnPressed: () {
                  Navigator.pushNamed(context, '/statistics-choice/beer-statistics');
                },
                icon: const Icon(StaticIcons.beerStatistics),
                text: 'Bier statistieken'
            ),
          ],
        ),
      ),
    );
  }
}
