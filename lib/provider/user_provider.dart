import 'package:flutter/foundation.dart';
import 'package:get_emg_data/foundation/database_const.dart';
import 'package:get_emg_data/provider/database_provider.dart';
import "package:get_emg_data/util/logger.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/data/model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/foundation/setting.dart';

class UserNotifier extends ChangeNotifier {
  UserNotifier(this.ref) : super();
  final Ref ref;
  User? user;

  ///
  /// サインインして、ユーザー名を取得する。
  Future<String> signIn(String username, String password) async {
    //user?.name = "test";
    logger.i(ref.read(databaseProvider).isOpened);
    Uri url = Uri.parse("${Const.backendUrl}/token");
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({'username': username, "password": password});

    http.Response res = await http.post(url, headers: headers, body: body);
    if (res.statusCode == 200) {
      var json_data = json.decode(res.body);
      logger.d(json_data);
      if (json_data["access_token"] == null) {
        logger.i("トークンエラー");
        return "";
      } else {
        getUser(json_data["access_token"]);
        return json_data["access_token"];
      }
    } else {
      logger.d("ログイン失敗");
      return "";
    }
  }

  ///
  /// サインアウトしてユーザーをnullにする。
  ///
  void signOut() async {
    try {
      user = null;
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  ///
  /// ユーザーを取得する
  ///
  void getUser(token) async {
    Uri uri = Uri.parse('${Const.backendUrl}/user/me');
    final res =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    var json_data = json.decode(res.body);
    logger.i(res.body);
    user = User();
    user?.name = json_data["user"]["username"];
    user?.id = int.parse(json_data["user"]["id"].toString());
    user?.token = token;

    notifyListeners();
  }

  ///
  /// トークンが有効かどうかを検証する。
  ///
  Future<bool> isValidToken(String token) async {
    Uri uri = Uri.parse("${Const.backendUrl}/user/me");
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final res = await http.get(uri, headers: headers);
    var json_data = json.decode(res.body);
    if (json_data["result"] == null) {
      return false;
    } else {
      if (json_data["result"] != 0) {
        return false;
      } else {
        return true;
      }
    }
  }
}
