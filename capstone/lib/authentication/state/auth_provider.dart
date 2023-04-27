import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configuration/logging/logging_service.dart';
import '../models/user.dart';

// Create a logger instance
final loggingService = LoggingService();

/*
* User context model
*/
class UserContext {
  bool get loggedIn => user != null && token.isNotEmpty;
  User? user;
  String token = '';
  String googleToken = '';
}

/*
* User and authentication state 
*/
class UserContextNotifier extends StateNotifier<UserContext> {
  UserContextNotifier({User? defaultUser})
      : super(UserContext()..user = defaultUser);

  Future _clearPrefs() async {
    // Log entering the function
    loggingService.logToRedis('Entering _clearPrefs');

    final prefs = await SharedPreferences.getInstance();

    await Future.wait([prefs.remove('token'), prefs.remove('user')]);

    // Log exiting the function
    loggingService.logToRedis('Exiting _clearPrefs');
  }

  /*
  * Initializes user for IOS and android platforms
  */
  Future initialize() async {
    // Log entering the function
    loggingService.logToRedis('Entering initialize');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      // Log the case when token or userJson is null
      loggingService.logToRedis('Token or userJson is null');
      return;
    }
    try {
      final user = convert.json.decode(userJson);
      state = UserContext()
        ..token = token
        ..user = User.fromJson(user);

      // Log the state after initialization
      loggingService.logToRedis('State after initialization: $state');
    } catch (err) {
      // Log the error and clear prefs
      loggingService.logToRedis('Error initializing user: $err');
      await _clearPrefs();
    }

    // Log exiting the function
    loggingService.logToRedis('Exiting initialize');
  }

  /*
  * Sets user state
  */
  Future logIn(User user, String token, String googleToken) async {
    // Log entering the function
    loggingService.logToRedis(
        'Entering logIn with user: $user, token: $token and googleToken: $googleToken');

    state = UserContext()
      ..token = token
      ..googleToken = googleToken
      ..user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('accessToken', googleToken);
    await prefs.setString('user', convert.json.encode(user.toJson()));

    // Log the state after logging in
    loggingService.logToRedis('State after logging in: $state');

    // Log exiting the function
    loggingService.logToRedis('Exiting logIn');
  }

  /*
  * Removes current user state
  */
  Future logOut() async {
    // Log entering the function
    loggingService.logToRedis('Entering logOut');

    state = UserContext();

    // Log the state after logging out
    loggingService.logToRedis('State after logging out: $state');

    await _clearPrefs();

    // Log exiting the function
    loggingService.logToRedis('Exiting logOut');
  }
}

/*
* Provider for accessing the user/authentication context
*/
final authProvider = StateNotifierProvider<UserContextNotifier, UserContext>(
  (ref) => UserContextNotifier(),
);
