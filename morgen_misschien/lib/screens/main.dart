import 'package:flutter/material.dart';
import 'package:morgen_misschien/screens/add_cleaning_beer.dart';
import 'package:morgen_misschien/screens/beer_statistics.dart';
import 'package:morgen_misschien/screens/cleaning_edit_choice.dart';
import 'package:morgen_misschien/screens/edit_order.dart';
import 'package:morgen_misschien/screens/edit_user_values.dart';
import 'package:morgen_misschien/screens/edit_users.dart';
import 'package:morgen_misschien/screens/fun_statistics.dart';
import 'package:morgen_misschien/screens/options.dart';

import 'package:morgen_misschien/screens/statistics_choice.dart';
import 'package:morgen_misschien/screens/order_beer.dart';
import 'package:morgen_misschien/screens/throwing.dart';
import 'package:morgen_misschien/widgets/IconTextButton.dart';

void main() {
  runApp(MaterialApp(
    // CHANGE FOR DEBUGGING PURPUSES TO WHATEVER
    // it SHOULD BE '/'
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/order-beer' : (context) => OrderBeer(),
      '/statistics-choice': (context) => StatisticsChoice(),
      '/statistics-choice/fun-statistics': (context) => FunStatistics(),
      '/statistics-choice/beer-statistics' : (context) => BeerStatistics(),
      '/cleaning-edit-choice': (context) => CleaningEditChoice(),
      '/cleaning-edit-choice/edit-users': (context) => EditUsers(),
      '/cleaning-edit-choice/edit-order': (context) => EditOrder(),
      '/cleaning-edit-choice/add-cleaning-beer': (context) => AddCleaningBeer(),
      '/cleaning-edit-choice/edit-users/edit-user-values': (context) => EditUserValues(),
      '/cleaning-edit-choice/options': (context) => OptionsScreen(),
    }
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Morgen Misschien'),
      centerTitle: true,
      backgroundColor: Colors.black,
    ),
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/LogoMM-Transparent.png"),
          //fit: BoxFit.none,
        )
      ),
      child: Column(
        children: <Widget> [
          const Expanded(
            flex: 1,
              child: Center(
                child: Text(
                    'Welkom op Huize Morgen Misschien!',
                    style: TextStyle(
                      fontSize: 40,
                    )
                ),
              )
          ),
          Expanded(
              flex: 2,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget> [
                    IconTextButton(
                      OnPressed: () {
                        Navigator.pushNamed(context, '/order-beer');
                      },
                      icon: Image.asset('assets/icons/beer512.png'),
                      text: "Bier Strepen",
                    ),
                    IconTextButton(
                        OnPressed: () {
                          Navigator.pushNamed(context, '/statistics-choice');
                        },
                        icon: Image.asset('assets/icons/ic_graph.png'),
                        text: 'Statistieken',
                    )
                  ]
              )
          ),
        ],
      ),
    ),
    floatingActionButton: SizedBox(
      height: 100,
      width: 100,
      child: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/cleaning-edit-choice');
        },
        child: const Text('MM\'ers'),
      ),
    ),
  );
  }
}

