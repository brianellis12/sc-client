import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_tree_star/authentication/models/authenticate_request.dart';
import 'package:heart_tree_star/authentication/models/authenticate_response.dart';
import 'package:heart_tree_star/configuration/state/api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heart_tree_star/configuration/state/config_settings.dart';

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

  // client id is detemined by package name + sha thumbprint for android
  // or plist value for iOS, so is not needed here.
  return GoogleSignIn(
    scopes: ['email', 'openid'],
  );
}

final authServiceProvider = Provider((ref) {
  final api = ref.watch(apiClientProvider);
  final config = ref.watch(configSettingsProvider);

  final googleSignIn = _configureGoogleSignIn(config);
  return AuthenticationService(googleSignIn: googleSignIn, api: api);
});
