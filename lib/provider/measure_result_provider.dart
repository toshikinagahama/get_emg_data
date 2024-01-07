import 'package:flutter/foundation.dart';
import 'package:get_emg_data/foundation/database_const.dart';
import 'package:get_emg_data/foundation/response.dart';
import 'package:get_emg_data/provider/database_provider.dart';
import "package:get_emg_data/util/logger.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/data/model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/foundation/setting.dart';
import 'package:intl/intl.dart';

final measureResultProvider =
    FutureProvider<List<MeasureDataResponse>>((ref) async {
  return [];
  //List<MeasureDataResponse> measureResultList = [];
  //var token = (await ref.read(databaseProvider).select(
  //        DatabaseConst.system.table,
  //        columns: [DatabaseConst.system.name, DatabaseConst.system.value],
  //        where:
  //            "${DatabaseConst.system.name}='${DatabaseConst.system.accessToken}'"))[
  //    0]["param_value"];
  ////measure_idのリストを取得
  //Uri uri = Uri.parse("${Const.backendUrl}/user/me");
  //Map<String, String> headers = {'Authorization': 'Bearer $token'};
  //var res = await http.get(uri, headers: headers);
  //var json_data = json.decode(res.body);

  //logger.d('user_id: ${json_data["user"]["id"]}');
  //var user_id = json_data["user"]["id"] as int;
  //uri = Uri.parse(
  //    "${Const.backendUrl}/measure/get_measure_id_by_user_id/$user_id");
  //res = await http.get(uri, headers: headers);
  //json_data = json.decode(res.body);
  //logger.i(json_data);
  //if (json_data["result"] != null) {
  //  if (json_data["result"] == 0) {
  //    if (json_data["measure_ids"].length > 0) {
  //      var measure_ids = json_data["measure_ids"] as List<dynamic>;
  //      logger.i(measure_ids);
  //      //for (int i = 0; i < measure_ids.length; i++) {
  //      //  uri = Uri.parse("${Setting.backendUrl}/measure/${measure_ids[i]}");
  //      //  res = await http.get(uri, headers: headers);
  //      //  json_data = json.decode(res.body);
  //      //  logger.i(json_data);
  //      //  //var tmpList = json_data["measure_data"] as List<dynamic>;
  //      //  //for (int i = 0; i < tmpList.length; i++) {
  //      //  //  var measureData = MeasureDataResponse.fromJson(tmpList[i]);
  //      //  //  measureDataList.add(measureData);

  //      //  //  //logger.i(measureData.value);
  //      //  //}
  //      //  //tmpList = json_data["measure_timeseries"] as List<dynamic>;
  //      //  //for (int i = 0; i < tmpList.length; i++) {
  //      //  //  var measureTS = MeasureTimeseriesServerResponse.fromJson(tmpList[i]);
  //      //  //  //logger.i(measureTS.value);
  //      //  //}
  //      //}
  //    }
  //    //送信テスト
  //    {
  //      //Uri uri = Uri.parse("${Setting.backendUrl}/user/me");
  //      //Map<String, String> headers = {'Authorization': 'Bearer $token'};
  //      //var res = await http.get(uri, headers: headers);
  //      //var json_data = json.decode(res.body);

  //      //logger.d('user_id: ${json_data["user"]["id"]}');
  //      //var user_id = json_data["user"]["id"] as int;
  //      //DateTime datetime = DateTime.now(); // StringからDate

  //      //var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss', "ja_JP");
  //      //var formatted = formatter.format(datetime); // DateからString
  //      //String body = json.encode(
  //      //    {'user_id': '$user_id', 'type': 'test_type1', 'meas_time': formatted});
  //      //logger.i(body);
  //      //uri = Uri.parse("${Setting.backendUrl}/measure/create_measure");
  //      //headers = {
  //      //  'Authorization': 'Bearer $token',
  //      //  'content-type': 'application/json'
  //      //};
  //      //res = await http.post(uri, headers: headers, body: body);
  //      //json_data = json.decode(res.body);
  //      //logger.i(json_data);
  //      //if (json_data["result"] == 0) {
  //      //  var measure_id = json_data["measure"]["id"] as int;
  //      //  String body = json.encode(
  //      //      {'measure_id': '$measure_id', 'col': 'test_score3', 'value': '99'});
  //      //  logger.i(body);
  //      //  uri = Uri.parse("${Setting.backendUrl}/measure/create_data");
  //      //  headers = {
  //      //    'Authorization': 'Bearer $token',
  //      //    'content-type': 'application/json'
  //      //  };
  //      //  res = await http.post(uri, headers: headers, body: body);
  //      //  json_data = json.decode(res.body);
  //      //  logger.i(json_data);

  //      //  body = json.encode({
  //      //    'measure_id': '$measure_id',
  //      //    'nums': [1, 2, 3, 4, 5],
  //      //    'times': [0.1, 0.2, 0.3, 0.4, 0.5],
  //      //    'col_ids': [1, 1, 1, 1, 1],
  //      //    'values': [0.2, 0.2, 0.2, 0.2, 0.2]
  //      //  });
  //      //  logger.i(body);
  //      //  uri = Uri.parse("${Setting.backendUrl}/measure/create_timeseries");
  //      //  headers = {
  //      //    'Authorization': 'Bearer $token',
  //      //    'content-type': 'application/json'
  //      //  };
  //      //  res = await http.post(uri, headers: headers, body: body);
  //      //  json_data = json.decode(res.body);
  //      //  logger.i(json_data);
  //      //}
  //    }
  //  }
  //}
  //return measureResultList;
});
