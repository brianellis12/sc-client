import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone/authentication/models/authenticate_request.dart';
import 'package:capstone/authentication/models/authenticate_response.dart';
import 'package:capstone/configuration/state/api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:capstone/configuration/state/config_settings.dart';

import '../../configuration/logging/logging_service.dart';

// Create a logger instance
final loggingService = LoggingService();

/*
* Handles user login based on targeted platform
*/
class AuthenticationService {
  late Dio api;
  late GoogleSignIn googleSignIn;
  AuthenticationService({required this.api, required this.googleSignIn});

  Future<GoogleSignInAuthentication?> _authorizeWithGoogle() async {
    // Log entering the function
    loggingService.logToRedis('Entering _authorizeWithGoogle');

    await googleSignIn.signOut();
    final result = await googleSignIn.signIn();
    final auth = await result?.authentication;

    // Log exiting the function
    loggingService.logToRedis('Exiting _authorizeWithGoogle with auth: $auth');

    return auth;
  }

  /*
  * Authenticate user in the api
  */
  Future<AuthenticateResponse> login(
      [String? firstName, String? lastName]) async {
    // Log entering the function
    loggingService.logToRedis(
        'Entering login with firstName: $firstName and lastName: $lastName');

    final auth = await _authorizeWithGoogle();
    final idToken = auth?.idToken;
    final googleToken = auth?.accessToken ?? '';

    if (idToken == null) {
      // Log the error
      loggingService.logToRedis('Invalid login');
      throw 'Invalid login';
    }
    final authRequest = AuthenticateRequest()
      ..token = idToken
      ..firstName = firstName
      ..lastName = lastName;

    final dioResponse =
        await api.post('/auth/authenticate', data: authRequest.toJson());

    // Log the response status code
    loggingService
        .logToRedis('Response status code: ${dioResponse.statusCode}');

    // Check for errors and log them
    if (dioResponse.statusCode != 200) {
      loggingService.logToRedis(
          'Error authenticating user: ${dioResponse.statusMessage}');
      throw Exception('Failed to authenticate user');
    }

    final response = AuthenticateResponse.fromJson(dioResponse.data);
    response.googleToken = googleToken;

    // Log exiting the function
    loggingService.logToRedis('Exiting login with response: $response');

    return response;
  }
}

/*
* Configure google sign in based on targeted platform
*/
GoogleSignIn _configureGoogleSignIn(ConfigSettings config) {
  const scopes = ['email', 'openid', 'https://mail.google.com/'];
  if (config.isDesktop) {
    return GoogleSignIn(
      clientId: config.oauthDesktopClientId,
      scopes: scopes,
    );
  }

  if (kIsWeb) {
    return GoogleSignIn(
      clientId: config.oauthWebClientId,
      scopes: scopes,
    );
  }

  return GoogleSignIn(
    scopes: ['email', 'openid'],
  );
}

/*
* Provider for accessing the Authentication Service
*/
final authServiceProvider = Provider((ref) {
  final api = ref.watch(apiClientProvider);
  final config = ref.watch(configSettingsProvider);

  final googleSignIn = _configureGoogleSignIn(config);
  return AuthenticationService(googleSignIn: googleSignIn, api: api);
});
