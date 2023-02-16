import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
part 'census_data.g.dart';

@JsonSerializable()
class CensusData {
  List<String>? currentCensusData;

  CensusData({this.currentCensusData});

  CensusData copyWith({List<String>? currentCensusData}) {
    return CensusData()
      ..currentCensusData = currentCensusData ?? this.currentCensusData;
  }

  factory CensusData.fromJson(Map<String, dynamic> data) =>
      _$CensusDataFromJson(data);

  Map<String, dynamic> toJson() => _$CensusDataToJson(this);
}

class CensusDataNotifier extends StateNotifier<CensusData> {
  CensusDataNotifier(CensusData initialState) : super(initialState);

  void specifyCurrentCensusData(List<String>? currentCensusData) {
    state = state.copyWith(currentCensusData: currentCensusData);
  }

  void clearCurrentCensusData() {
    state = state.copyWith()..currentCensusData = null;
  }

  void reset() {
    state = CensusData();
  }
}

final censusDataProvider =
    StateNotifierProvider<CensusDataNotifier, CensusData>((ref) {
  final initialState = CensusData();
  return CensusDataNotifier(initialState);
});
