import 'package:user_layer/user_layer.dart';

abstract class UserLayer {
  Stream<List<Setting>> getSettings();

  Future<void> setSetting({required String key, required bool value});
}
