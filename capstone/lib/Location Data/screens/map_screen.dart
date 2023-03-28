import 'package:capstone/Location Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/widgets/group_bar.dart';
import 'package:capstone/authentication/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:capstone/Location Data/services/data_service.dart';

import '../../authentication/models/user.dart';
import '../../authentication/screens/login.dart';

/*
* Map Screen
* Contains Map and A list of imported Data Containers 
*/
class MapScreen extends ConsumerStatefulWidget {
  static const String route = '/tap';

  const MapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
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
          navbar(),
          SizedBox(
            // Map View
            height: 600,
            child: FlutterMap(
              options: MapOptions(
                  center: LatLng(44.967243, -103.771556),
                  zoom: 5,
                  onTap: _handleTap,
                  enableScrollWheel: false),
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
              height: 40000,
              child: GroupBar()) //Imported group bar containing data containers
        ],
      ),
    );
  }

  // Navbar with Account Dropdown
  Widget navbar() {
    User? user = ref.watch(authProvider).user;
    return AppBar(
      title: const Text('Data Maps'),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.account_circle),
          itemBuilder: (context) => [
            PopupMenuItem(child: Text('${user?.fullName}')),
            PopupMenuItem(child: Text('Email: ${user?.email}')),
            PopupMenuItem(
              child: ElevatedButton(
                child: const Text('Logout'),
                onPressed: () {
                  // Logout and navigate to another screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Set marker on user click/tap and send coordinates to the Rest API
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
