

import 'package:flutter/material.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';

import '../helpers/Preferences.dart';
import '../models/Person.dart';
import 'SnackBarText.dart';


// Edit users string and valuess
// NOT VGSHIP AND LOGEESHIP
class EditUserValueWidget extends StatefulWidget {
  const EditUserValueWidget({Key? key}) : super(key: key);

  @override
  State<EditUserValueWidget> createState() => _EditUserValueWidgetState();
}

class _EditUserValueWidgetState extends State<EditUserValueWidget> {
  String valueToChange = 'Bier HV';
  String? personToChange;
  String? inputValue = null;

  late Map<String, Person> fullnameToPerson = Map<String, Person>();
  List<String> fullnames = <String>[];

  @override
  Widget build(BuildContext context) {
    return // Getallen en Strings aanpassen!!
      FutureBuilder(
          initialData: null,
          future: Preferences.getBewoners(),
          builder: (context, AsyncSnapshot snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
                return const CircularProgressIndicator(
                  color: Colors.black,
                );
              case ConnectionState.waiting:
                return const CircularProgressIndicator(
                  color: Colors.black,
                );
              case ConnectionState.active:
                return const CircularProgressIndicator(
                  color: Colors.black,
                );
              case ConnectionState.done:
                if(snapshot.hasError || snapshot.data == null) {
                  return const NoPersonFoundWidget();
                }

                fullnameToPerson.clear();
                fullnames.clear();
                for(Person person in snapshot.data) {
                  fullnameToPerson[person.passportName()] = person;
                  fullnames.add(person.passportName());
                }

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Waardes aanpassen'),
                      // Welke waarde wil je aanpassen
                      Expanded(
                        child: Row(
                          children: [
                            Text('Wat wil je aanpassen?'),
                            DropdownButton(
                              value: valueToChange,
                              items: <String>['vGNaam', 'Bier HV', 'Bier Totaal',
                                'Mis gegooid HV', 'Mis gegooid totaal', 'Raak gegooid HV', 'Raak gegooid totaal',
                                'Schoonmaakbier HV', 'Schoonmaakbier Totaal']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),

                              onChanged: (String? newValue) {
                                setState(() {
                                  valueToChange = newValue!;
                                });
                              },
                            )
                          ],
                        ),
                      ),

                      // Van wie?
                      Expanded(
                        child: Row(
                          children: [
                            Text('Van wie?'),
                            DropdownButton(
                              value: personToChange,
                              items: fullnames
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),

                              onChanged: (String? newValue) {
                                setState(() {
                                  personToChange = newValue!;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      // Wat wordt de nieuwe waarde
                      Expanded(
                        child: Row(
                          children: [
                            Text('Wat moet de nieuwe waarde worden?'),
                            Expanded(
                              child: TextField( // Nieuwe waarde
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Nieuwe Waarde',
                                ),
                                onChanged: (val) {
                                  if(val == null || val == "" || val.isEmpty) {
                                    inputValue = null;
                                  } else {
                                    inputValue = val;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          if(personToChange == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: SnackBarText(text: "Kies een persoon.",),
                            ));
                            return;
                          }

                          if(valueToChange == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: SnackBarText(text: "Vul in wat je wilt veranderen.",),
                            ));
                            return;
                          }

                          if(inputValue == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: SnackBarText(text: "Vul een waarde in.",),
                            ));
                            return;
                          }

                          Person? person = fullnameToPerson[personToChange];
                          if(person == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: SnackBarText(text: "Error. Persoon niet gevonden. Waarschijnlijk is dit een fout in de app, neem contact op met Rowin."),
                            ));
                            return;
                          }

                          if(['Bier HV', 'Bier Totaal',
                            'Mis gegooid HV', 'Mis gegooid totaal', 'Raak gegooid HV', 'Raak gegooid totaal',
                            'Schoonmaakbier HV', 'Schoonmaakbier Totaal'].contains(valueToChange)) {
                            // parse input number
                            try {
                              int value = int.parse(inputValue!);
                              person = changeValue(person, valueToChange, value);
                            } on FormatException {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: SnackBarText(text: "Je moet een getal invullen.",),
                              ));
                              return;
                            }

                          } else {
                            // change vGnaam
                            person.vGName = inputValue!;
                          }

                          Preferences.updatePerson(person);

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: SnackBarText(text: "Waarde aangepast!",),
                          ));
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/cleaning-edit-choice/edit-users');
                          Navigator.pushNamed(context, '/cleaning-edit-choice/edit-users/edit-user-values');
                        },
                        child: Text('Pas waarde aan'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            textStyle:
                            const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                break;
            }

          }
      );

  }

  Person changeValue(Person person, String valueToChange, int val) {
    Person res = person; // Not sure about copy by ref or value, so to be safe
    switch(valueToChange) {
      case 'Bier HV':
        res.BeersHV = val;
        return res;
      case 'Bier Totaal':
        res.BeersTotal = val;
        return res;
      case 'Mis gegooid HV':
        res.MissedHV = val;
        return res;
      case 'Mis gegooid totaal':
        res.MissedTotal = val;
        return res;
      case 'Raak gegooid HV':
        res.HitHV = val;
        return res;
      case 'Raak gegooid totaal':
        res.HitTotal = val;
        return res;
      case 'Schoonmaakbier HV':
        res.CleaningBeerHV = val;
        return res;
      case 'Schoonmaakbier Totaal':
        res.CleaningBeerTotal = val;
        return res;
      default:
        return person;


    }
  }
}
