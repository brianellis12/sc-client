import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone/authentication/models/authenticate_request.dart';
import 'package:capstone/authentication/models/authenticate_response.dart';
import 'package:capstone/configuration/state/api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:capstone/configuration/state/config_settings.dart';

/*
* Handles user login based on targeted platform
*/
class AuthenticationService {
  late Dio api;
  late GoogleSignIn googleSignIn;
  AuthenticationService({required this.api, required this.googleSignIn});

  Future<String?> _authorizeWithGoogle() async {
    await googleSignIn.signOut();
    final result = await googleSignIn.signIn();
    final auth = await result?.authentication;
    return auth?.idToken;
  }

  /*
  * Authenticates user in the api
  */
  Future<AuthenticateResponse> login(
      [String? firstName, String? lastName]) async {
    final idToken = await _authorizeWithGoogle();

    if (idToken == null) {
      throw 'Invalid login';
    }
    final authRequest = AuthenticateRequest()
      ..token = idToken
      ..firstName = firstName
      ..lastName = lastName;

    final dioResponse =
        await api.post('/auth/authenticate', data: authRequest.toJson());
    final response = AuthenticateResponse.fromJson(dioResponse.data);
    return response;
  }
}

/*
* Configure google sign in based on targeted platform
*/
GoogleSignIn _configureGoogleSignIn(ConfigSettings config) {
  const scopes = ['email', 'openid'];
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
