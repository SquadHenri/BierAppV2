
import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/helpers/StaticIcons.dart';
import 'package:morgen_misschien/screens/add_cleaning_beer.dart';

import '../models/PersonValue.dart';

class AddCleaningBeerWidget extends StatefulWidget {
  AddCleaningBeerWidget({required this.firstName, required this.lastName, required this.correctName, this.iconSize = 30, this.imageSize = 200, this.textSize = 30, required this.onValueChanged});

  final String firstName;
  final String lastName;
  final String correctName;
  final double iconSize;
  final double imageSize;
  final double textSize;

  final Function(PersonValue) onValueChanged;

  @override
  State<AddCleaningBeerWidget> createState() => _AddCleaningBeerWidgetState();
}

class _AddCleaningBeerWidgetState extends State<AddCleaningBeerWidget> {
  int cleaningBeerCounter = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: Preferences.getImageForPerson(widget.firstName, widget.lastName),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              Widget iconBtn;
              if(snapshot.data == null) {
                iconBtn = IconButton(
                  icon: const Icon(StaticIcons.missingImage),
                  iconSize: widget.imageSize,
                  onPressed: () {},
                );
              } else {
                iconBtn = IconButton(
                  icon: Image(
                    image: snapshot.data,
                    fit: BoxFit.fill,
                  ),
                  iconSize: widget.imageSize,
                  onPressed: () {
                    cleaningBeerCounter++;
                    widget.onValueChanged(PersonValue(widget.firstName, widget.lastName, cleaningBeerCounter));
                  },
                );
              }

              return Container(
                width: 300,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    iconBtn,
                    Expanded(
                      child: Text(widget.correctName,
                          style: TextStyle(
                            fontSize: widget.textSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        IconButton(
                            icon: const Icon(StaticIcons.remove),
                            iconSize: widget.iconSize,
                            // Substract from BeerCounter
                            onPressed: () {
                              if(cleaningBeerCounter > 0) {
                                setState(() {
                                  cleaningBeerCounter--;
                                  widget.onValueChanged(PersonValue(widget.firstName, widget.lastName, cleaningBeerCounter));
                                });
                              }
                            }
                        ),
                        Text(
                            "$cleaningBeerCounter",
                            style: TextStyle(
                              fontSize: widget.iconSize,
                            )
                        ),
                        IconButton(
                          iconSize: widget.iconSize,
                          icon: const Icon(StaticIcons.add),
                          onPressed: () {
                            setState(()  {
                              cleaningBeerCounter++;
                              widget.onValueChanged(PersonValue(widget.firstName, widget.lastName, cleaningBeerCounter));
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
          }
        }
    );
  }
}
