import 'dart:async';

import 'package:app/core/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kApiToken = 'api_token';
const kUsername = 'username';
const kUserGuid = 'userGuid';

abstract class IPreferenceService {
  Future<void> preload();

  String? getString(String key);

  Stream<String?> onPreferenceChanged(String key);

  Future<void> set(String key, dynamic value);

  bool getBoolean(String key, {bool defaultValue = false});

  int getInt(String key, {int defaultValue = 0});

  Future<void> clear();
}

class PrefUpdate {
  PrefUpdate(this.key, this.value);
  final String key;
  final String? value;
}

class LocalPrefsService implements IPreferenceService {
  late SharedPreferences localPrefs;

  final StreamController<PrefUpdate> _controller = StreamController.broadcast();

  @override
  Future<void> preload() async {
    localPrefs = await SharedPreferences.getInstance();
  }

  @override
  String? getString(String key) {
    final String? value = localPrefs.getString(key);

    _controller.add(PrefUpdate(key, value));

    return value;
  }

  @override
  Stream<String?> onPreferenceChanged(String key) {
    return _controller.stream.where((event) => event.key == key).map((event) => event.value);
  }

  @override
  Future<void> set(String key, dynamic value) async {
    if (value == null) {
      await localPrefs.remove(key);
    } else {
      await localPrefs.setString(key, value.toString());
    }
  }

  @override
  bool getBoolean(String key, {bool defaultValue = false}) {
    final value = getString(key);
    if (value == null) return defaultValue;
    return value.isTrue;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    final value = getString(key);
    if (value == null) return defaultValue;
    return int.parse(value);
  }

  @override
  Future<void> clear() async {
    await localPrefs.clear();
  }
}
