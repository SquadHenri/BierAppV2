import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/StaticIcons.dart';
import 'package:morgen_misschien/models/FullPerson.dart';
import 'package:morgen_misschien/screens/throwing.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';
import 'package:morgen_misschien/widgets/OrderBeerHouseWidget.dart';
import 'package:morgen_misschien/widgets/OrderBeerWidget.dart';

import '../helpers/Preferences.dart';
import '../models/Person.dart';
import '../models/PersonValue.dart';
import '../widgets/SnackBarText.dart';


// NOTE WE CAN HAVE AN APP WITH ONLY 4 PEOPLE FOR EXAMPLE
// SO WE NEED TO CHECK HOW MANY PEOPLE THERE ARE AND
// A SECTION NEEDS TO BE EMPTY AND DISABLED IF THERE IS
// NO PERSON!
// 2 rows, with 3 columns per row
// Each column has to have the following:
// - Name or vGName of the user
// - Image for the user
// - Then a row with buttons for the user:
//    - Add beer
//    - Text for how many beers on that person
//    - Substract beer

class OrderBeer extends StatefulWidget {
  const OrderBeer({Key? key}) : super(key: key);

  @override
  State<OrderBeer> createState() => _OrderBeerState();
}

class _OrderBeerState extends State<OrderBeer> {
  List<PersonValue> personValues = <PersonValue>[];
  int houseBeers = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: Preferences.getFullPersons(),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {

            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const CircularProgressIndicator();
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

              List<Widget> orderBeerWidgets = <Widget>[];
              for(FullPerson fullPerson in snapshot.data) {
                orderBeerWidgets.add(
                    OrderBeerWidget(
                      fullPerson: fullPerson,
                      onValueChanged: onValueChanged,
                      onButtonPressed: onButtonPressed,
                    )
                );
              }

              // Add Huis Bier
              orderBeerWidgets.add(OrderBeerHouseWidget(
                  onButtonPressedHouse: onButtonPressedHouse,
                  onValueChangedHouse: onValueChangedHouse)
              );

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Bier Strepen'),
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
                        children: orderBeerWidgets,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                            ),
                            onPressed: () {
                              bool beerAdded = false; // Check if any beer was added
                                                      // ie: should be false if all values are 0
                              for(PersonValue pv in personValues) {
                                if(pv.value == 0) { continue; }
                                Preferences.addBeerToPerson(pv.firstName, pv.lastName, pv.value);
                                beerAdded = true;
                              }
                              if(houseBeers > 0) {
                                Preferences.addHouseBeers(houseBeers);
                                beerAdded = true;
                              }

                              if(beerAdded == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: const SnackBarText(text: 'Je moet wel bier strepen',),
                                    ));
                                return;
                              }

                              Navigator.popAndPushNamed(context, '/order-beer');

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: const SnackBarText(text: 'Bier Gestreept!',),
                                ));
                            },
                            child: const Text("Strepen voor niet MMers",
                                style: TextStyle(
                                  fontSize: 40,
                                )
                            )
                        ),
                      )
                    ],
                  ),
                ),
                floatingActionButton: Container(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: const Text('Badges'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Badges Uitleg'),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Uitleg van de verschillende badges. Er zijn 3 categorieën, en ze worden voor de huidige HV bijgehouden, en de beste score in een HV ooit. De badges worden verdeeld onder mensen die nu op MM wonen, oud huisgenoten doen niet mee.'),
                                const Text(''),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(StaticIcons.allTimeHitRatioRecord),
                                    Text(' dit geeft aan wie in 1 HV de beste raak/mis verhouding heeft gehaald'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(StaticIcons.HVHitRatioRecord),
                                    Text(' dit geeft aan wie deze HV de beste raak/mis verhouding heeft'),
                                  ],
                                ),
                                const Text(''),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(StaticIcons.allTimeHitRecord),
                                    Text(' dit geeft aan wie in 1 HV het meest heeft raak gegooid.'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(StaticIcons.HVHitRecord),
                                    Text(' dit geeft aan wie in deze HV het meest heeft raak gegooid'),
                                  ],
                                ),
                                const Text(''),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(StaticIcons.allTimeDrinkingRecord),
                                    Text(' dit geeft aan wie in 1 HV het meeste bier heeft gestreept op zichzelf.'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(StaticIcons.HVDrinkingRecord),
                                    Text(' dit geeft aan wie in deze HV het meeste bier heeft gestreept op zichzelf.'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          barrierDismissible: true
                      );
                    },
                  ),
                ),
              );
          }
        }
    );
  }

  void onValueChangedHouse(int value) {
    houseBeers = value;
  }

  void onButtonPressedHouse() {
    // What to do?
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: SnackBarText(text: 'Dit doet niks. Er moet Iemand gooien'),
    ));
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

  // Callback for OrderBeerWidgets to inform us when to process the beer
  void onButtonPressed(String firstName, String lastName) {
    // Process Beer
    bool beerAdded = false; // Check if any beer was added
    // ie: should be false if all values are 0

    int beersToThrow = 0;
    for(PersonValue pv in personValues) {
      if(pv.value == 0) { continue; }
      Preferences.addBeerToPerson(pv.firstName, pv.lastName, pv.value);
      beersToThrow += pv.value;
      beerAdded = true;
    }
    if(houseBeers > 0) {
      Preferences.addHouseBeers(houseBeers);
      beersToThrow += houseBeers;
      beerAdded = true;
    }

    if(beerAdded == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: SnackBarText(text: 'Je moet wel bier strepen',),
          ));
      return;
    }

    // Throwing
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ThrowingScreen(
        firstName: firstName,
        lastName: lastName,
        beersToThrow: beersToThrow,
      )
    ));
  }
}