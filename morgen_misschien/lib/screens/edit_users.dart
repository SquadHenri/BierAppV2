import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/widgets/AddUserWidget.dart';
import 'package:morgen_misschien/widgets/HuidigeBewonersDropDownWidget.dart';
import 'package:morgen_misschien/widgets/PersonNameWidget.dart';
import 'package:morgen_misschien/widgets/PersonWidget.dart';

import '../models/Person.dart';

// This page will be used to:
// - Add users
// - List all users
// - list current bewoners
// - Change bewoners - order


class EditUsers extends StatefulWidget {
  const EditUsers({Key? key}) : super(key: key);

  @override
  State<EditUsers> createState() => _EditUsersState();
}

class _EditUsersState extends State<EditUsers> {
  List<Person>? persons = <Person>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Personen Bewerken'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          Expanded(
            child: AddUserWidget(
              OnPersonAdded: () {
                // Refresh all
                Navigator.popAndPushNamed(context, '/cleaning-edit-choice/edit-users');
              },
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                PersonNameWidget(), // Shows the name of all Bewoners
                // Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // children: getPersonNameWidgets(),
                // ),
                Divider(),

                HuidigeBewonersDropDownWidget(), // Shows the huidige bewoners and change order
            ]),
          ),
      //     Expanded(
      //       flex: 2,
      //       child: VerticalDivider()
      //     )
        ],
      ),
      floatingActionButton: Container(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, '/cleaning-edit-choice/edit-users/edit-user-values');
          },
          child: const Text('Waardes'),
        ),
      ),
    );
  }
}
