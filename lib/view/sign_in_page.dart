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
    //データベースの初期化
    bool isOpened =
        ref.watch(databaseProvider.select((value) => value.isOpened));
    if (!isOpened) {
      ref.read(databaseProvider).initialize();
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
            future: Future.value(),
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
                          const SizedBox(height: 120),
                          AppButton(
                            text: "生データ測定",
                            onPressed: () {
                              context.router.pushNamed("/raw_data_measure");
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
