// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:pingware/simple_bloc_observer.dart';
import 'package:pingware/pingware.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  ).whenComplete(() async {
    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
    await Hive.initFlutter();
    await Hive.openBox('settings');

    if (Platform.isIOS) DartPingIOS.register();

    HydratedBlocOverrides.runZoned(
      () async {
        runApp(PingWare());
      },
      blocObserver: kDebugMode ? SimpleBlocObserver() : null,
      storage: storage,
    );
  });
}
