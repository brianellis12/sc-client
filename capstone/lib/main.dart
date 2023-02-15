import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Location Data/screens/map_screen.dart';

void main() {
  runApp(const ProviderScope(child: DataMapsApp()));
}

class DataMapsApp extends ConsumerWidget {
  const DataMapsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(title: 'Data Maps', home: MapScreen());
  }
}
