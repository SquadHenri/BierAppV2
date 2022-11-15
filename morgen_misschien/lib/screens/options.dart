import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import 'package:morgen_misschien/widgets/SnackBarText.dart';


class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

// Change Badge size
// Reset HV
class _OptionsScreenState extends State<OptionsScreen> {
  late double badgeSize;

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
              Widget editBadgeSizeWidget;
              if(snapshot.hasError || snapshot.data == null) {
                editBadgeSizeWidget = const Text('Kan badge size niet aanpassen.');
              } else {
                editBadgeSizeWidget = Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                        'Hier kun je de grootte van de badges aanpassen. De standaard grootte is 30. Doe wel een beetje normaal: ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'badge grootte',
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (val) {
                          Preferences.setBadgeSize(double.parse(val));

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: SnackBarText(text: 'Waarde aangepast!'),
                              ));
                        },
                      ),
                    ),
                    VerticalDivider(width: 150),
                  ]
                );
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Instellingen'),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                ),
                body: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Weet je het zeker?'),
                                    content: const Text('Weet je zeker dat je een HV reset wilt doen? Dit reset voor iedereen:\n'
                                        '- Raak gegoooid deze HV\n'
                                        '- Mis gegooid deze HV\n'
                                        '- schoonmaakBier deze HV\n'
                                        '- Bier gestreept deze HV\n'
                                        '- Huisbier'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {

                                          Preferences.resetHV();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: SnackBarText(text: 'HV gereset',),
                                              ));

                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ja'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      child: const Text('Nee'),
                                      ),
                                    ],
                                  ),
                              );
                            },
                            child: const Text('HV Reset'),
                          ),
                    ),
                      ),
                      editBadgeSizeWidget
                    ]
                ),
              );
          }
        }
    );
  }
}
