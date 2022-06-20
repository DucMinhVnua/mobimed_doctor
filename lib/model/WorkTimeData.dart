class WorkTimeData {
  String _id;
  String code;
  String name;
  List<WorkTimeServeTimeData> servtimeOnDate;

  WorkTimeData(this._id, this.code, this.name);

  String get id => _id;

  WorkTimeData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        code = map["code"] != null ? map["code"] : "",
        name = map["name"] != null ? map["name"] : "",
        servtimeOnDate = map["servtime_on_date"] != null
            ? List<WorkTimeServeTimeData>.from(map["servtime_on_date"]
                .map((item) => WorkTimeServeTimeData.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['name'] = name;
    data['servtime_on_date'] = servtimeOnDate;
    return data;
  }
}

class WorkTimeServeTimeData {
  String time;
  int remain;
  int total;
  bool isSelected = false;

  WorkTimeServeTimeData(this.time, this.remain, this.total);

  WorkTimeServeTimeData.fromJsonMap(Map<String, dynamic> map)
      : time = map["time"],
        remain = map["remain"] != null ? map["remain"] : 0,
        total = map["total"] != null ? map["total"] : 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = time;
    data['remain'] = remain;
    data['total'] = total;
    return data;
  }
}
