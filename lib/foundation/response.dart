class MeasureResponse {
  final int id;
  final String type;
  final String meas_time;

  MeasureResponse(
      {required this.id, required this.type, required this.meas_time});
  MeasureResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        type = json["type"],
        meas_time = json["meas_time"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "meas_time": meas_time,
      };
}

class MeasureDataResponse {
  final int id;
  final int measure_id;
  final String col;
  final String value;

  MeasureDataResponse(
      {required this.id,
      required this.measure_id,
      required this.col,
      required this.value});
  MeasureDataResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        measure_id = json["measure_id"],
        col = json["col"],
        value = json["value"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "measure_id": measure_id,
        "col": col,
        "value": value,
      };
}

class MeasureTimeseriesServerResponse {
  final int id;
  final int measure_id;
  final int col_id;
  final int num;
  final double time;
  final double value;

  MeasureTimeseriesServerResponse(
      {required this.id,
      required this.measure_id,
      required this.col_id,
      required this.num,
      required this.time,
      required this.value});
  MeasureTimeseriesServerResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        measure_id = json["measure_id"],
        col_id = json["col_id"],
        num = json["num"],
        time = json["time"],
        value = json["value"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "measure_id": measure_id,
        "col_id": col_id,
        "num": num,
        "time": time,
        "value": value,
      };
}

class MeasureTimeseriesColResponse {
  final int id;
  final String value;

  MeasureTimeseriesColResponse({required this.id, required this.value});
  MeasureTimeseriesColResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        value = json["value"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
      };
}
