import 'package:auto_route/auto_route.dart';
import 'package:get_emg_data/view/sign_in_page.dart';
import 'package:get_emg_data/view/raw_data_measure_page.dart';
import 'package:get_emg_data/view/setting_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: "/", page: SignInPage, initial: true),
    AutoRoute(path: "/raw_data_measure", page: RawDataMeasurePage),
    AutoRoute(path: "/setting", page: SettingPage),
  ],
)
class $AppRouter {}
