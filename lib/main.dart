import 'package:flutter/material.dart';
import 'package:data_repository/data_repository.dart';
import 'package:local_data_layer/local_data_layer.dart';
import 'package:user_layer/user_layer.dart';
import 'package:streak_meister/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataLayer = await LocalDataLayer.create(null);
  // TODO: remove / move to bootstrap instead
  final userLayer = LocalUserLayer();
  final repository = DataRepository(dataLayer: dataLayer, userLayer: userLayer);

  runApp(App(repository: repository));
}

class LocalUserLayer extends UserLayer {
}
