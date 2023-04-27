import 'package:capstone/Location Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/widgets/group_bar.dart';
import 'package:capstone/authentication/state/auth_provider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:capstone/Location Data/services/data_service.dart';

import '../../authentication/models/user.dart';
import '../../authentication/screens/login.dart';
import '../models/location_data.dart';
import '../widgets/zoombuttons.dart';

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
  LatLng marker = LatLng(0, 0);
  late GeographicTypes types = GeographicTypes();

  static final List<String> enums = EnumToString.toList(GroupNames.values)
      .map((e) => e.replaceAll('_', ' '))
      .toList();

  @override
  Widget build(BuildContext context) {
    final point = Marker(
        width: 40,
        height: 40,
        point: marker,
        builder: (ctx) =>
            const Icon(IconData(0xf193, fontFamily: 'MaterialIcons')));
    try {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: navbar(context),
        body: ListView(
          padding: const EdgeInsets.all(0.1),
          children: [
            SizedBox(
              // Map View
              height: 600,
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(44.967243, -103.771556),
                    zoom: 5,
                    onTap: _handleTap,
                    enableScrollWheel: false),
                nonRotatedChildren: const [
                  FlutterMapZoomButtons(
                    minZoom: 4,
                    maxZoom: 19,
                    mini: true,
                    padding: 10,
                    alignment: Alignment.bottomRight,
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: [point],
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                child: Wrap(children: [
                  Column(children: [
                    Text("Latitude: ${marker.latitude} ",
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                    Text("Longitude: ${marker.longitude}",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                  ]),
                  Align(
                      alignment: Alignment.topRight,
                      child: Wrap(children: [
                        Text("State: ${types.stateCode ?? ""} ",
                            style: const TextStyle(
                                fontSize: 50, color: Colors.black)),
                        Text("County: ${types.county ?? ""} ",
                            style: const TextStyle(
                                fontSize: 50, color: Colors.black)),
                        Text("Tract: ${types.tract ?? ""} ",
                            style: const TextStyle(
                                fontSize: 50, color: Colors.black))
                      ])),
                ])),
            const SizedBox(
                height: 40000,
                child:
                    GroupBar()) //Imported group bar containing data containers
          ],
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Map and location field Failed to load $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return const LoginScreen();
    }
  }

  /*
  * Navbar with Account Dropdown
  */
  PreferredSizeWidget navbar(context) {
    User? user = ref.watch(authProvider).user;
    return AppBar(
      title: const Text('Data Maps'),
      //backgroundColor: Colors.transparent,
      backgroundColor: Color(0x44000000),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: () {
            infoModal(context);
          },
          child: const Text("Data Definitions",
              style: TextStyle(color: Colors.white)),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.account_box),
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

  infoModal(context) {
    try {
      int i = 0;
      showGeneralDialog(
          context: context,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (bc, ania, anis) {
            return ListView(children: [
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...enums.map((String name) {
                          return Row(mainAxisSize: MainAxisSize.min, children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  DefaultTextStyle(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                      child: Text(name, softWrap: true)),
                                  DefaultTextStyle(
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                      child: Text(
                                        dataDescriptions[i++],
                                        softWrap: true,
                                      )),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ]))
                          ]);
                        }).toList(),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text("Close")),
                      ]),
                ),
              ),
            ]);
          });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Descriptions Failed to load $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // Set marker on user click/tap and send coordinates to the Rest API
  Future<void> _handleTap(TapPosition tapPosition, LatLng latlng) async {
    setState(() {
      marker = latlng;
    });

    final locationDataService = ref.watch(locationDataServiceProvider);

    types =
        await locationDataService.getGeoId(latlng.longitude, latlng.latitude);
    ref
        .read(geographicTypesProvider.notifier)
        .specifyStateCode(types.stateCode);
    ref.read(geographicTypesProvider.notifier).specifyCounty(types.county);
    ref.read(geographicTypesProvider.notifier).specifyTract(types.tract);
  }
}
