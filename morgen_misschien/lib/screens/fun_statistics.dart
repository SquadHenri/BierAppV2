import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/widgets/NoPersonFoundWidget.dart';

import '../models/Person.dart';

// Show:
// MissedHV, MissedTotal
// HitHV, HitToal
// BeersTotalRecord
// HitTotalRecord
// HitRatioRecord
class FunStatistics extends StatefulWidget {
  const FunStatistics({Key? key}) : super(key: key);

  @override
  State<FunStatistics> createState() => _FunStatisticsState();
}

class _FunStatisticsState extends State<FunStatistics> {
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
                    title: const Text('Leuke Statistieken'),
                    centerTitle: true,
                    backgroundColor: Colors.black,
                  ),
                  body: const NoPersonFoundWidget(),
                );
              }

              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Leuke Statistieken'),
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
                          columnSpacing: 15,
                          columns: const [
                            DataColumn(label: Text('Naam')),
                            DataColumn(label: Text('Raak Gegooid HV')),
                            DataColumn(label: Text('Raak Gegooid Totaal')),
                            DataColumn(label: Text('Gemist HV')),
                            DataColumn(label: Text('Gemist Totaal')),
                            DataColumn(label: Text('Raak Gegooid Record')),
                            DataColumn(label: Text('Ratio Record')),
                            DataColumn(label: Text('Bier Record')),
                          ],
                          rows: personsToDataRows(snapshot.data),
                        ),
                      ),
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("\'Bier Record\' is het meest aantal bier wat je in 1 HV hebt gedronken. Hier bij telt niet het bier dat je hebt geopend door raak te gooien.")),
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("\'Raak Gegooid Record\' is het meest aantal keer dat je een dopje raak hebt gegooid in 1 HV")),
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("\'Ratio Record\' is de beste verhouding raak gegooid in 1 HV. Berekend als: raak / (mis + raak)")),
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
          DataCell(Text('${person.HitHV}'))
      );

      cells.add(
          DataCell(Text('${person.HitTotal}'))
      );

      cells.add(
          DataCell(Text('${person.MissedHV}'))
      );

      cells.add(
          DataCell(Text('${person.MissedTotal}'))
      );



      cells.add(
          DataCell(Text('${person.HitTotalRecord}'))
      );

      cells.add(
          DataCell(Text(person.HitRatioRecord.toStringAsFixed(4)))
      );

      cells.add(
          DataCell(Text('${person.BeersTotalRecord}'))
      );

      res.add(DataRow(
        cells: cells,
      ));
    }

    return res;
  }
}
