class IndicationItem {
  String _id;
  String code;
  String name;
  String categoryCode;
  String viewCode;
  String unit;
  String info;

  IndicationItem(this._id, this.code, this.name, this.categoryCode,
      this.viewCode, this.unit, this.info);

  String get id => _id;

  IndicationItem.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        code = map["code"] != null ? map["code"] : "",
        name = map["name"] != null ? map["name"] : "",
        categoryCode = map["categoryCode"] != null ? map["categoryCode"] : "",
        viewCode = map["viewCode"] != null ? map["viewCode"] : "",
        unit = map["unit"] != null ? map["unit"] : "",
        info = map["info"] != null ? map["info"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['name'] = name;
    data['categoryCode'] = categoryCode;
    data['viewCode'] = viewCode;
    data['unit'] = unit;
    data['info'] = info;
    return data;
  }
}

class IndicationFiles {
  String _id;
  String name;

  IndicationFiles(this._id, this.name);

  String get id => _id;

  IndicationFiles.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"] != null ? map["_id"] : "",
        name = map["name"] != null ? map["name"] : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    return data;
  }
}
