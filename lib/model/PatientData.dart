import 'package:DoctorApp/model/BaseTypeData.dart';

class PatientData {
  String _id;
  String name;
  String fullName;
  String phoneNumber;
  String address;
  DateTime birthDay;
  String email;
  String patientCode;
  String avatar;
  String gender;
//  bool hisCode;
  String insuranceCode;
//	BaseTypeData work;
//	createdTime hisCode;
  BaseTypeData province;
  BaseTypeData district;
  BaseTypeData ward;
  String street;
  BaseTypeData nationality;
  BaseTypeData nation;
  BaseTypeData work;

  // ignore: unnecessary_getters_setters
  String get id => _id;

  // ignore: unnecessary_getters_setters
  set id(String newID) {
    _id = newID;
  }

  PatientData();

  PatientData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        name = map["name"],
        fullName = map["fullName"],
        phoneNumber = map["phoneNumber"],
        address = map["address"],
        birthDay = map["birthDay"] != null
            ? DateTime.parse(map["birthDay"].toString())
            : null,
        email = map["email"],
        patientCode = map["patientCode"],
        avatar = map["avatar"],
        gender = map["gender"],
        insuranceCode = map["insuranceCode"],
        street = map["street"],
        work =
            map["work"] != null ? BaseTypeData.fromJsonMap(map["work"]) : null,
        province = map["province"] != null
            ? BaseTypeData.fromJsonMap(map["province"])
            : null,
        district = map["district"] != null
            ? BaseTypeData.fromJsonMap(map["district"])
            : null,
        ward =
            map["ward"] != null ? BaseTypeData.fromJsonMap(map["ward"]) : null,
        nationality = map["nationality"] != null
            ? BaseTypeData.fromJsonMap(map["nationality"])
            : null,
        nation = map["nation"] != null
            ? BaseTypeData.fromJsonMap(map["nation"])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['birthDay'] = birthDay.toIso8601String();
    data['email'] = email;
    data['patientCode'] = patientCode;
//    data['hisCode'] = hisCode;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['work'] = work != null ? work : null;
    data['province'] = province != null ? province : null;
    data['district'] = district != null ? district : null;
    data['ward'] = ward != null ? ward : null;
    data['nationality'] = nationality != null ? nationality : null;
    data['nation'] = nation != null ? nation : null;
    data['insuranceCode'] = insuranceCode;
    data['street'] = street;
    return data;
  }
}
