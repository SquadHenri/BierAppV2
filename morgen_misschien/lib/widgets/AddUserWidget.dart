
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morgen_misschien/helpers/ImageHelper.dart';
import 'package:morgen_misschien/helpers/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/Preferences.dart';
import '../models/Person.dart';
import 'SnackBarText.dart';


class AddUserWidget extends StatefulWidget {
  const AddUserWidget({required this.OnPersonAdded});

  final VoidCallback OnPersonAdded;

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  String? firstName;
  String? lastName;
  String vGName = "vG";
  String? imgString;

  bool isVg = false;
  bool isLogee = false;
  bool isHuidigeBewoner = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Text("Persoon toevoegen",
              style: TextStyle(
                fontSize: 30,
              )
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextField( // firstName
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Voornaam',
                  ),
                  onChanged: (val) {
                    if(val == null || val == "" || val.isEmpty) {
                      firstName = null;
                    } else {
                      firstName = val;
                    }
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Achternaam',
                  ),
                  onChanged: (val) {
                    if(val == null || val == "" || val.isEmpty) {
                      lastName = null;
                    } else {
                      lastName = val;
                    }
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                    title: const Text('is een VG?'),
                    value: isVg,
                    onChanged: (val) {
                      setState(() {
                        isVg = val!;
                      });
                    }
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'VG bijnaam. Leeglaten als je er geen hebt.',
                  ),
                  onChanged: (val) {
                    if(val == null || val == "" || val.isEmpty){
                      vGName = "vG";
                    }
                    else {
                      vGName = val;
                    }

                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('is een logee?'),
                  onChanged: (val) {
                    setState(() {
                      isLogee = val!;
                    });
                  },
                  value: isLogee,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Woont hij er nu?'),
                  onChanged: (val) {
                    setState(() {
                      isHuidigeBewoner = val!;
                    });
                  },
                  value: isHuidigeBewoner,
                ),
              ),

              /// Foto can alleen toegevoegd worden nadat een persoon gemaakt is.
              // Expanded(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.black,
              //     ),
              //     onPressed: () {
              //       // Get image
              //       // TODO: TEST IMAGE ADDING
              //       if( (firstName == null || firstName == "") && (lastName == null || lastName == "" )) {
              //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //           content: SnackBarText(text: "Vul eerst de voornaam en/of achternaam in.",),
              //         ));
              //         return;
              //       }
              //
              //
              //     },
              //     child: const Text("Foto toevoegen"),
              //   ),
              // ),
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () async {
                        if(firstName == null){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: SnackBarText(text: "Vul de voornaam in.",),
                          ));
                          return;
                        }

                        if(lastName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: SnackBarText(text: "Vul de achternaam in."),
                          ));
                          return;
                        }

                        if(isLogee && isVg) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: SnackBarText(text: "Iemand kan niet en vG en Logee zijn.",),
                          ));
                          return;
                        }

                        // Add User
                        if(firstName != null && lastName != null) {
                          Person person = Person(
                            firstName: firstName!,
                            lastName: lastName!,
                            vGName: vGName,
                            isVg: isVg,
                            isLogee: isLogee,
                            // PhotoBase64: imgString,
                            isHuidigeBewoner: isHuidigeBewoner,
                          );

                          Preferences.addPerson(person);

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: SnackBarText(text: "Persoon toegevoegd"),
                          ));

                          widget.OnPersonAdded();
                        }
                      },
                      child: const Text("Toevoegen!",
                          style: TextStyle(
                            //fontSize: 40,
                          )
                      )
                  )
              )
            ],
          ),
        ),
      ],
    );
  }
}



