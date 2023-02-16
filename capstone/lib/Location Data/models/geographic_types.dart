import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
part 'geographic_types.g.dart';

/*
* Object for the geographic information needed to retrieve the census data from the api
*/
@JsonSerializable()
class GeographicTypes {
  @JsonKey(name: 'state')
  String? stateCode;
  String? county;
  String? tract;

  GeographicTypes({
    this.stateCode,
    this.county,
    this.tract,
  });

  GeographicTypes copyWith({String? stateCode, String? county, String? tract}) {
    return GeographicTypes()
      ..stateCode = stateCode ?? this.stateCode
      ..county = county ?? this.county
      ..tract = tract ?? this.tract;
  }

  factory GeographicTypes.fromJson(Map<String, dynamic> data) =>
      _$GeographicTypesFromJson(data);

  Map<String, dynamic> toJson() => _$GeographicTypesToJson(this);
}

/*
* Holds the user's state of the geographic types
*/
class GeographicTypesNotifier extends StateNotifier<GeographicTypes> {
  GeographicTypesNotifier(GeographicTypes initialState) : super(initialState);

  void specifyStateCode(String? stateCode) {
    state = state.copyWith(stateCode: stateCode);
  }

  void clearStateCode() {
    state = state.copyWith()..stateCode = null;
  }

  void specifyCounty(String? county) {
    state = state.copyWith(county: county);
  }

  void clearCounty() {
    state = state.copyWith()..county = null;
  }

  void specifyTract(String? tract) {
    state = state.copyWith(tract: tract);
  }

  void clearTract() {
    state = state.copyWith()..tract = null;
  }

  void reset() {
    state = GeographicTypes();
  }
}

final geographicTypesProvider =
    StateNotifierProvider<GeographicTypesNotifier, GeographicTypes>((ref) {
  final initialState = GeographicTypes();
  return GeographicTypesNotifier(initialState);
});
