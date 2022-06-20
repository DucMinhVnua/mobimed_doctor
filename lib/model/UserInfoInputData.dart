class UserInfoInputData {
  String _id,
      fullName,
      code,
      avatar,
      departmentId,
      address,
      phoneNumber,
      email,
      gender,
      work;
  DateTime birthday;

  set id(String newID) {
    this._id = newID;
  }

  UserInfoInputData();

  UserInfoInputData.fromJson(Map<String, dynamic> map)
      : _id = map["_id"],
        fullName = map["fullName"],
        code = map["code"],
        avatar = map["avatar"],
        departmentId = map["departmentId"],
        address = map["address"],
        email = map["email"],
        gender = map["gender"],
        phoneNumber = map["phoneNumber"],
        work = map["work"],
        //createdTime = DateTime.parse(map['createdTime'].toString())
        birthday = map.containsKey("birthday") && map["birthday"] != null
            ? DateTime.parse(map['birthday'].toString())
            : null;
//				birthday = map["birthday"] !=null ? DateTime.parse(map["birthday"].toString()): null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['fullName'] = fullName;
    data['code'] = code;
    data['avatar'] = avatar;
    data['departmentId'] = departmentId;
    data['address'] = address;
    data['email'] = email;
    data['gender'] = gender;
    data['phoneNumber'] = phoneNumber;
    data['work'] = work;
    data['birthday'] = birthday.toIso8601String();
    return data;
  }
  /* UserInfoInputData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        fullName = map["fullName"],
        phoneNumber = map["phoneNumber"],
        birthDay = map["birthDay"] != null
            ? DateTime.parse(map["birthDay"].toString())
            : null,
        gender = map["gender"],
        insuranceCode = map["insuranceCode"],
				nationIdentification = map["nationIdentification"],
				nationality = map.containsKey("nationality") && map["nationality"] != null ? BaseTypeData.fromJsonMap(map["nationality"]) : null,
				nation = map.containsKey("nation") && map["nation"] != null ? BaseTypeData.fromJsonMap(map["nation"]) : null,
				province = map.containsKey("province") && map["province"] != null ? BaseTypeData.fromJsonMap(map["province"]) : null,
				district = map.containsKey("district") && map["district"] != null ? BaseTypeData.fromJsonMap(map["district"]) : null,
				ward = map.containsKey("ward") && map["ward"] != null ? map["ward"] : null,
				street = map.containsKey("street") && map["street"] != null ? map["street"] : null
  ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['birthDay'] = birthDay != null ? birthDay.toIso8601String(): "";
    data['gender'] = gender;
    data['insuranceCode'] = insuranceCode;
    data['nationIdentification'] = nationIdentification;
    data['nationality'] = nationality;
    data['nation'] = nation;
    data['province'] = province;
    data['district'] = district;
    data['ward'] = ward;
    data['street'] = street;
    return data;
  }*/
}
