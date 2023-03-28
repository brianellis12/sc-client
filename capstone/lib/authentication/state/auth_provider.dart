import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

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
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([prefs.remove('token'), prefs.remove('user')]);
  }

  Future initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      return;
    }
    try {
      final user = convert.json.decode(userJson);
      state = UserContext()
        ..token = token
        ..user = User.fromJson(user);
    } catch (err) {
      await _clearPrefs();
    }
  }

  Future logIn(User user, String token, String googleToken) async {
    state = UserContext()
      ..token = token
      ..googleToken = googleToken
      ..user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('accessToken', googleToken);
    await prefs.setString('user', convert.json.encode(user.toJson()));
  }

  Future logOut() async {
    state = UserContext();
    await _clearPrefs();
  }
}

/*
* Provider for accessing the user/authentication context
*/
final authProvider = StateNotifierProvider<UserContextNotifier, UserContext>(
  (ref) => UserContextNotifier(),
);
