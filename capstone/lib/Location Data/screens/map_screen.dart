import 'package:capstone/Location Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:capstone/Location%20Data/widgets/group_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:capstone/Location Data/services/data_service.dart';

/*
* Map Screen
* Contains Map and A list of imported Data Containers 
*/
class MapScreen extends ConsumerStatefulWidget {
  static const String route = '/tap';

  const MapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  LatLng marker = LatLng(10, 10);

  @override
  Widget build(BuildContext context) {
    final point = Marker(
        width: 40,
        height: 40,
        point: marker,
        builder: (ctx) =>
            const Icon(IconData(0xf193, fontFamily: 'MaterialIcons')));

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(
            // Map View
            height: 600,
            child: FlutterMap(
              options: MapOptions(
                  center: LatLng(44.967243, -103.771556),
                  zoom: 5,
                  onTap: _handleTap),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [point],
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 2000,
              child: GroupBar()) //Imported list of data containers
        ],
      ),
    );
  }

  // Set marker on user click/tap
  Future<void> _handleTap(TapPosition tapPosition, LatLng latlng) async {
    setState(() {
      marker = latlng;
    });

    final locationDataService = ref.watch(locationDataServiceProvider);

    final GeographicTypes types =
        await locationDataService.getGeoId(latlng.longitude, latlng.latitude);
    ref
        .read(geographicTypesProvider.notifier)
        .specifyStateCode(types.stateCode);
    ref.read(geographicTypesProvider.notifier).specifyCounty(types.county);
    ref.read(geographicTypesProvider.notifier).specifyTract(types.tract);
  }
}
