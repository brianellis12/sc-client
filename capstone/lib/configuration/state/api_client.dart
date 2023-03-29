import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone/authentication/state/auth_provider.dart';
import 'package:capstone/configuration/state/config_settings.dart';
import 'package:dio/dio.dart';

/*
* Provides the state for the api for standardization of endpoint querying
*/
final apiClientProvider = Provider((ref) {
  final config = ref.watch(configSettingsProvider);
  final userContext = ref.watch(authProvider);

  final dio = Dio();
  dio.options.baseUrl = config.apiEndpoint;
  dio.options.sendTimeout =
      const Duration(milliseconds: 1200); // 12 second timeout
  if (userContext.token.isNotEmpty) {
    dio.options.headers['Authorization'] = 'Bearer ${userContext.token}';
  }
  return dio;
});
