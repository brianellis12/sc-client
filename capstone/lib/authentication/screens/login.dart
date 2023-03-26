import 'package:beamer/beamer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heart_tree_star/authentication/models/authenticate_response.dart';
import 'package:heart_tree_star/authentication/services/authentication_service.dart';
import 'package:heart_tree_star/authentication/state/auth_provider.dart';
import 'package:heart_tree_star/devices/services/devices_service.dart';
import 'package:heart_tree_star/devices/state/firebase_message_provider.dart';
import 'package:heart_tree_star/shared/widgets/hts_all_icon.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool loading = false;
  bool retryWithName = false;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    lastNameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  _registerDeviceNotifications() async {
    final excludedPlatforms = [TargetPlatform.windows, TargetPlatform.linux];

    if (excludedPlatforms.contains(defaultTargetPlatform) || kIsWeb) {
      return;
    }

    final messaging = await ref.read(firebaseMessageProvider.future);
    final settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    final deviceService = ref.read(deviceServiceProfiler);
    await deviceService.registerDevice();
  }

  void authenticate() async {
    setState(() {
      loading = true;
    });

    final authService = ref.read(authServiceProvider);
    final authContext = ref.read(authProvider.notifier);

    try {
      AuthenticateResponse auth;

      if (!retryWithName) {
        auth = await authService.login();
      } else {
        auth = await authService.login(
            firstNameController.text, lastNameController.text);
      }

      if (auth.incompleteToken) {
        retryWithName = true;
        return;
      }
      retryWithName = false;

      authContext.logIn(auth.user!, auth.accessToken!);
      await _registerDeviceNotifications();
      if (!mounted) {
        return;
      }

      context.beamToReplacementNamed('/dashboard', stacked: false);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to Login $err'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget branding() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HTSAllIcon(color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Heart-Tree-Star',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'By Fresh',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white),
            ),
            const FaIcon(FontAwesomeIcons.leaf, color: Colors.white)
          ],
        ),
      ],
    );
  }

  Widget loginButton(bool enabled) {
    return ElevatedButton(
      key: const Key('login-authenticate-fab'),
      onPressed: enabled ? authenticate : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return null;
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const FaIcon(FontAwesomeIcons.google),
          const SizedBox(width: 10),
          const Text('Sign In With Google')
        ],
      ),
    );
  }

  Widget nameFields() {
    return SizedBox(
      width: 225,
      child: Column(
        children: [
          const Text(
            'Additional information required.\nPlease try again.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: TextField(
              key: const Key('first-name-field'),
              controller: firstNameController,
              decoration: textDecoration('Enter first name'),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: TextField(
              key: const Key('last-name-field'),
              controller: lastNameController,
              decoration: textDecoration('Enter last name'),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  InputDecoration textDecoration(String text) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      hintText: text,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.only(top: 20, left: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameMissing =
        firstNameController.text.isEmpty || lastNameController.text.isEmpty;
    final loginEnabled = !loading && !(retryWithName && nameMissing);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/hts-login.jpg'),
              fit: BoxFit.cover),
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              flex: 1,
              child: branding(),
            ),
            const Spacer(),
            Column(children: [
              if (retryWithName) nameFields(),
              loginButton(loginEnabled),
            ]),
            const Spacer(flex: 1)
          ],
        ),
      ),
    );
  }
}
