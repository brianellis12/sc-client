import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_data.dart';
import 'package:dio/dio.dart';

/*
* Location Data Service
* Sends and Receives data from the Rest API
*/
class associated {
  final dio = Dio();

  /*
  * Get the geographic data from the inputted coordinates
  */
  Future<GeographicTypes> getGeoId(double longitude, double latitude) async {
    final params = {'longitude': longitude, 'latitude': latitude};

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await dio.get('http://localhost:8000/geoid?$queryParams');
    print(response.data);
    final result = GeographicTypes.fromJson(response.data);
    return result;
  }

  /*
  * Get the sections associated with the inputted group in the database
  */
  Future<Sections> getSections(String group) async {
    final params = {'group': group.toString()};
    print(group);

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response =
        await dio.get('http://localhost:8000/location/sections?$queryParams');

    return Sections()..currentSections = List<String>.from(response.data);
  }

  /*
  * Get the census data from the Census Bureau API for the inputted section and location
  */
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

/*
* Provider for accessing the Location Data Service
*/
final locationDataServiceProvider = Provider((ref) {
  return associated();
});
