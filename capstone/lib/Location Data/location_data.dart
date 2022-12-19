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
