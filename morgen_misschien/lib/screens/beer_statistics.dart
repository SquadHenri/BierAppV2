

import 'package:flutter/material.dart';
import 'package:morgen_misschien/models/Person.dart';
import 'package:morgen_misschien/widgets/HuisBierWidget.dart';

import '../helpers/Preferences.dart';
import '../widgets/NoPersonFoundWidget.dart';

// BeersHV
// BeersTotal
// CleaningBeerHV
// CleaningBeerTotal
class BeerStatistics extends StatefulWidget {
  const BeerStatistics({Key? key}) : super(key: key);

  @override
  State<BeerStatistics> createState() => _BeerStatisticsState();
}

class _BeerStatisticsState extends State<BeerStatistics> {
  bool showOnlyHuidigeBewoners = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: showOnlyHuidigeBewoners ? Preferences.getHuidigeBewoners() : Preferences.getBewoners(),
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {

            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container();
            case ConnectionState.done:
              if(snapshot.hasError || snapshot.data == null) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Bier Statistieken'),
                    centerTitle: true,
                    backgroundColor: Colors.black,
                  ),
                  body: const NoPersonFoundWidget(),
                );
              }
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Bier statistieken'),
                    centerTitle: true,
                    backgroundColor: Colors.black,
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                              Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                          ),
                          child: CheckboxListTile(
                                title: const Text('Alleen huidige bewoners laten zien'),
                                value: showOnlyHuidigeBewoners,
                                onChanged: (val) {
                                  setState(() {
                                    showOnlyHuidigeBewoners = val!;
                                  });
                                }
                            ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Naam')),
                            DataColumn(label: Text('Bier HV')),
                            DataColumn(label: Text('Bier Totaal')),
                            DataColumn(label: Text('Schoonmaakbier HV')),
                            DataColumn(label: Text('Schoonmaakbier Totaal')),
                          ],
                          rows: personsToDataRows(snapshot.data),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: HuisBierWidget(),
                      )
                    ],
                  )
              );
          }
        }
    );
  }

  List<DataRow> personsToDataRows(List<Person> persons) {
    List<DataRow> res = <DataRow>[];
    for(Person person in persons) {
      List<DataCell> cells = <DataCell>[];
      cells.add(
          DataCell(Text(person.correctName()))
      );

      cells.add(
          DataCell(Text('${person.BeersHV}'))
      );

      cells.add(
          DataCell(Text('${person.BeersTotal}'))
      );

      cells.add(
          DataCell(Text('${person.CleaningBeerHV}'))
      );

      cells.add(
          DataCell(Text('${person.CleaningBeerTotal}'))
      );

      res.add(DataRow(
        cells: cells,
      ));
    }

    return res;
  }
}


