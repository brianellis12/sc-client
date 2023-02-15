import 'package:capstone/Location%20Data/models/geographic_types.dart';
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

    final result = GeographicTypes.fromJson(response.data);
    return result;
  }
}

final locationDataServiceProvider = Provider((ref) {
  return LocationDataService();
});
