import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:capstone/authentication/state/auth_provider.dart';
import 'package:capstone/configuration/state/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_data.dart';
import 'package:dio/dio.dart';

/*
* Location Data Service
* Sends and Receives data from the Rest API
*/
class DataService {
  final Dio api;
  DataService(this.api);
  /*
  * Get the geographic data from the inputted coordinates
  */
  Future<GeographicTypes> getGeoId(double longitude, double latitude) async {
    final params = {'longitude': longitude, 'latitude': latitude};

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await api.get('/geoid?$queryParams');

    final result = GeographicTypes.fromJson(response.data);
    return result;
  }

  /*
  * Get the sections associated with the inputted group in the database
  */
  Future<Sections> getSections(String group) async {
    final params = {'group': group.toString()};

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await api.get('/location/sections?$queryParams');

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

    final response = await api.get('/location/data?$queryParams');

    return CensusData()..currentCensusData = List<String>.from(response.data);
  }
}

/*
* Provider for accessing the Location Data Service
*/
final locationDataServiceProvider = Provider((ref) {
  final api = ref.watch(apiClientProvider);
  return DataService(api);
});
