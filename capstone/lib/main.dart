import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Location Data/screens/map_screen.dart';

/*
* Run the application
*/
void main() {
  runApp(const ProviderScope(child: DataMapsApp()));
}

class DataMapsApp extends ConsumerWidget {
  const DataMapsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Run the Map Screen as the default homepage
    return const MaterialApp(title: 'Data Maps', home: MapScreen());
  }
}
