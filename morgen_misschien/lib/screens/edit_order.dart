import 'dart:core';

import 'package:flutter/material.dart';
import 'package:morgen_misschien/models/Person.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';

import '../helpers/Preferences.dart';

class EditOrder extends StatefulWidget {
  const EditOrder({Key? key}) : super(key: key);

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: Preferences.getHuidigeBewoners(),
      builder: (context, AsyncSnapshot snapshot) {
        switch(snapshot.connectionState) {

          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Text("Personen aan het zoeken in het systeem");
          case ConnectionState.done:
            if(snapshot.hasError || snapshot.data == null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Bier Strepen'),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                ),
                body: const NoPersonFoundWidget(),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Volgorde aanpassen'),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: ReorderableListView(
                onReorder: (int oldIndex, int newIndex) {
                  // Reorder
                  Preferences.changeOrder(snapshot.data, oldIndex, newIndex);

                  Navigator.popAndPushNamed(context, '/cleaning-edit-choice/edit-order');
                },
                children: getListTiles(snapshot.data),
              ),
            );
        }
      },
    );
  }

  List<Widget> getListTiles(List<Person> persons) {
    List<Widget> res = <Widget>[];
    for(Person person in persons) {
      res.add(
          Card(
            key: ValueKey(person.passportName()),
            child: ListTile(
                key: ValueKey('listTile: ${person.passportName()}'),
                title: Text(person.passportName())
            ),
          )
      );
    }
    return res;
  }
}
