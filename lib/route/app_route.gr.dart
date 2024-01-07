// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:get_emg_data/view/raw_data_measure_page.dart' as _i3;
import 'package:get_emg_data/view/setting_page.dart' as _i4;
import 'package:get_emg_data/view/sign_in_page.dart' as _i1;
import 'package:get_emg_data/view/top_page.dart' as _i2;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i1.SignInPage(),
      );
    },
    TopRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.TopPage(),
      );
    },
    RawDataMeasureRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.RawDataMeasurePage(),
      );
    },
    SettingRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.SettingPage(),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          SignInRoute.name,
          path: '/',
        ),
        _i5.RouteConfig(
          TopRoute.name,
          path: '/top',
        ),
        _i5.RouteConfig(
          RawDataMeasureRoute.name,
          path: '/raw_data_measure',
        ),
        _i5.RouteConfig(
          SettingRoute.name,
          path: '/setting',
        ),
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i5.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.TopPage]
class TopRoute extends _i5.PageRouteInfo<void> {
  const TopRoute()
      : super(
          TopRoute.name,
          path: '/top',
        );

  static const String name = 'TopRoute';
}

/// generated route for
/// [_i3.RawDataMeasurePage]
class RawDataMeasureRoute extends _i5.PageRouteInfo<void> {
  const RawDataMeasureRoute()
      : super(
          RawDataMeasureRoute.name,
          path: '/raw_data_measure',
        );

  static const String name = 'RawDataMeasureRoute';
}

/// generated route for
/// [_i4.SettingPage]
class SettingRoute extends _i5.PageRouteInfo<void> {
  const SettingRoute()
      : super(
          SettingRoute.name,
          path: '/setting',
        );

  static const String name = 'SettingRoute';
}
