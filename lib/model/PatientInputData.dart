/*
import 'package:pshpnoibo/model/AddressData.dart';
import 'package:pshpnoibo/model/BaseTypeData.dart';

class PatientInput {

  PatientInput({id, patientCode, firstName, middleName, lastName, birthDay, gender, insuranceCode, phoneNumber, province, district, ward, street});

  String _id;
  String relationshipName;
  String patientCode;
//  String firstName;
//  String middleName;
//  String lastName;
  String fullName;
  String avatar;
  String address;
  DateTime birthDay;
  String gender;
  String insuranceCode;
  String phoneNumber;
  BaseTypeData province;
  BaseTypeData district;
  BaseTypeData ward;
  String street;
  BaseTypeData nationality;
  BaseTypeData nation;
  BaseTypeData work;

  String get id => _id;
  set id (String newID){
    _id = newID;
  }

  String get displayRelationShip{
    return relationshipName + " (" + fullName + ")";
  }

  PatientInput.fromJsonMap(Map<String, dynamic> map):
        _id = map["_id"],
        patientCode = map.containsKey("patientCode") ? map["patientCode"] : "",
        relationshipName = map.containsKey("relationshipName") ? map["relationshipName"] : "",
//        firstName = map.containsKey("firstName") ? map["firstName"] : "",
//        middleName = map.containsKey("middleName") ? map["middleName"] : "",
//        lastName = map.containsKey("lastName") ? map["lastName"] : "",
        fullName = map.containsKey("fullName") ? map["fullName"] : "",
        avatar = map.containsKey("avatar") ? map["avatar"] : "",
        address = map.containsKey("address") ? map["address"] : "",
        gender = map.containsKey("gender") ? map["gender"] : "",
        insuranceCode = map.containsKey("insuranceCode") ? map["insuranceCode"] : "",
        phoneNumber = map.containsKey("phoneNumber") ? map["phoneNumber"] : "",
        street = map.containsKey("street") ? map["street"] : "",
        birthDay = map['birthDay'] != null ? DateTime.parse(map['birthDay'].toString()) : null,
        province = map["province"] != null && map["province"] != "" ? BaseTypeData.fromJsonMap(map["province"]) : null,
        district = map["district"] != null && map["district"] != "" ? BaseTypeData.fromJsonMap(map["district"]) : null,
        nationality =
        map.containsKey("nationality") && map["nationality"] != null
            ? BaseTypeData.fromJsonMap(map["nationality"])
            : null,
        nation = map.containsKey("nation") && map["nation"] != null
            ? BaseTypeData.fromJsonMap(map["nation"])
            : null,

        ward = map["ward"] != null && map["ward"] != "" ? BaseTypeData.fromJsonMap(map["ward"]) : null,
        work = map.containsKey("work") && map["work"] != null
            ? BaseTypeData.fromJsonMap(map["work"])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['patientCode'] = patientCode;
//    data['firstName'] = firstName;
//    data['middleName'] = middleName;
//    data['lastName'] = lastName;
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['address'] = address;
    data['gender'] = gender;
    data['insuranceCode'] = insuranceCode;
    data['phoneNumber'] = phoneNumber;
    data['street'] = street;
    data['birthDay'] = birthDay != null ? birthDay.toIso8601String() : null;
    data['nationality'] = nationality != null ? nationality : null;
    data['nation'] = nation != null ? nation : null;
    data['province'] = province != null ? province.toJson() : null;
    data['district'] = district != null ? district.toJson() : null;
    data['ward'] = ward != null ? ward.toJson() : null;
    data['work'] = work != null ? work.toJson() : null;
    return data;
  }

*/
