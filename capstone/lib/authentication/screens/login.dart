import 'package:beamer/beamer.dart';
import 'package:capstone/Location%20Data/screens/map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:capstone/authentication/models/authenticate_response.dart';
import 'package:capstone/authentication/services/authentication_service.dart';
import 'package:capstone/authentication/state/auth_provider.dart';

/*
* Login Screen
*/
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

  /*
  * Authenticate the user's google account
  */
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

      authContext.logIn(auth.user!, auth.accessToken!, auth.googleToken);
      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MapScreen()));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to Login $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  /*
  * Button allowing the user to login
  */
  Widget loginButton(bool enabled) {
    return ElevatedButton(
      key: const Key('login-button'),
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

  /*
  * Input text fields brought up when a user doesn't have a first and last name associated with their google account
  */
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

  /*
  * Styling for name inputs
  */
  InputDecoration textDecoration(String text) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      hintText: text,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.only(top: 20, left: 10),
    );
  }

  /*
  * Build method for the login screen
  */
  @override
  Widget build(BuildContext context) {
    final nameMissing =
        firstNameController.text.isEmpty || lastNameController.text.isEmpty;
    final loginEnabled = !loading && !(retryWithName && nameMissing);

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/earth.jpg'), fit: BoxFit.cover),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Data Maps',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 20),
            if (retryWithName) nameFields(),
            loginButton(loginEnabled),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Or Continue Without Logging In'),
              onPressed: () {
                // Navigate to second route when tapped.
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unable to Load Main Screen $err'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
            )
          ]),
    ));
  }
}
