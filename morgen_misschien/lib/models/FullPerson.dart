import 'package:flutter/material.dart';
import 'package:morgen_misschien/models/Person.dart';


// A class used to represent a person, together
// with the person's image and badges information
// This is used by OrderBeerWidget, to make the widget
class FullPerson {
  FullPerson({
    required this.AllTimeDrinkingRecord,
    required this.AllTimeHitRatioRecord,
    required this.AllTimeHitRecord,
    required this.HVDrinkingRecord,
    required this.HVHitRatioRecord,
    required this.HVHitRecord,
    required this.person,
    this.img
});

  bool HVDrinkingRecord; // Most beers drunk this HV
  bool AllTimeDrinkingRecord; // Most beers drunk during a HV all-time

  bool HVHitRecord; // Most caps hit this HV
  bool AllTimeHitRecord; // Most caps hit during a HV all-time

  bool HVHitRatioRecord; // Best hit ratio this HV
  bool AllTimeHitRatioRecord; // Best hit ratio during a HV all-time

  Person person;

  FileImage? img;
}