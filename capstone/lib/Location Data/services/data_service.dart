import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:capstone/authentication/state/auth_provider.dart';
import 'package:capstone/configuration/state/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configuration/logging/logging_service.dart';
import '../models/location_data.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

final loggingService = LoggingService();

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
    // Log entering the function
    loggingService.logToRedis(
        'Entering getGeoId with longitude: $longitude and latitude: $latitude');

    final params = {'longitude': longitude, 'latitude': latitude};

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await api.get('/geoid?$queryParams');

    // Log the response status code
    loggingService.logToRedis('Response status code: ${response.statusCode}');

    // Check for errors and log them
    if (response.statusCode != 200) {
      loggingService
          .logToRedis('Error getting geo id: ${response.statusMessage}');
      throw Exception('Failed to get geo id');
    }

    final result = GeographicTypes.fromJson(response.data);

    // Log exiting the function
    loggingService.logToRedis('Exiting getGeoId with result: $result');

    return result;
  }

  /*
  * Get the sections associated with the inputted group in the database
  */
  Future<Sections> getSections(String group) async {
    // Log entering the function
    loggingService.logToRedis('Entering getSections with group: $group');

    final params = {'group': group.toString()};

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await api.get('/location/sections?$queryParams');

    // Log the response status code
    loggingService.logToRedis('Response status code: ${response.statusCode}');

    // Check for errors and log them
    if (response.statusCode != 200) {
      loggingService
          .logToRedis('Error getting sections: ${response.statusMessage}');
      throw Exception('Failed to get sections');
    }

    final result = Sections(currentSections: [])
      ..currentSections = List<String>.from(response.data);

    // Log exiting the function
    loggingService.logToRedis('Exiting getSections with result: $result');

    return result;
  }

  /*
  * Get the census data from the Census Bureau API for the inputted section and location
  */
  Future<CensusData> getCensusData(
      String stateCode, String county, String tract, String section) async {
    // Log entering the function
    loggingService.logToRedis(
        'Entering getCensusData with stateCode: $stateCode, county: $county, tract: $tract, section: $section');
    loggingService.logToRedis('Error getting census data');
    final params = {
      'state': stateCode,
      'county': county,
      'tract': tract,
      'section': section
    };

    final queryParams =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    final response = await api.get('/location/data?$queryParams');

    // Log the response status code
    loggingService.logToRedis('Response status code: ${response.statusCode}');

    // Check for errors and log them
    if (response.statusCode != 200) {
      loggingService
          .logToRedis('Error getting census data: ${response.statusMessage}');
      throw Exception('Failed to get census data');
    }

    final result = CensusData()
      ..currentCensusData = List<String>.from(response.data);

    // Log exiting the function
    loggingService.logToRedis('Exiting getCensusData with result: $result');

    return result;
  }
}

/*
* Provider for accessing the Location Data Service
*/
final locationDataServiceProvider = Provider((ref) {
  final api = ref.watch(apiClientProvider);
  return DataService(api);
});
