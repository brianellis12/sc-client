import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_tree_star/team/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserContext {
  bool get loggedIn => user != null && token.isNotEmpty;
  User? user;
  String token = '';
}

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

  Future logIn(User user, String token) async {
    state = UserContext()
      ..token = token
      ..user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', convert.json.encode(user.toJson()));
  }

  Future logOut() async {
    state = UserContext();
    await _clearPrefs();
  }
}

final authProvider = StateNotifierProvider<UserContextNotifier, UserContext>(
  (ref) => UserContextNotifier(),
);
