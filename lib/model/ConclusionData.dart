class ConclusionData {
  String code, name;
  List<ConclusionFiles> files;

  ConclusionData(this.code, this.name, this.files);

  String get id => code;

  ConclusionData.fromJsonMap(Map<String, dynamic> map)
      : code = map['code'],
        name = map['name'],
        files = map.containsKey('files') && map['files'] != null
            ? List<ConclusionFiles>.from(
                map['files'].map((item) => ConclusionFiles.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['name'] = name;
    data['files'] = files;
    return data;
  }
}

class ConclusionFiles {
  String _id, name;
  ConclusionFiles(this._id, this.name);
  String get id => _id;

  ConclusionFiles.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        name = map['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    return data;
  }
}

class DoctorData {
  String _id, departmentId, fullName, work;

  DoctorData(this._id, this.departmentId, this.fullName, this.work);

  String get id => _id;

  DoctorData.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        departmentId = map['departmentId'],
        fullName = map['fullName'],
        work = map['work'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['departmentId'] = departmentId;
    data['fullName'] = fullName;
    data['work'] = work;
    return data;
  }
}
