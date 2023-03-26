import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Location Data/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication/login.dart';
import 'firebase_options.dart';

/*
* Run the application
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: DataMapsApp()));
}

class DataMapsApp extends ConsumerWidget {
  const DataMapsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Run the Map Screen as the default homepage
    return const MaterialApp(title: 'Data Maps', home: SignInScreen());
  }
}
