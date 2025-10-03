// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:get_emg_data/view/raw_data_measure_page.dart' as _i1;
import 'package:get_emg_data/view/setting_page.dart' as _i2;
import 'package:get_emg_data/view/sign_in_page.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    RawDataMeasureRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.RawDataMeasurePage(),
      );
    },
    SettingRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.SettingPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.SignInPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.RawDataMeasurePage]
class RawDataMeasureRoute extends _i4.PageRouteInfo<void> {
  const RawDataMeasureRoute({List<_i4.PageRouteInfo>? children})
      : super(
          RawDataMeasureRoute.name,
          initialChildren: children,
        );

  static const String name = 'RawDataMeasureRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.SettingPage]
class SettingRoute extends _i4.PageRouteInfo<void> {
  const SettingRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SignInPage]
class SignInRoute extends _i4.PageRouteInfo<void> {
  const SignInRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
