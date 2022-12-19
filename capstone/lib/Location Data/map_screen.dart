import 'package:capstone/Location%20Data/data_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

/*
* Map Screen
* Contains Map and A list of imported Data Containers 
*/
class MapScreen extends StatefulWidget {
  static const String route = '/tap';

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
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
            height: 700,
            child: FlutterMap(
              options: MapOptions(
                  center: LatLng(45.5231, -122.6765),
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
          const DataContainer() //Imported list of data containers
        ],
      ),
    );
  }

  // Set marker on user click/tap
  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      marker = latlng;
    });
  }
}
