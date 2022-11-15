import 'package:flutter/material.dart';
import 'package:morgen_misschien/widgets/EditUserStatusWidget.dart';

import '../widgets/EditUserValueWidget.dart';
import '../widgets/EditUserStatusWidget.dart';

// A sub-page of edit_users.dart
// Used to change all values of a specific users


class EditUserValues extends StatefulWidget {
  const EditUserValues({Key? key}) : super(key: key);

  @override
  State<EditUserValues> createState() => _EditUserValuesState();
}

class _EditUserValuesState extends State<EditUserValues> {
  String valueToChange = "Bier HV";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waardes aanpassen'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Row( // Master Column
        children: [
          EditUserValueWidget(),
          VerticalDivider(),
          EditUserStatusWidget(),
        ],
      ),
    );
  }
}
