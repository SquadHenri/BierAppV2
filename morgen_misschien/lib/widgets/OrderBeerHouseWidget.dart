import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/StaticIcons.dart';

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


class OrderBeerHouseWidget extends StatefulWidget {
  OrderBeerHouseWidget({required this.onButtonPressedHouse,this.iconSize = 30, this.imageSize = 200, this.textSize = 30, required this.onValueChangedHouse});

  final double iconSize;
  final double imageSize;
  final double textSize;

  final Function(int) onValueChangedHouse;
  final Function() onButtonPressedHouse;


  @override
  State<OrderBeerHouseWidget> createState() => _OrderBeerHouseWidgetState();
}

class _OrderBeerHouseWidgetState extends State<OrderBeerHouseWidget> {
  int beerCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          IconButton(
            icon: const Icon(
                Icons.home_rounded,
              color: Colors.black,
            ),
            // const Image(
            //     image: AssetImage("assets/images/LogoMM-Transparent.png"),
            //     fit: BoxFit.fill
            // ),
            iconSize: widget.imageSize,
            onPressed: null,
          ),
          Text("Huis Bier",
              style: TextStyle(
                fontSize: widget.textSize,
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              IconButton(
                  icon: const Icon(StaticIcons.remove),
                  iconSize: widget.iconSize,
                  // Substract from BeerCounter
                  onPressed: () {
                    if(beerCounter > 0) {
                      setState(() {
                        beerCounter--;
                        widget.onValueChangedHouse(beerCounter);
                      });
                    }
                  }
              ),
              Text(
                  "$beerCounter",
                  style: TextStyle(
                    fontSize: widget.iconSize,
                  )
              ),
              IconButton(
                iconSize: widget.iconSize,
                icon: const Icon(StaticIcons.add),
                onPressed: () {
                  setState(()  {
                    beerCounter++;
                    widget.onValueChangedHouse(beerCounter);
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