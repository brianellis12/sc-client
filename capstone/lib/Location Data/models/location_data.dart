// ignore_for_file: constant_identifier_names
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
* Location data model for use with the content of the Data Containers
*/
class LocationData {
  int id;
  String headerValue;
  List<String> values;
  bool isExpanded;

  LocationData({
    this.id = 0,
    this.values = const [''],
    this.headerValue = '',
    this.isExpanded = false,
  });
}

class LocationDataNotifier extends StateNotifier<LocationData> {
  LocationDataNotifier(LocationData initialState) : super(initialState);

  void reset() {
    state = LocationData();
  }
}

final locationDataProvider =
    StateNotifierProvider<LocationDataNotifier, LocationData>((ref) {
  final initialState = LocationData();
  return LocationDataNotifier(initialState);
});

enum GroupNames {
  Sex_and_Age,
  Race,
  Latino_Ancestry,
  Non_Latino_Ancestry,
  Non_US_Place_of_Birth,
  Place_of_Birth_within_US,
  Geographic_Mobility,
  Transportation,
  Children_and_Seniors,
  Households_Grandparents_and_Grandchildren,
  Households,
  Marital_Status,
  Births,
  Education_Enrollment,
  Education_Attainment,
  Languages,
  Income,
  Disabilities,
  Income_By_Household,
  Income_By_Sex,
  Veteran_Status,
  Food_Stamp_Utilization,
  Employment_Status,
  Occupations,
  Housing_Status,
  Housing_Status_in_Group_Quarters,
  Health_Insurance_Status,
  Household_Technology,
  Basic_Demographics_by_Voting_Age
}

extension GroupNamesExtension on GroupNames {
  String get code {
    switch (this) {
      case GroupNames.Sex_and_Age:
        return 'B01';
      case GroupNames.Race:
        return 'B02';
      case GroupNames.Latino_Ancestry:
        return 'B03';
      case GroupNames.Non_Latino_Ancestry:
        return 'B04';
      case GroupNames.Non_US_Place_of_Birth:
        return 'B05';
      case GroupNames.Place_of_Birth_within_US:
        return 'B06';
      case GroupNames.Geographic_Mobility:
        return 'B07';
      case GroupNames.Transportation:
        return 'B08';
      case GroupNames.Children_and_Seniors:
        return 'B09';
      case GroupNames.Households_Grandparents_and_Grandchildren:
        return 'B10';
      case GroupNames.Households:
        return 'B11';
      case GroupNames.Marital_Status:
        return 'B12';
      case GroupNames.Births:
        return 'B13';
      case GroupNames.Education_Enrollment:
        return 'B14';
      case GroupNames.Education_Attainment:
        return 'B15';
      case GroupNames.Languages:
        return 'B16';
      case GroupNames.Income:
        return 'B17';
      case GroupNames.Disabilities:
        return 'B18';
      case GroupNames.Income_By_Household:
        return 'B19';
      case GroupNames.Income_By_Sex:
        return 'B20';
      case GroupNames.Veteran_Status:
        return 'B21';
      case GroupNames.Food_Stamp_Utilization:
        return 'B22';
      case GroupNames.Employment_Status:
        return 'B23';
      case GroupNames.Occupations:
        return 'B24';
      case GroupNames.Housing_Status:
        return 'B25';
      case GroupNames.Housing_Status_in_Group_Quarters:
        return 'B26';
      case GroupNames.Health_Insurance_Status:
        return 'B27';
      case GroupNames.Household_Technology:
        return 'B28';
      case GroupNames.Basic_Demographics_by_Voting_Age:
        return 'B29';

      default:
        return '';
    }
  }
}
