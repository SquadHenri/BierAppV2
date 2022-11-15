

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';
import 'package:morgen_misschien/widgets/SnackBarText.dart';

import '../helpers/ImageHelper.dart';
import '../models/Person.dart';

// Shows the names of all people in the system
class PersonNameWidget extends StatefulWidget {
  const PersonNameWidget();

  @override
  State<PersonNameWidget> createState() => _PersonNameWidgetState();
}

class _PersonNameWidgetState extends State<PersonNameWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: Preferences.getBewoners(),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const CircularProgressIndicator(
                color: Colors.black,
              );
              break;
            case ConnectionState.done:
              if(snapshot.hasError) {
                return NoPersonFoundWidget();
              }
              if(snapshot.data != null) {
                List<Widget> personNamesTexts = <Widget>[];
                personNamesTexts.add(const Text(
                    'Alle personen in de app',
                    style: TextStyle(
                      fontSize: 20,
                    )
                ));

                for(Person person in snapshot.data) {
                  personNamesTexts.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Preferences.changeBewonership(person, !person.isHuidigeBewoner);
                                Navigator.popAndPushNamed(context, '/cleaning-edit-choice/edit-users');
                              },
                              child: person.isHuidigeBewoner ? Text('Woont er niet meer') : Text('Woont er nu'),// CHANGE BEWONERSHIP
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  textStyle:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevatedButton(
                              onPressed: () {
                                debugPrint('Changing image');
                                ImageHelper.pickImageAndSave(person.imagePath()).then((bool bSuccess) {
                                  if(bSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: SnackBarText(text: "Foto toegevoegd!"),
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: SnackBarText(text: "Error."),
                                    ));
                                  }
                                });
                              },
                              child: Text('Foto Uitkiezen'),// CHANGE BEWONERSHIP
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  textStyle:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
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

/*
                                // String? imgString = await ImageHelper.pickImageFromGallery();
                                // debugPrint(imgString);
                                // if(imgString != null) {
                                //   person.PhotoBase64 = imgString;
                                //   Preferences.updatePerson(person);
                                //   debugPrint('Image added!');
                                // }

                                ImageHelper.pickImageFromGallery().then((imgString) {
                                  if(imgString != null) {
                                    person.PhotoBase64 = imgString;
                                    Preferences.updatePerson(person);

                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: SnackBarText(text: "Foto toegevoegd!",),
                                    ));
                                  } else {
                                    debugPrint('Niet foto toegevoegd!');
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: SnackBarText(text: "Foto niet toegevoegd.",),
                                    ));
                                  }
                                });
* */