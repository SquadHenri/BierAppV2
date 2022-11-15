
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:morgen_misschien/helpers/ImageHelper.dart';
import 'package:morgen_misschien/models/FullPerson.dart';
import 'package:morgen_misschien/models/Person.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/PersonValue.dart';


// Class to manage shared preferences
class Preferences {

  static const String backFile = 'backup.txt';

  // Key for getting all bewoners, this DOES include huidige bewoners
  static const String bewonersKey = 'Bewoners';
  static const String huisKey = 'Huis';
  static const String badgeSizeKey = 'Badge';

  static const double defaultBadgeSize = 30;

  // List<String> or List<Person>???
  static Future<void> changeOrder(List<Person> persons, int oldIndex, int newIndex) async {
    debugPrint('changing Order!');
    Person tempPerson = persons[oldIndex];
    persons[oldIndex] = persons[newIndex];
    persons[newIndex] = tempPerson;

    List<String> updatedBewoners = <String>[];
    for(Person person in persons) {
      updatedBewoners.add(jsonEncode(person));
    }

    final prefs = await SharedPreferences.getInstance();

    List<Person>? notHuidigeBewoners = await getNotHuidigeBewoners();
    if(notHuidigeBewoners == null) {
      prefs.setStringList(bewonersKey, updatedBewoners);
    }
    else {
      for(Person person in notHuidigeBewoners) {
        updatedBewoners.add(jsonEncode(person));
      }
      prefs.setStringList(bewonersKey, updatedBewoners);
    }

  }

  static void printList(List<Person> persons) {
    for(Person person in persons) {
      debugPrint(person.firstName);
    }
  }


  static void addCleaningBeer(List<PersonValue> personValues) async {
    List<Person>? persons = await getBewoners();
    if(persons == null) { return; }

    for(Person person in persons) {
      PersonValue pv = personValues.where((x) => x.firstName == person.firstName && x.lastName == person.lastName).first;
      if(pv == null) {
        // ERROR
        continue;
      }
      person.CleaningBeerHV += pv.value;
      person.CleaningBeerTotal += pv.value;
      updatePerson(person);
    }
  }

  static void addBeerToPerson(String firstName, String lastName, int beers) async {
    List<Person>? persons = await getBewoners();
    if(persons == null) { return; }

    for(Person person in persons) {
      if(person.firstName == firstName && person.lastName == lastName) {
        // Add beer
        person.BeersHV += beers;
        person.BeersTotal += beers;

        if(person.BeersHV - person.HitHV > person.BeersTotalRecord) {
          person.BeersTotalRecord = person.BeersHV;
        }

        updatePerson(person);
        return;
      }
    }

  }

  // beers = hit + outTheWindow // These are the extra beers added to the person
  // Thrown = missed + outTheWindow + hit
  // Missed = Thrown - hit
  static void addBeerToThrowingPerson(String firstName, String lastName, int beers, int hit, int thrown) async {
    List<Person>? persons = await getBewoners();
    if(persons == null) { return; }

    for(Person person in persons) {
      if(person.firstName == firstName && person.lastName == lastName) {
        // Add beer
        person.BeersHV += beers;
        person.BeersTotal += beers;

        person.MissedHV += thrown - hit;
        person.MissedTotal += thrown - hit;

        person.HitHV += hit;
        person.HitTotal += hit;

        // Update Records
        person.BeersTotalRecord = max(person.BeersHV - person.HitHV, person.BeersTotalRecord);

        person.HitTotalRecord = max(person.HitHV, person.HitTotalRecord);

        if(person.MissedHV + person.HitHV > 0) {
          if(person.HitHV / (person.HitHV + person.MissedHV) > person.HitRatioRecord) {
            person.HitRatioRecord = person.HitHV / (person.HitHV + person.MissedHV);
          }
        }

        updatePerson(person);
        return;
      }
    }
  }

  // Note: with this system it is not possible to change a persons name
  // We assume a name is static
  // The person given to updatePerson already has the changed information
  static void updatePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);
    if(bewonersJson == null) { return; }

    List<String> updatedBewoners = <String>[];
    for(String JSON in bewonersJson) {
      Person otherPerson = Person.fromJson(jsonDecode(JSON));

      if(person.firstName == otherPerson.firstName && person.lastName == otherPerson.lastName) {
        // Update this person with the given person
        updatedBewoners.add(jsonEncode(person));
      }
      else {
        updatedBewoners.add(jsonEncode(otherPerson));
      }
    }

    prefs.setStringList(bewonersKey, updatedBewoners);
  }

  static Future<List<Person>?> getBewoners() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? HuidigeBewonersJson = prefs.getStringList(bewonersKey);
    if(HuidigeBewonersJson == null) {return null;}

    List<Person> Bewoners = <Person>[];
    for(String JSON in HuidigeBewonersJson) {
      Bewoners.add(Person.fromJson(jsonDecode(JSON)));
    }

    return Bewoners;
  }


  static void resetHV() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);


    final path = '${(await getApplicationDocumentsDirectory()).path}/${backFile}';
    final file = await io.File(path);

    // Write the file
    file.writeAsString(DateTime.now().toString(),mode: FileMode.append);
    file.writeAsString(await getHouseBeers().toString(), mode: FileMode.append);

    if(bewonersJson != null) {
      List<String> updatedBewonersJson = <String>[];

      for(String JSON in bewonersJson) {
        Person person = Person.fromJson(jsonDecode(JSON));
        file.writeAsString(JSON, mode: FileMode.append);

        person.BeersHV = 0;
        person.HitHV = 0;
        person.MissedHV = 0;
        person.CleaningBeerHV = 0;

        updatedBewonersJson.add(jsonEncode(person));
      }
      prefs.setStringList(bewonersKey, updatedBewonersJson);
    }

    // Reset house beer
    prefs.setInt(huisKey, 0);

  }

  static Future<List<Person>?> getHuidigeBewoners() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);
    if(bewonersJson == null) {return null;}

    List<Person> huidigeBewoners = <Person>[];
    for(String JSON in bewonersJson) {
      Person person = Person.fromJson(jsonDecode(JSON));
      if(person.isHuidigeBewoner) { huidigeBewoners.add(person); }
    }

    return huidigeBewoners;
  }

  static Future<List<Person>?> getNotHuidigeBewoners() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);
    if(bewonersJson == null) {return null;}

    List<Person> huidigeBewoners = <Person>[];
    for(String JSON in bewonersJson) {
      Person person = Person.fromJson(jsonDecode(JSON));
      if(!person.isHuidigeBewoner) { huidigeBewoners.add(person); }
    }

    return huidigeBewoners;
  }


  static void addPerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? Bewoners = prefs.getStringList(bewonersKey);

    if(Bewoners == null) {
      List<String> NewBewoners = [jsonEncode(person)];
      prefs.setStringList(bewonersKey, NewBewoners);
    } else {
      for(String JSON in Bewoners) {
        Person otherPerson = Person.fromJson(jsonDecode(JSON));
        if(person.firstName == otherPerson.firstName && person.lastName == otherPerson.lastName) {
          // TODO: SHOW ERROR?
          return;
        }
      }

      Bewoners.add(jsonEncode(person));
      prefs.setStringList(bewonersKey, Bewoners);
    }
  }

  static void changeBewonership(Person person, bool bewonership) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);
    if(bewonersJson == null) {return null;}

    List<String> bewoners = <String>[];

    for(String JSON in bewonersJson) {
      Person resPerson = Person.fromJson(jsonDecode(JSON));
      if(person.firstName == resPerson.firstName && person.lastName == resPerson.lastName) {
        resPerson.isHuidigeBewoner = bewonership;
      }
      bewoners.add(jsonEncode(resPerson));
      prefs.setStringList(bewonersKey, bewoners);
    }


  }

  static void addHouseBeers(int beersToAdd) async {
    final prefs = await SharedPreferences.getInstance();

    int? houseBeers = prefs.getInt(huisKey);
    if(houseBeers == null) {
      prefs.setInt(huisKey, beersToAdd);
      return;
    }

    prefs.setInt(huisKey, beersToAdd + houseBeers);
  }

  static Future<int> getHouseBeers() async {
    final prefs = await SharedPreferences.getInstance();

    int? huisBeers = prefs.getInt(huisKey);
    if(huisBeers == null) {
      prefs.setInt(huisKey, 0);
      return 0;
    }

    return huisBeers;
  }

  static Future<double> getBadgeSize() async {
    final prefs = await SharedPreferences.getInstance();

    double? iconSize = prefs.getDouble(badgeSizeKey);
    if(iconSize == null) {
      return defaultBadgeSize;
    }
    return iconSize;

  }

  static void setBadgeSize(double iconSize) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setDouble(badgeSizeKey, iconSize);
  }

  static Future<Person?> getPerson(String firstName, String lastName) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);
    if(bewonersJson == null) {return null;}

    for(String JSON in bewonersJson) {
      Person person = Person.fromJson(jsonDecode(JSON));
      if(person.firstName == firstName && person.lastName == lastName) {
        return person;
      }
    }

    return null;
  }

  static Future<List?> getPersonWithImage(String firstName, String lastName) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? bewonersJson = prefs.getStringList(bewonersKey);
    if(bewonersJson == null) {return null;}

    for(String JSON in bewonersJson) {
      Person person = Person.fromJson(jsonDecode(JSON));
      if(person.firstName == firstName && person.lastName == lastName) {
        FileImage? fileImage = await getImageForPerson(person.firstName, person.lastName);
        return [Person, fileImage];
      }
    }

    return null;
  }

  static Future<FileImage?> getImageForPerson(String firstName, String lastName) async {
    final String folderPath = (await getApplicationDocumentsDirectory()).path;

    final String imagePath = ImageHelper.imagePath(firstName, lastName);

    bool bExists = await io.File(ImageHelper.fullImagePath(folderPath, imagePath)).exists();
    if(bExists) {
      return FileImage(io.File(ImageHelper.fullImagePath(folderPath, imagePath)));
    } else {
      return null;
    }
  }

  static Future<List<FullPerson>?> getFullPersons() async {
    List<FullPerson>? fullPersons = <FullPerson>[];

    List<Person>? persons = await getHuidigeBewoners();
    if(persons == null) { return null; }

    int AllTimeDrinkingRecord = -1;
    double AllTimeHitRatioRecord = -1;
    int AllTimeHitRecord = -1;
    int HVBeersRecord = -1;
    double HVHitRatioRecord = -1;
    int HVHitRecord = -1;

    // first we loop through everyone to see the highest score
    for(Person person in persons) {
      AllTimeDrinkingRecord = max(AllTimeDrinkingRecord, person.BeersTotalRecord);
      AllTimeHitRatioRecord = max(AllTimeHitRatioRecord, person.HitRatioRecord);
      AllTimeHitRecord = max(AllTimeHitRecord, person.HitTotalRecord);

      HVBeersRecord = max(HVBeersRecord, person.BeersHV);

      if(person.HitHV + person.MissedHV > 0) {
        HVHitRatioRecord = max(HVHitRatioRecord, person.HitHV / (person.HitHV + person.MissedHV));
      }
      HVHitRecord = max(HVHitRecord, person.HitHV);
    }

    // We loop again, and create FullPerson
    for(Person person in persons) {
      FileImage? img = await getImageForPerson(person.firstName, person.lastName);
      fullPersons.add(FullPerson(
          person: person,
          AllTimeDrinkingRecord: (person.BeersTotalRecord == AllTimeDrinkingRecord && AllTimeDrinkingRecord > 0),
          AllTimeHitRatioRecord: (person.HitRatioRecord == AllTimeHitRatioRecord && AllTimeHitRatioRecord > 0),
          AllTimeHitRecord: (person.HitTotalRecord == AllTimeHitRecord && AllTimeHitRecord > 0),
          HVDrinkingRecord: (person.BeersHV == HVBeersRecord && HVBeersRecord > 0),
          HVHitRatioRecord: (person.HitHV / (person.HitHV + person.MissedHV) == HVHitRecord && HVHitRatioRecord > 0),
          HVHitRecord: (person.HitHV == HVHitRecord && HVHitRecord > 0),
          img: img,
      ));
    }

    return fullPersons;
  }
}