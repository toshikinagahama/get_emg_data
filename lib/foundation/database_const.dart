import 'package:get_emg_data/gen/assets.gen.dart';

class DatabaseConst {
  static const general = DBGeneralConst();
  static const system = DBSystemParamConst();
  static const measure = DBMeasureConst();
  static const measureData = DBMeasureDataConst();
  static const measureTimeseriesLocal = DBMeasureTimeseriesLocalConst();
  static const measureTimeseriesCol = DBMeasureTimeseriesColConst();
}

class DBGeneralConst {
  const DBGeneralConst();

  String get databaseName => "database.db";
  int get version => 1;
  int get trueFlag => 1;
  int get falseFlag => 0;
  List<String> get initialSQLs => [
        Assets.sql.createSystemParam,
        Assets.sql.insertSystemParam,
        Assets.sql.createMeasure,
        Assets.sql.createMeasureData,
        Assets.sql.createMeasureTimeseriesLocal,
        Assets.sql.createMeasureTimeseriesCol,
      ];
}

class DBSystemParamConst {
  const DBSystemParamConst();

  String get table => "m_system_param";
  String get name => "param_name";
  String get value => "param_value";

  String get peripheralName => "peripheral_name";
  String get accessToken => "access_token";
  String get cntImpStable => "cnt_imp_stable";
  String get bestBreathTotal => "best_breath_total";
  String get bestBreathIn => "best_breath_in";
  String get bestBreathEx => "best_breath_ex";
}

class DBMeasureConst {
  const DBMeasureConst();

  String get table => "measure";
  String get id => "id";
  String get serverId => "server_id";
  String get type => "type";
  String get measTime => "meas_time";
}

class DBMeasureDataConst {
  const DBMeasureDataConst();
  String get table => "measure_data";
  String get id => "id";
  String get measureId => "measure_id";
  String get measureServerId => "measure_server_id";
  String get col => "col";
  String get value => "value";
}

class DBMeasureTimeseriesLocalConst {
  const DBMeasureTimeseriesLocalConst();
  String get table => "measure_timeseries_local";
  String get id => "id";
  String get measureId => "measure_id";
  String get measureServerId => "measure_server_id";
  String get num => "num";
  String get time => "time";
  String get wam_r_50khz => "wam_r_50khz";
  String get wam_x_50khz => "wam_x_50khz";
  String get ppg => "ppg";
}

class DBMeasureTimeseriesColConst {
  const DBMeasureTimeseriesColConst();
  String get table => "measure_timeseries_col";
  String get id => "id";
  String get value => "value";
}
