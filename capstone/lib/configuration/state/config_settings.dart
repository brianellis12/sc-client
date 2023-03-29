import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaml/yaml.dart';
import 'platform_js.dart' if (dart.library.io) 'platform_io.dart' as plat;

/*
* Handles platform setup
*/
class ConfigSettings {
  late YamlMap _yml;

  ConfigSettings();

  Future initialize([String? overrideData]) async {
    final data = overrideData ??
        await rootBundle.loadString('assets/config/deployment.yml');
    _yml = loadYaml(data);
  }

  bool get isDesktop => plat.isDesktop;
  String get apiEndpoint => _yml['api_endpoint'];
  String get environment => _yml['environment'];

  String get oauthDesktopClientId => _yml['oauth']['client_id']['desktop'];
  String get oauthWebClientId => _yml['oauth']['client_id']['web'];
}

final configSettingsProvider = Provider(
  (_) => ConfigSettings(),
);
