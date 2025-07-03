import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_layer/user_layer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class KeyNotFoundError extends Error {}

class LocalUserLayer implements UserLayer {
  LocalUserLayer({
    required SharedPreferences sharedPreferences
  })  : _sharedPreferences = sharedPreferences {
    _init();
  }

  void _init() {
    final settingsJson = _getValue(kUserDataCollectionKey);

    if (settingsJson != null) {
      final settings = List<Map<String, dynamic>>.from(
        json.decode(settingsJson) as List,
      )
        .map((jsonMap) => Setting.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();
      
      _settingsStreamController.add(settings);
    } else {
      _settingsStreamController.add(const []);
    }
  }

  final SharedPreferences _sharedPreferences;
  late final _settingsStreamController = BehaviorSubject<List<Setting>>.seeded(
    const []
  );

  @visibleForTesting
  static const kUserDataCollectionKey = '__user_data_collection_key__';

  String? _getValue(String key) => _sharedPreferences.getString(key);
  Future<void> _setValue(String key, String value) => 
    _sharedPreferences.setString(key, value);

  @override
  Stream<List<Setting>> getSettings() => 
    _settingsStreamController.asBroadcastStream();

  @override
  Future<void> setSetting({required String key, required bool value}) async {
    List<Setting> settings = [..._settingsStreamController.value];
    int index = settings.indexWhere((s) => s.key == key);
    if (index != -1) {
      settings[index] = settings[index].copyWith(value: value);
      _settingsStreamController.add(settings);
      return _setValue(kUserDataCollectionKey, json.encode(settings));
    } else {
      // Should never happen - the possible keys for settings are declared on 
      //  init - thus, if we hit this, we need to refactor _init() to add
      //  the new setting to the list of already-defined settings
      throw KeyNotFoundError();
    }
  }
}