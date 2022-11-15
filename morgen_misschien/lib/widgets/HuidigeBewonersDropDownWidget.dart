
import 'package:flutter/material.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';

import '../helpers/Preferences.dart';
import '../models/Person.dart';

// Dropdown that has the current bewoners filled in
class HuidigeBewonersDropDownWidget extends StatefulWidget {
  HuidigeBewonersDropDownWidget();

  @override
  State<HuidigeBewonersDropDownWidget> createState() => _HuidigeBewonersDropDownWidgetState();
}

class _HuidigeBewonersDropDownWidgetState extends State<HuidigeBewonersDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: Preferences.getHuidigeBewoners(),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return const CircularProgressIndicator(
                color: Colors.black,
              );
              break;
            case ConnectionState.waiting:
              return const CircularProgressIndicator(
                color: Colors.black,
              );
              break;
            case ConnectionState.active:
              return const CircularProgressIndicator(
                color: Colors.black,
              );
              break;
            case ConnectionState.done:
              if(snapshot.hasError) {
                return const NoPersonFoundWidget();
              }
              if(snapshot.data != null) {
                List<Widget> personNamesTexts = <Widget>[];
                personNamesTexts.add(const Text(
                    'Iedereen die nu op MM woont op volgorde',
                    style: TextStyle(
                      fontSize: 20,
                    )
                ));

                for(Person person in snapshot.data) {
                  personNamesTexts.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            person.correctName(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Persoon is geen huidige bewoner meer
                                Preferences.changeBewonership(person, false);
                                Navigator.popAndPushNamed(context, '/cleaning-edit-choice/edit-users');
                              },
                              child: person.isHuidigeBewoner ? Text('Woont er niet meer') : Text('Woont er nu'),// CHANGE BEWONERSHIP
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  textStyle:
                                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      )
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: personNamesTexts,
                );
              } else {
                return const NoPersonFoundWidget();
              }
          }
        }
    );
  }
}


