import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/services.dart';
import 'get_emg_data_app.dart';
import 'package:wakelock/wakelock.dart';

/// Entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Wakelock.enable();
  runApp(ProviderScope(child: GetBreathDataApp()));
}
