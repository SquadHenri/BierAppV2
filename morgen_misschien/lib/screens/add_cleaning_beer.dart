
import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/models/Person.dart';
import 'package:morgen_misschien/widgets/AddCleaningBeerWidget.dart';
import 'package:morgen_misschien/widgets/SnackBarText.dart';

import '../models/PersonValue.dart';
import '../widgets/NoPersonFoundWidget.dart';
import '../widgets/OrderBeerWidget.dart';

// TODO: ADD IMAGES
class AddCleaningBeer extends StatefulWidget {
  const AddCleaningBeer({Key? key}) : super(key: key);

  @override
  State<AddCleaningBeer> createState() => _AddCleaningBeerState();
}

class _AddCleaningBeerState extends State<AddCleaningBeer> {
  List<PersonValue> personValues = <PersonValue>[];

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
                  title: const Text('Schoonmaakbier Strepen'),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                ),
                body: const NoPersonFoundWidget(),
              );
            }

            List<Widget> addCleaningBeerWidgets = <Widget>[];
            for(Person person in snapshot.data) {
              addCleaningBeerWidgets.add(
                AddCleaningBeerWidget(
                    firstName: person.firstName,
                    lastName: person.lastName,
                    correctName: person.correctName(),
                    onValueChanged: onValueChanged)
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Schoonmaakbier toevoegen'),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: Center(
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      spacing: 3.0,
                      runSpacing: 3.0,
                      children: addCleaningBeerWidgets,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          // Process Schoonmaakbier
                          Preferences.addCleaningBeer(personValues);

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: SnackBarText(text: 'Schoonmaakbier toegevoegd!',),
                              ));

                          Navigator.popAndPushNamed(context, '/cleaning-edit-choice/add-cleaning-beer');
                        },
                        child: const Text(
                            'Schoonmaakbier Toevoegen',
                            style: TextStyle(
                              fontSize: 40,
                            ))
                      ),
                    ),
                  ]
                )
              ),
            );
        }
      }
    );
  }


  // Callback for OrderBeerWidgets to lets us know when a value has changed
  void onValueChanged(PersonValue updatedPv) {
    // If it is in the personValues update the value
    for(PersonValue pv in personValues) {
      if(pv.firstName == updatedPv.firstName && pv.lastName == updatedPv.lastName) {
        pv.value = updatedPv.value;
        return;
      }
    }

    // Otherwise we add it
    personValues.add(updatedPv);
  }
}

