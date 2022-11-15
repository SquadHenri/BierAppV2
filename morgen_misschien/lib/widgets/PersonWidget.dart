
import 'package:flutter/material.dart';
import 'package:morgen_misschien/models/Person.dart';

// Used to display information about a single Person, with stats
class PersonWidget extends StatelessWidget {
  const PersonWidget(this.person);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          Expanded(
              flex: 4,
              child: Text(person.correctName()),
          ),
          Expanded(
            child: Text('$person.BeersHV'),
          ),
          Expanded(
            child: Text('$person.BeersTotal'),
          ),
          Expanded(
            child: Text('$person.MissedHV'),
          ),
          Expanded(
            child: Text('$person.MissedTotal'),
          ),
          Expanded(
            child: Text('$person.HitHV'),
          ),
          Expanded(
            child: Text('$person.HitTotal'),
          ),
          Expanded(
            child: Text('$person.CleaningBeerHV'),
          ),
          Expanded(
            child: Text('$person.CleaningBeerTotal'),
          ),
        ],
      ),
    );
  }
}
