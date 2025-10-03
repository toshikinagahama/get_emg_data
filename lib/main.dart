import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'get_emg_data_app.dart';

/// Entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WakelockPlus.enable();
  runApp(ProviderScope(child: GetBreathDataApp()));
}
