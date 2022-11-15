

// All persons are saved in JSON using sharedPrefs stringList
// Image is saved at a default location. If there is no image at that location
// Then show a default image. The location is dependant on first and last name.
import '../helpers/ImageHelper.dart';

class Person {

  // Defines Person
  final String firstName;
  final String lastName;
  bool isVg;
  bool isLogee;
  bool isHuidigeBewoner;
  String vGName;

  // Drinking Statistics
  int BeersHV = 0;
  int BeersTotal = 0;


  // Throwing Statistics
  int MissedHV = 0;
  int MissedTotal = 0;

  int HitHV = 0;
  int HitTotal = 0;

  // Cleaning Statistics
  int CleaningBeerHV = 0;
  int CleaningBeerTotal = 0;

  // Records
  int BeersTotalRecord = 0; // Biggest amount of beers during a single HV period
  int HitTotalRecord = 0; // Most amount of hits during a single HV period
  double HitRatioRecord = 0; // Best ratio during a single HV period
                             // Current ratio is calculated using HitHV and MissedHV

  Person({
    required this.firstName,
    required this.lastName,
    required this.isVg,
    required this.isHuidigeBewoner,
    required this.isLogee,
    required this.vGName,
    this.BeersHV = 0,
    this.BeersTotal = 0,
    this.MissedHV = 0,
    this.MissedTotal = 0,
    this.HitHV = 0,
    this.HitTotal = 0,
    this.CleaningBeerHV = 0,
    this.CleaningBeerTotal = 0,
    this.BeersTotalRecord = 0,
    this.HitRatioRecord = 0,
    this.HitTotalRecord = 0,
    //this.PhotoBase64, // DEPRECATED PROBABLY
    //this.imagePath
  });


  factory Person.fromJson(Map<dynamic, dynamic> data) => Person(
    firstName: data["firstName"],
    lastName: data["lastName"],
    isVg: data["isVg"],
    isLogee: data["isLogee"],
    isHuidigeBewoner: data["isHuidigeBewoner"],
    vGName: data["vGName"],
    BeersHV: data["BeersHV"],
    BeersTotal: data["BeersTotal"],
    MissedHV: data["MissedHV"],
    MissedTotal: data["MissedTotal"],
    HitHV: data["HitHV"],
    HitTotal: data["HitTotal"],
    CleaningBeerHV: data["CleaningBeerHV"],
    CleaningBeerTotal: data["CleaningBeerTotal"],
    HitTotalRecord: data["HitTotalRecord"],
    HitRatioRecord: data["HitRatioRecord"],
    BeersTotalRecord: data["BeersTotalRecord"],
    //PhotoBase64: data["PhotoBase64"],
    //imagePath: data["imagePath"] == "" ? null : data["imagePath"],
  );


  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "isVg": isVg,
    "isLogee": isLogee,
    "isHuidigeBewoner": isHuidigeBewoner,
    "vGName": vGName,
    "BeersHV": BeersHV,
    "BeersTotal": BeersTotal,
    "MissedHV": MissedHV,
    "MissedTotal": MissedTotal,
    "HitHV": HitHV,
    "HitTotal": HitTotal,
    "CleaningBeerHV": CleaningBeerHV,
    "CleaningBeerTotal": CleaningBeerTotal,
    "BeersTotalRecord": BeersTotalRecord,
    "HitTotalRecord": HitTotalRecord,
    "HitRatioRecord": HitRatioRecord,
    //"PhotoBase64": PhotoBase64 ?? "",
    //"imagePath": imagePath ?? "",
  };

  String correctName(){
    if(isVg){
      return vGName;
    }
    if(isLogee) {
      return 'Logee $firstName';
    }
    return '$firstName $lastName';
  }

  String passportName() {
    return '$firstName $lastName';
  }

  String imagePath() {
    return ImageHelper.imagePath(firstName, lastName);
  }

}

