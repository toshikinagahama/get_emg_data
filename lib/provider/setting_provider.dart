import 'package:flutter/foundation.dart';
import 'package:get_emg_data/foundation/database_const.dart';
import 'package:get_emg_data/provider/database_provider.dart';
import "package:get_emg_data/util/logger.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/data/model/setting.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/foundation/setting.dart';

class SettingNotifier extends ChangeNotifier {
  SettingNotifier(this.ref) : super();
  final Ref ref;
  Setting setting = Setting();

  void flush() async {
    //
    await getBestBreathTotal();
    await getCntImpStable();
    notifyListeners();
  }

  void update(int cntImpStable, double bestBreathTotal) async {
    await ref.read(databaseProvider).update(
        "m_system_param",
        {DatabaseConst.system.value: cntImpStable},
        "${DatabaseConst.system.name}='${DatabaseConst.system.cntImpStable}'");
    await ref.read(databaseProvider).update(
        "m_system_param",
        {DatabaseConst.system.value: bestBreathTotal},
        "${DatabaseConst.system.name}='${DatabaseConst.system.bestBreathTotal}'");
    notifyListeners();
  }

  Future<void> getBestBreathTotal() async {
    var data = await ref.read(databaseProvider).select("m_system_param",
        columns: ["param_name", "param_value"],
        where:
            "${DatabaseConst.system.name}='${DatabaseConst.system.bestBreathTotal}'");
    setting.bestBreathTotal = double.parse(data[0]["param_value"].toString());
    return Future.value();
  }

  Future<void> getCntImpStable() async {
    var data = await ref.read(databaseProvider).select("m_system_param",
        columns: ["param_name", "param_value"],
        where:
            "${DatabaseConst.system.name}='${DatabaseConst.system.cntImpStable}'");
    setting.cntImpStable = int.parse(data[0]["param_value"].toString());
    return Future.value();
  }
}
