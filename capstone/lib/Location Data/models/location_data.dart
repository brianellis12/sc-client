// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'location_data.g.dart';

/*
* Location data model
*/
@JsonSerializable()
class LocationData {
  String headerValue;
  List<String>? values;
  bool isExpanded;

  LocationData({
    this.values,
    required this.headerValue,
    this.isExpanded = false,
  });

  // Methods for converting to and from Json data
  factory LocationData.fromJson(Map<String, dynamic> data) =>
      _$LocationDataFromJson(data);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}

enum GroupNames {
  @JsonValue('B01')
  Sex_and_Age,
  @JsonValue('B02')
  Race,
  @JsonValue('B03')
  Latino_Ancestry,
  @JsonValue('B04')
  Non_Latino_Ancestry,
  @JsonValue('B05')
  Non_US_Place_of_Birth,
  @JsonValue('B06')
  Place_of_Birth_within_US,
  @JsonValue('B07')
  Geographic_Mobility,
  @JsonValue('B08')
  Transportation,
  @JsonValue('B09')
  Children_and_Seniors,
  @JsonValue('B10')
  Households_Grandparents_and_Grandchildren,
  @JsonValue('B11')
  Households,
  @JsonValue('B12')
  Marital_Status,
  @JsonValue('B13')
  Births,
  @JsonValue('B14')
  Education_Enrollment,
  @JsonValue('B15')
  Education_Attainment,
  @JsonValue('B16')
  Languages,
  @JsonValue('B17')
  Income,
  @JsonValue('B18')
  Disabilities,
  @JsonValue('B19')
  Income_By_Household,
  @JsonValue('B20')
  Income_By_Sex,
  @JsonValue('B21')
  Veteran_Status,
  @JsonValue('B22')
  Food_Stamp_Utilization,
  @JsonValue('B23')
  Employment_Status,
  @JsonValue('B24')
  Occupations,
  @JsonValue('B25')
  Housing_Status,
  @JsonValue('B26')
  Housing_Status_in_Group_Quarters,
  @JsonValue('B27')
  Health_Insurance_Status,
  @JsonValue('B28')
  Household_Technology,
  @JsonValue('B29')
  Basic_Demographics_by_Voting_Age
}
