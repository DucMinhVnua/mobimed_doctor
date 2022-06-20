import 'package:DoctorApp/model/BaseTypeData.dart';

class AddressData {
//  String _id;
  String name, code;
  String districtCode, provinceCode;
  String __typename;
  BaseTypeData district;
  BaseTypeData province;

  AddressData(this.name, this.code, this.__typename);

//  String get id => _id;

  AddressData.fromJsonMap(Map<String, dynamic> map)
      :
//        _id = map["_id"],
        name = map["name"],
        code = map["code"],
        __typename = map["__typename"],
        districtCode =
            map.containsKey("districtCode") && map["districtCode"] != null
                ? map["districtCode"]
                : null,
        provinceCode =
            map.containsKey("provinceCode") && map["provinceCode"] != null
                ? map["provinceCode"]
                : null,
        district = map.containsKey("district") && map["district"] != null
            ? BaseTypeData.fromJsonMap(map["district"])
            : null,
        province = map.containsKey("province") && map["province"] != null
            ? BaseTypeData.fromJsonMap(map["province"])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['_id'] = _id;
    data['name'] = name;
    data['code'] = code;
    data['__typename'] = __typename;
    return data;
  }
}
