import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/helpers/StaticIcons.dart';
import 'package:morgen_misschien/models/FullPerson.dart';
import 'package:morgen_misschien/models/Person.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';

import '../models/PersonValue.dart';

/*
ONE SOLUTION:
* OKAY what needs to happen:
* OrderBeerWidgets are created automatically
* OrderBeerWidget needs to call the parent with the updated value when it changed, together with the first and last name
* The parent saves this in a map, where the first and lastname are the keys and the value is the value
* When a button is pressed, we need to clear values of the other OrderBeerWidgets(Except if it is cleared when we go to another screen?)
* And the parent then processes the data and goes to the throwing screen
* */


class OrderBeerWidget extends StatefulWidget {
  OrderBeerWidget({required this.fullPerson, required this.onButtonPressed,this.iconSize = 30, this.imageSize = 200, this.textSize = 30, required this.onValueChanged});

  final FullPerson fullPerson;
  final double iconSize;
  final double imageSize;
  final double textSize;

  final Function(PersonValue) onValueChanged;
  final Function(String, String) onButtonPressed;


  @override
  State<OrderBeerWidget> createState() => _OrderBeerWidgetState();
}

class _OrderBeerWidgetState extends State<OrderBeerWidget> {
  int beerCounter = 0;

  static const double dividerHeight = 50;
  static const double containerHeight = 300;
  static const double containerWidth = 300;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: Preferences.getBadgeSize(),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:

              if(snapshot.hasError || snapshot.data == null) {
                return const NoPersonFoundWidget();
              }

              Widget iconBtn;
              if(widget.fullPerson.img == null) {
                iconBtn = IconButton(
                  icon: const Icon(StaticIcons.missingImage),
                  iconSize: widget.imageSize,
                  onPressed: () {
                    widget.onButtonPressed(widget.fullPerson.person.firstName, widget.fullPerson.person.lastName);
                  },
                );
              } else {
                iconBtn = IconButton(
                  icon: Image(
                    image: widget.fullPerson.img!,
                    fit: BoxFit.fill,
                  ),
                  iconSize: widget.imageSize,
                  onPressed: () {
                    widget.onButtonPressed(widget.fullPerson.person.firstName, widget.fullPerson.person.lastName);
                  },
                );
              }

              return Container(
                // color: Colors.black12,
                width: containerWidth,
                height: containerHeight,
                child:
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // All Time Badges
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getAllTimeBadges(snapshot.data),
                        ),
                        // HV Badges
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getHVBadges(snapshot.data),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        iconBtn,
                        Flexible(
                          child: Text(
                              '${widget.fullPerson.person.correctName()}',
                              //widget.fullPerson.person.correctName(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: widget.textSize,
                              )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            IconButton(
                              iconSize: widget.iconSize,
                              icon: const Icon(StaticIcons.remove),
                              onPressed: () {
                                setState(()  {
                                  beerCounter++;
                                  widget.onValueChanged(PersonValue(widget.fullPerson.person.firstName, widget.fullPerson.person.lastName, beerCounter));
                                });
                              },
                            ),
                            Text(
                                "$beerCounter",
                                style: TextStyle(
                                  fontSize: widget.iconSize,
                                )
                            ),
                            IconButton(
                              iconSize: widget.iconSize,
                              icon: const Icon(StaticIcons.add), //Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(()  {
                                  beerCounter++;
                                  widget.onValueChanged(PersonValue(widget.fullPerson.person.firstName, widget.fullPerson.person.lastName, beerCounter));
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    )],
                ),
              );
          }
        }
    );
  }

  List<Widget> getAllTimeBadges(double size) {
    List<Widget> badges = <Widget>[];
    if(widget.fullPerson.AllTimeDrinkingRecord) {
      badges.add(
          Icon(
            StaticIcons.allTimeDrinkingRecord,
            size: size,
          )
      );
    }

    if(widget.fullPerson.AllTimeHitRecord) {
      badges.add(
          Icon(
            StaticIcons.allTimeHitRecord,
            size: size,
          )
      );
    }

    if(widget.fullPerson.AllTimeHitRatioRecord) {
      badges.add(
          Icon(
              StaticIcons.allTimeHitRatioRecord,
              size: size
          )
      );
    }
    badges.add(
        const Divider(height: dividerHeight)
    );

    return badges;
  }

  List<Widget> getHVBadges(double size) {
    List<Widget> badges = <Widget>[];
    if(widget.fullPerson.HVDrinkingRecord) {
      badges.add(
          Icon(
            StaticIcons.HVDrinkingRecord,
            size: size,
          )
      );
    }

    if(widget.fullPerson.HVHitRecord) {
      badges.add(
          Icon(
            StaticIcons.HVHitRecord,
            size: size,
          )
      );
    }

    if(widget.fullPerson.HVHitRatioRecord) {
      badges.add(
          Icon(
            StaticIcons.HVHitRatioRecord,
            size: size,
          )
      );
    }

    badges.add(
      const Divider(height: dividerHeight)
    );

    return badges;
  }
}