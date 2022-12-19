import 'package:flutter/material.dart';
import 'Location Data/map_screen.dart';

void main() => runApp(const DataMapsApp());

class DataMapsApp extends StatelessWidget {
  const DataMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Data Maps', home: MapScreen());
  }
}
