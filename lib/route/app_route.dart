import 'package:auto_route/auto_route.dart';
import 'package:get_emg_data/view/sign_in_page.dart';
import 'package:get_emg_data/view/raw_data_measure_page.dart';
import 'package:get_emg_data/view/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_emg_data/route/app_route.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  WidgetRef ref;
  AppRouter(this.ref) : super();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: "/", page: SignInRoute.page, initial: true),
        AutoRoute(path: "/raw_data_measure", page: RawDataMeasureRoute.page),
        AutoRoute(path: "/setting", page: SettingRoute.page),
      ];
}
