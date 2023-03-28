import 'package:capstone/authentication/screens/login.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';

import 'authentication/state/auth_provider.dart';
import 'configuration/state/config_settings.dart';
import 'firebase_options.dart';

/*
* Google sign in registration for web and desktop
*/
Future _registerDesktopPlugin(ConfigSettings config) async {
  if (!config.isDesktop) {
    return;
  }

  await GoogleSignInDart.register(
    clientId: config.oauthDesktopClientId,
  );
}

/*
*  Main function registers login packages and starts application
*/
void main({List<Override>? testOverrides}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final useFirebase =
      !kIsWeb && defaultTargetPlatform != TargetPlatform.windows;
  if (useFirebase) {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final container = ProviderContainer(overrides: testOverrides ?? []);
  final userContext = container.read(authProvider.notifier);
  final config = container.read(configSettingsProvider);

  // Initialize configurations
  await Future.wait([
    userContext.initialize(),
    config.initialize(),
  ]);

  await _registerDesktopPlugin(config);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DataMapsApp(),
    ),
  );
}

/*
* Initial application creation
*/
class DataMapsApp extends ConsumerWidget {
  const DataMapsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Run the Login Screen as the default homepage
    return const MaterialApp(title: 'Data Maps', home: LoginScreen());
  }
}
