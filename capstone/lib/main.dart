import 'package:capstone/authentication/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Location Data/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';

/*
* Run the application
*/
import 'firebase_options.dart';

Future _registerDesktopPlugin(ConfigSettings config) async {
  if (!config.isDesktop) {
    return;
  }

  await GoogleSignInDart.register(
    clientId: config.oauthDesktopClientId,
  );
}

void main({List<Override>? testOverrides}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final useFirebase =
      !kIsWeb && defaultTargetPlatform != TargetPlatform.windows;
  if (useFirebase) {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final container = ProviderContainer(overrides: testOverrides ?? []);
  // eager load some proivders
  final userContext = container.read(authProvider.notifier);
  final config = container.read(configSettingsProvider);

  await Future.wait([
    userContext.initialize(),
    config.initialize(),
  ]);

  // now that config has been initialized...
  await _registerDesktopPlugin(config);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DataMapsApp(),
    ),
  );
}
class DataMapsApp extends ConsumerWidget {
  const DataMapsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Run the Map Screen as the default homepage
    return const MaterialApp(title: 'Data Maps', home: LoginScreen());
  }
}
