
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Person.dart';

class DatabaseHelper {
  static final _databaseName = "MMDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    // Lazily instantiate the database the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  void _onCreate(Database database, int version) async {
    await database.execute("CREATE TABLE Person ("
        "firstName TEXT,"
        "lastName TEXT,"
        "isVg INTEGER," // SQLite does not support boolean. 0 = false, 1 = true
        "isLogee INTEGER,"
        "vGName TEXT,"
        "BeersHV INTEGER,"
        "BeersTotal INTEGER,"
        "MissedHV INTEGER,"
        "MissedTotal INTEGER,"
        "HitHV INTEGER,"
        "HitTotal INTEGER,"
        "CleaningBeerHV INTEGER,"
        "CleaningBeerTotal INTEGER,"
        "PhotoBase64 TEXT"
        ")");

    // Insert MM as a person
    await database.execute("INSERT INTO Person (firstName, lastName, isVg, isLogee, vGName, BeersHV, BeersTotal, MissedHV, MissedTotal,"
        "HitHV, HitTotal, CleaningBeerHV, CleaningBeerTotal, PhotoBase64) "
        "VALUES ('MM', 'MM', 0, 0, '', 0, 0, 0, 0, 0, 0, 0,0, '')");
  }

  Future<int?> createPerson(Person person) async {
    Database? database = await instance.database;
    if (database == null) {
      return null;
    }

    var result = await database.insert("Person", person.toJson());
    return result;
  }

  Future<List?> getPersons() async {
    Database? database = await instance.database;
    if (database == null) {
      return null;
    }

    var result = await database.query("Person", columns: [
      "firstname",
      "lastName",
      "isVg",
      "isLogee",
      "vGName",
      "BeersHV",
      "BeersTotal",
      "MissedHV",
      "MissedTotal",
      "HitHV",
      "HitTotal",
      "CleaningBeerHV",
      "CleaningBeerTotal",
      "PhotoBase64",
    ]);

    return result.toList();
  }

  Future<Person?> getPerson(String firstName, String lastName) async {
    Database? database = await instance.database;
    if (database == null) {
      return null;
    }

    List<Map> results = await database.query("Person",
        columns: [
          "firstname",
          "lastName",
          "isVg",
          "isLogee",
          "vGName",
          "BeersHV",
          "BeersTotal",
          "MissedHV",
          "MissedTotal",
          "HitHV",
          "HitTotal",
          "CleaningBeerHV",
          "CleaningBeerTotal",
          "PhotoBase64"
        ],
        where: 'firstName = ? and lastName = ?',
        whereArgs: [firstName, lastName]
    );
    if (results.length > 0) {
      return Person.fromJson(results.first);
    }

    return null;
  }

  Future<int?> updatePerson(Person person) async {
    Database? database = await instance.database;
    if (database == null) {
      return null;
    }

    return await database.update("Person",
        person.toJson(),
        where: 'firstName = ? and lastName = ?',
        whereArgs: [person.firstName, person.lastName]);
  }

  Future<int?> deletePerson(String firstName, String lastName) async {
    Database? database = await instance.database;
    if (database == null) {
      return null;
    }
    return await database.delete("Person",
        where: 'firstName = ? and lastName = ?',
        whereArgs: [firstName, lastName]);
  }
}