class ShortEmployeeData {
  // ignore: empty_constructor_bodies
  ShortEmployeeData() {}

  String _id;
  String code, fullName, work, departmentId, departmentName;

  String get id => _id;

  ShortEmployeeData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        code = map["code"],
        fullName = map["fullName"],
        work = map["work"],
        departmentId = map["departmentId"],
        departmentName = map["departmentName"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['fullName'] = fullName;
    data['work'] = work;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    return data;
  }
}
