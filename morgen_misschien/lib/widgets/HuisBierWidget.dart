// Simple widget that show huis bier
import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';

class HuisBierWidget extends StatelessWidget {
  HuisBierWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: Preferences.getHouseBeers(),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {

            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Text('Geen huisbier.');
            case ConnectionState.done:
              if(snapshot.hasError || snapshot.data == null) {
                return Text('Huis bier error.');
              }

              return(
              Text(
                  'Er is ${snapshot.data} bier op MM gestreept.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),)
              );
          }
        }
    );
  }
}
