import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_data.dart';
import 'package:dio/dio.dart';

/*
* Framework for Data Service to be implemented in Sprint 3
* Sends coordinates to API, Receives data from API
*/

class LocationDataService {
  final dio = Dio();

  Future<GeographicTypes> getGeoId(double longitude, double latitude) async {
    final params = {'longitude': longitude, 'latitude': latitude};

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await dio.get('http://localhost:8000/geoid?$queryParams');
    print(response.data);
    final result = GeographicTypes.fromJson(response.data);
    return result;
  }

  Future<Sections> getSections(String group) async {
    final params = {'group': group.toString()};
    print(group);

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response =
        await dio.get('http://localhost:8000/location/sections?$queryParams');

    return Sections()..currentSections = List<String>.from(response.data);
  }

  Future<CensusData> getCensusData(
      String stateCode, String county, String tract, String section) async {
    final params = {
      'state': stateCode,
      'county': county,
      'tract': tract,
      'section': section
    };

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response =
        await dio.get('http://localhost:8000/location/data?$queryParams');

    return CensusData()..currentCensusData = List<String>.from(response.data);
  }
}

final locationDataServiceProvider = Provider((ref) {
  return LocationDataService();
});
