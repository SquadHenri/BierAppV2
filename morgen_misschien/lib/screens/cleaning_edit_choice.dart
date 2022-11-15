

import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/StaticIcons.dart';
import 'package:morgen_misschien/widgets/IconTextButton.dart';

class CleaningEditChoice extends StatelessWidget {
  const CleaningEditChoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Morgen Misschien'),
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
                Navigator.pushNamed(context, '/cleaning-edit-choice/add-cleaning-beer');
              },
              icon: const Icon(StaticIcons.cleaningBeer),
              text: "Schoonmaak Bier",
              iconSize: 180,
            ),
            IconTextButton(
              OnPressed: () {
                Navigator.pushNamed(context, '/cleaning-edit-choice/edit-users');
              },
              icon: const Icon(StaticIcons.editPersons),
              text: 'Personen Bewerken',
              iconSize: 180,
            ),
            IconTextButton(
              OnPressed: () {
                Navigator.pushNamed(context, '/cleaning-edit-choice/edit-order');
              },
              icon: const Icon(StaticIcons.changeOrder),
              text: 'Volgorde aanpassen',
              iconSize: 180,
            ),
            IconTextButton(
              OnPressed: () {
                Navigator.pushNamed(context, '/cleaning-edit-choice/options');
              },
              icon: const Icon(StaticIcons.settings),
              text: 'Instellingen',
              iconSize: 180,
            ),
          ],
        ),
      ),
    );
  }
}

// Icon(Icons.remove_circle_outline)
