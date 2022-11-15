import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/Preferences.dart';
import '../models/PersonValue.dart';

class ThrowingScreen extends StatefulWidget {
  ThrowingScreen({Key? key, required this.firstName, required this.lastName, required this.beersToThrow}) : super(key: key);

  // The firstName and lastName of the person that is throwing
  final String firstName;
  final String lastName;

  // Initial amount of beers to throw
  final int beersToThrow;

  final double height = 150;
  final double width = 150;

  @override
  State<ThrowingScreen> createState() => _ThrowingScreenState();
}

class _ThrowingScreenState extends State<ThrowingScreen> {
  // These three are required, the person is done throwing when:
  //  hit + widget.beersToThrow + uitHetRaam - Thrown == 0
  int hit = 0;
  int thrown = 0;
  int outTheWindow = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: const Text('Bier Strepen'),
       centerTitle: true,
       backgroundColor: Colors.black,
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           Center(
               child: (hit + widget.beersToThrow + outTheWindow - thrown) == 1 ? Text(

               'Je moet nog 1 dopje gooien.'
           ) : Text(
                 'Je moet nog ${hit + widget.beersToThrow + outTheWindow - thrown} dopjes gooien'
               )
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               SizedBox(
                 width: widget.width,
                 height: widget.height,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     primary: Colors.black,
                   ),
                   onPressed: () {
                     // Add to thrown and hit
                     setState(() {
                       hit++;
                       thrown++;
                     });
                   },
                   child: const Text("Raak!"),
                 )
               ),
               SizedBox(
                   width: widget.width,
                   height: widget.height,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       primary: Colors.black,
                     ),
                     onPressed: () {
                       setState(() {
                         thrown++;
                       });
                       checkIfDoneAndReturn();
                     },
                     child: const Text("Mis!"),
                   )
               ),
               SizedBox(
                   width: widget.width,
                   height: widget.height,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       primary: Colors.black,
                     ),
                     onPressed: () {
                       setState(() {
                         thrown++;
                         outTheWindow++;
                       });
                     },
                     child: const Text("Uit het raam!"),
                   )
               ),
               SizedBox(
                   width: widget.width,
                   height: widget.height,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       primary: Colors.black,
                     ),
                     onPressed: () {
                       setState(() {
                         // hit + widget.beersToThrow + outTheWindow - thrown == 0
                         thrown = hit + widget.beersToThrow + outTheWindow;
                       });
                       checkIfDoneAndReturn();
                     },
                     child: const Text("De rest mis!"),
                   )
               ),
             ]
           ),
         ],
       ),
     ),
    );
  }

  void checkIfDoneAndReturn() {
    if(hit + widget.beersToThrow + outTheWindow - thrown == 0) {
      Preferences.addBeerToThrowingPerson(widget.firstName, widget.lastName, hit + outTheWindow, hit, thrown);

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/order-beer');
    }
  }
}
