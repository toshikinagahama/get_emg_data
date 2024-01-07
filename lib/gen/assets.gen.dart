/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

class $AssetsSqlGen {
  const $AssetsSqlGen();

  /// File path: assets/sql/create_measure.sql
  String get createMeasure => 'assets/sql/create_measure.sql';

  /// File path: assets/sql/create_measure_data.sql
  String get createMeasureData => 'assets/sql/create_measure_data.sql';

  /// File path: assets/sql/create_measure_timeseries_col.sql
  String get createMeasureTimeseriesCol =>
      'assets/sql/create_measure_timeseries_col.sql';

  /// File path: assets/sql/create_measure_timeseries_local.sql
  String get createMeasureTimeseriesLocal =>
      'assets/sql/create_measure_timeseries_local.sql';

  /// File path: assets/sql/create_system_param.sql
  String get createSystemParam => 'assets/sql/create_system_param.sql';

  /// File path: assets/sql/insert_system_param.sql
  String get insertSystemParam => 'assets/sql/insert_system_param.sql';

  /// List of all assets
  List<String> get values => [
        createMeasure,
        createMeasureData,
        createMeasureTimeseriesCol,
        createMeasureTimeseriesLocal,
        createSystemParam,
        insertSystemParam
      ];
}

class Assets {
  Assets._();

  static const $AssetsSqlGen sql = $AssetsSqlGen();
}
