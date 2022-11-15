

import 'package:flutter/material.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';
import 'package:morgen_misschien/widgets/SnackBarText.dart';

import '../helpers/Preferences.dart';
import '../models/Person.dart';


// Edit users string and valuess
// NOT VGSHIP AND LOGEESHIP
class EditUserStatusWidget extends StatefulWidget {
  const EditUserStatusWidget({Key? key}) : super(key: key);

  @override
  State<EditUserStatusWidget> createState() => _EditUserStatusWidgetState();
}

class _EditUserStatusWidgetState extends State<EditUserStatusWidget> {
  String valueToChange = 'vG status';
  String? personToChange;
  bool inputValue = true;

  late Map<String, Person> fullnameToPerson = Map<String, Person>();
  List<String> fullnames = <String>[];

  @override
  Widget build(BuildContext context) {
    return // Aanpassen van vg en logee
      FutureBuilder(
          initialData: null,
          future: Preferences.getBewoners(),
          builder: (context, AsyncSnapshot snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
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
                      Text('vG of Logee status aanpassen'),
                      // Welke waarde wil je aanpassen
                      Expanded(
                        child: Row(
                          children: [
                            Text('Wat wil je aanpassen?'),
                            DropdownButton(
                              value: valueToChange,
                              items: <String>['vG status', 'Logee status']
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
                        child: CheckboxListTile(
                            title: valueToChange == 'vG status' ? Text('Is het een vG?') : Text('Is het een Logee?'),
                            value: inputValue,
                            onChanged: (val) {
                              setState(() {
                                inputValue = val!;
                              });
                            }
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          if(personToChange == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: SnackBarText(text: "Kies een persoon."),
                            ));
                            return;
                          }

                          if(valueToChange == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: SnackBarText(text: "Kies wat je wilt veranderen."),
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

                          Person? updated_person = changePerson(person);
                          if(updated_person == null) {
                            return;
                          }

                          Preferences.updatePerson(updated_person);

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: SnackBarText(text: "Status aangepast!",),
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

  Person? changePerson(Person input_person) {
    Person person = input_person;

    if(valueToChange == 'vG status') {

      if(person.isVg == inputValue) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SnackBarText(text: "Er is niks aangepast.",),
        ));
        return null;
      }

      person.isVg = inputValue;
    } else if (valueToChange == 'Logee status'){
      // Logee Status
      if(person.isLogee == inputValue) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SnackBarText(text: "Er is niks aangepast.",),
        ));
        return null;
      }

      person.isLogee = inputValue;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: SnackBarText(text: "Error. Dit mag niet gebeuren.",),
      ));
      return null;
    }

    if(person.isLogee && person.isVg) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: SnackBarText(text: "Een persoon kan niet en logee en vG zijn. Verander een van beide eerst.",),
      ));
      return null;
    }

    return person;
  }
}

