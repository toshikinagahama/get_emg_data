import 'package:auto_route/auto_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_emg_data/provider/measure_result_provider.dart';
import 'package:get_emg_data/provider/model_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:get_emg_data/component/app_button.dart';
import 'package:get_emg_data/foundation/app_color.dart';
import 'package:get_emg_data/provider/user_provider.dart';
import 'package:get_emg_data/route/app_route.gr.dart';
import 'package:get_emg_data/provider/database_provider.dart';
import 'package:get_emg_data/foundation/database_const.dart';
import 'package:get_emg_data/data/model/user.dart';
import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/foundation/app_text_theme.dart';
import 'package:get_emg_data/foundation/setting.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double w = 400;
    final username = useState("");
    final password = useState("");
    User? user = ref.watch(userProvider.select((value) => value.user));
    //データベースの初期化
    bool isOpened =
        ref.watch(databaseProvider.select((value) => value.isOpened));
    if (!isOpened) {
      ref.read(databaseProvider).initialize();
    }
    //logger.i(user);
    if (user == null) {
    } else {
      //context.router.pushNamed("/measure2");
      //context.router.pushNamed("/setting");
      //context.router.pushNamed("/mindfulness");
      context.router.pushNamed("/top");
    }
    if (isOpened) {
      //measure_timeseries_colだけはサーバー側と同期
    }

    Future<void> _checkToken() async {
      //(TODO) インピ安定回数の設定。本当はここに入れるべきではないが、ひとまず。
      var data = await ref.read(databaseProvider).select("m_system_param",
          columns: ["param_name", "param_value"],
          where:
              "${DatabaseConst.system.name}='${DatabaseConst.system.cntImpStable}'");

      ref.read(settingProvider).flush();
      try {
        Uri uri = Uri.parse("${Const.backendUrl}/measure/get_timeseries_cols");
        var res = await http.get(uri);
        if (res.statusCode == 200) {
          var json_data = json.decode(res.body);

          //logger.d(json_data);
          if (json_data["result"] == 0) {
            //
            var measureTsCol =
                json_data["measure_timeseries_col"] as List<dynamic>;
            for (int i = 0; i < measureTsCol.length; i++) {
              var data = await ref.read(databaseProvider).select(
                  DatabaseConst.measureTimeseriesCol.table,
                  columns: [
                    DatabaseConst.measureTimeseriesCol.id,
                    DatabaseConst.measureTimeseriesCol.value
                  ],
                  where:
                      "${DatabaseConst.measureTimeseriesCol.id}=${measureTsCol[i]['id']}");
              if (data.isEmpty) {
                //新規登録
                ref
                    .read(databaseProvider)
                    .insert(DatabaseConst.measureTimeseriesCol.table, {
                  DatabaseConst.measureTimeseriesCol.id: measureTsCol[i]['id'],
                  DatabaseConst.measureTimeseriesCol.value: measureTsCol[i]
                      ['value']
                });
              } else {
                //更新
                ref.read(databaseProvider).update(
                    DatabaseConst.measureTimeseriesCol.table,
                    {
                      DatabaseConst.measureTimeseriesCol.value: measureTsCol[i]
                          ['value']
                    },
                    "${DatabaseConst.measureTimeseriesCol.id}=${measureTsCol[i]['id']}");
              }
            }
            //確認
            var data = await ref
                .read(databaseProvider)
                .select(DatabaseConst.measureTimeseriesCol.table, columns: [
              DatabaseConst.measureTimeseriesCol.id,
              DatabaseConst.measureTimeseriesCol.value
            ]);
            //logger.i(data);
          }
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        logger.e(e.toString());
      }

      if (user == null) {
        var data = await ref.read(databaseProvider).select("m_system_param",
            columns: ["param_name", "param_value"],
            where:
                "${DatabaseConst.system.name}='${DatabaseConst.system.accessToken}'");
        logger.i(data);
        String token = data[0]["param_value"].toString();
        logger.i(token);
        if (token == "") {
          //tokenがなければ、サインインさせる。
        } else {
          var isValidToken = await ref.read(userProvider).isValidToken(token);
          if (isValidToken) {
            //何回もループに陥ってしまうので、こうしているがあんまり良くない実装。
            ref.read(userProvider).getUser(token);
          } else {
            //tokenが有効でなければ、一旦トークンを無効にする。
            ref.read(databaseProvider).update(
                "m_system_param",
                {DatabaseConst.system.value: ""},
                "${DatabaseConst.system.name}='${DatabaseConst.system.accessToken}'");
          }
        }
      }
      return Future.value();
    }

    return !isOpened
        ? Scaffold(
            body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColor.bgGradation,
                ),
                child: Center(
                  child: Text('Loading...'),
                )))
        : FutureBuilder(
            future: _checkToken(),
            builder: (context, snapshot) {
              return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scaffold(
                      body: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppColor.bgGradation,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 140),
                          Text(
                            'Sigin in',
                            style: AppText.h4,
                          ),
                          const SizedBox(height: 120),
                          Row(children: [
                            const SizedBox(width: 60),
                            Text(
                              "Uername",
                              style: AppText.body14,
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                                child: TextField(
                              enabled: true,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (e) {
                                username.value = e;
                              },
                            )),
                            const SizedBox(width: 60),
                          ]),
                          const SizedBox(height: 20),
                          Row(children: [
                            const SizedBox(width: 60),
                            Text(
                              "Password",
                              style: AppText.body14,
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                                child: TextField(
                              enabled: true,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (e) {
                                password.value = e;
                              },
                            )),
                            const SizedBox(width: 60),
                          ]),
                          const SizedBox(height: 20),
                          AppButton(
                              onPressed: () async {
                                var token = await ref
                                    .read(userProvider.notifier)
                                    .signIn(username.value, password.value);
                                ref.read(databaseProvider).update(
                                    "m_system_param",
                                    {DatabaseConst.system.value: token},
                                    "${DatabaseConst.system.name}='${DatabaseConst.system.accessToken}'");
                              },
                              text: "Sign in",
                              width: w * 0.8),
                          const SizedBox(height: 120),
                          AppButton(
                            text: "生データ測定",
                            onPressed: () {
                              context.router.pushNamed("/raw_data_measure");
                            },
                            width: w * 0.6,
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            text: "呼吸測定",
                            onPressed: () {
                              context.router.pushNamed("/measure");
                            },
                            width: w * 0.6,
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            text: "呼吸測定2",
                            onPressed: () {
                              context.router.pushNamed("/measure2");
                            },
                            width: w * 0.6,
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            text: "設定",
                            onPressed: () {
                              context.router.pushNamed("/setting");
                            },
                            width: w * 0.6,
                          ),
                        ],
                      ),
                    ),
                  )));
            });
  }
}
