import '../../../model/BaseTypeData.dart';
import '../house_appoinmrnt_data.dart';

class HomeBook {
  List<HomeServiceBook> services;
  List<HomePatientBook> patientInfo;
  String note;
  HomeBook();
  HomeBook.fromJsonMap(Map<String, dynamic> map)
      : note = map['note'],
        patientInfo =
            map.containsKey('patientInfo') && map['patientInfo'] != null
                ? List<HomePatientBook>.from(map['patientInfo']
                    .map((item) => HomePatientBook.fromJsonMap(item)))
                : null,
        services = map.containsKey('services') && map['services'] != null
            ? List<HomeServiceBook>.from(map['services']
                .map((item) => HomeServiceBook.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['services'] = services.map((e) => e.toJson()).toList();
    data['patientInfo'] = patientInfo.map((e) => e.toJson()).toList();
    data['note'] = note;
    return data;
  }
}

class PatientInput {
  // PatientInput(
  //     {id,
  //     patientCode,
  //     firstName,
  //     middleName,
  //     lastName,
  //     birthDay,
  //     gender,
  //     insuranceCode,
  //     phoneNumber,
  //     province,
  //     district,
  //     ward,
  //     street});

  final String _id;
  String relationshipName;
  String patientCode;
  String fullName;
  DateTime birthDay;
  String gender;
  String insuranceCode;
  String phoneNumber;
  String address;
  BaseTypeData province;
  BaseTypeData district;
  BaseTypeData ward;
  String street;
  BaseTypeData nationality;
  BaseTypeData nation;
  BaseTypeData work;

  bool isCheck;

  String get id => _id;

  String get displayRelationShip => '$relationshipName ($fullName)';

  PatientInput(this._id);

  PatientInput.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        patientCode = map.containsKey('patientCode') ? map['patientCode'] : '',
        relationshipName =
            map.containsKey('relationshipName') ? map['relationshipName'] : '',
//        firstName = map.containsKey("firstName") ? map["firstName"] : "",
//        middleName = map.containsKey("middleName") ? map["middleName"] : "",
//        lastName = map.containsKey("lastName") ? map["lastName"] : "",
        fullName = map.containsKey('fullName') ? map['fullName'] : '',
        gender = map.containsKey('gender') ? map['gender'] : '',
        insuranceCode =
            map.containsKey('insuranceCode') ? map['insuranceCode'] : '',
        phoneNumber = map.containsKey('phoneNumber') ? map['phoneNumber'] : '',
        street = map.containsKey('street') ? map['street'] : '',
        birthDay = map['birthDay'] != null
            ? DateTime.parse(map['birthDay'].toString())
            : null,
        province = map['province'] != null && map['province'] != ''
            ? BaseTypeData.fromJsonMap(map['province'])
            : null,
        district = map['district'] != null && map['district'] != ''
            ? BaseTypeData.fromJsonMap(map['district'])
            : null,
        nationality =
            map.containsKey('nationality') && map['nationality'] != null
                ? BaseTypeData.fromJsonMap(map['nationality'])
                : null,
        nation = map.containsKey('nation') && map['nation'] != null
            ? BaseTypeData.fromJsonMap(map['nation'])
            : null,
        ward = map['ward'] != null && map['ward'] != ''
            ? BaseTypeData.fromJsonMap(map['ward'])
            : null,
        work = map.containsKey('work') && map['work'] != null
            ? BaseTypeData.fromJsonMap(map['work'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['patientCode'] = patientCode;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['insuranceCode'] = insuranceCode;
    data['phoneNumber'] = phoneNumber;
    data['street'] = street;
    data['birthDay'] = birthDay?.toIso8601String();
    data['nationality'] = nationality;
    data['nation'] = nation;
    data['province'] = province?.toJson();
    data['district'] = district?.toJson();
    data['ward'] = ward?.toJson();
    data['work'] = work?.toJson();
    return data;
  }
}

class HomeServiceBook {
  String _id;
  bool isPack;
  DateTime servingTime;
  HomeServiceBook();
  String get id => _id;

  void setId(String newID) {
    _id = newID;
  }

  HomeServiceBook.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        isPack = map['isPack'],
        servingTime = DateTime.parse(map['servingTime'].toString());
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['isPack'] = isPack;
    data['servingTime'] = servingTime.toIso8601String();
    return data;
  }
}
