import 'package:json_annotation/json_annotation.dart';
part 'location_data.g.dart';

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

  factory LocationData.fromJson(Map<String, dynamic> data) =>
      _$LocationDataFromJson(data);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
