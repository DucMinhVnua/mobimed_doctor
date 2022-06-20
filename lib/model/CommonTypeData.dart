class CommonTypeData {
  String _id;
  String code;
  String name;

  CommonTypeData(this._id, this.code, this.name);

  String get id => _id;

  CommonTypeData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        code = map["code"] != null ? map["code"] : "",
        name = map["name"] != null ? map["name"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

class CommonTypeDataChild {
  String _id;
  String name;
  String fullName;

  CommonTypeDataChild(this._id, this.name, this.fullName);

  String get id => _id;

  CommonTypeDataChild.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        name = map["name"] != null ? map["name"] : "",
        fullName = map["fullName"] != null ? map["fullName"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    data['fullName'] = fullName;
    return data;
  }
}

class CommonTypeDataAll {
  String _id;
  String code;
  String name;
  List<CommonTypeDataChild> children;

  CommonTypeDataAll(this._id, this.code, this.name, this.children);

  String get id => _id;

  CommonTypeDataAll.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        code = map["code"] != null ? map["code"] : "",
        name = map["name"] != null ? map["name"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

class ServiceParent {
  ServiceData info;
  List<ServiceData> children;

  ServiceParent(this.info, this.children);
}

class ServiceData {
  String _id;
  String name;
  String parentId;
  String note;
  int level;
  List<Departments> departments;
  bool haveChildren;

  String get id => _id;

  ServiceData(this._id, this.name, this.parentId, this.note, this.departments,
      this.haveChildren, this.level);

  ServiceData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        departments = map.containsKey("departments") &&
                map["departments"] != null
            ? List<Departments>.from(
                map["departments"].map((item) => Departments.fromJsonMap(item)))
            : null,
        parentId = map["parentId"] != null ? map["parentId"] : "",
        note = map["note"] != null ? map["note"] : "",
        level = map["level"] != null ? map["level"] : "",
        haveChildren = map["haveChildren"] != null ? map["haveChildren"] : "",
        name = map["name"] != null ? map["name"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['fullName'] = parentId;
    data['note'] = note;
    data['level'] = level;
    data['name'] = name;
    data['departments'] = departments;
    data['haveChildren'] = haveChildren;
    return data;
  }
}

class Departments {
  String _id;
  String code;
  String name;

  Departments(this._id, this.code, this.name);

  String get id => _id;

  Departments.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        code = map["code"] != null ? map["code"] : "",
        name = map["name"] != null ? map["name"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

class ServingTimes {
  String dayOfWeek;
  int maxProcess;
  List<String> timeFrame;

  ServingTimes(this.dayOfWeek, this.maxProcess, this.timeFrame);

  ServingTimes.fromJsonMap(Map<String, dynamic> map)
      : dayOfWeek = map["dayOfWeek"] != null ? map["dayOfWeek"] : "",
        maxProcess = map["maxProcess"] != null ? map["maxProcess"] : "",
        // timeFrame = map["timeFrame"] != null ? map["timeFrame"] : "";
        timeFrame = map.containsKey("timeFrame") && map["timeFrame"] != null
            ? List<String>.from(map["timeFrame"].map((item) => item))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayOfWeek'] = dayOfWeek;
    data['maxProcess'] = maxProcess;
    data['timeFrame'] = timeFrame;
    return data;
  }
}

class DepartmentInfo {
  String _id;
  bool enableTimeFrame;
  List<ServingTimes> servingTimes;

  DepartmentInfo(this._id, this.enableTimeFrame, this.servingTimes);

  String get id => _id;

  DepartmentInfo.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        enableTimeFrame =
            map["enableTimeFrame"] != null ? map["enableTimeFrame"] : "",
        servingTimes =
            map.containsKey("servingTimes") && map["servingTimes"] != null
                ? List<ServingTimes>.from(map["servingTimes"]
                    .map((item) => ServingTimes.fromJsonMap(item)))
                : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['enableTimeFrame'] = enableTimeFrame;
    data['servingTimes'] = servingTimes;
    return data;
  }
}
