class BaseTypeData {
  String name, code;
  BaseTypeData( this.name, this.code);

  BaseTypeData.fromJsonMap(Map<String, dynamic> map):
//        _id = map["_id"],
        name = map["name"],
        code = map["code"]
  ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['_id'] = _id;
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}