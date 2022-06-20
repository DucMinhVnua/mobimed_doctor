
import 'CommonTypeData.dart';

class UserInfoData {

	String _id;
	BaseUserInfoData base;
	CommonTypeData department;

	String get id => _id;

	UserInfoData.fromJson(Map<String, dynamic> map):
				_id = map["_id"],
				base = map["base"] != null ? BaseUserInfoData.fromJson(map["base"]) : null,
				department = map["department"] != null ? CommonTypeData.fromJsonMap(map["department"]) : null;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_id'] = _id;
		data['base'] = base;
		data['department'] = department;
		return data;
	}
}

class BaseUserInfoData {

	String sub, name, fullName, code, avatar, departmentName, address, phoneNumber, email, work, gender;
	DateTime birthday;

	BaseUserInfoData.fromJson(Map<String, dynamic> map):
				sub = map["sub"],
				fullName = map["fullName"],
				name = map["name"],
				gender = map["gender"],
				code = map["code"],
				avatar = map["avatar"],
				departmentName = map["departmentName"],
				address = map["address"],
				email = map["email"],
				phoneNumber = map["phoneNumber"],
				work = map["work"],
	//createdTime = DateTime.parse(map['createdTime'].toString())
				birthday = map.containsKey("birthday") && map["birthday"] !=null ? DateTime.parse(map['birthday'].toString()): null
	;
//				birthday = map["birthday"] !=null ? DateTime.parse(map["birthday"].toString()): null;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sub'] = sub;
		data['name'] = name;
		data['fullName'] = fullName;
		data['gender'] = gender;
		data['code'] = code;
		data['avatar'] = avatar;
		data['departmentName'] = departmentName;
		data['address'] = address;
		data['email'] = email;
		data['phoneNumber'] = phoneNumber;
		data['work'] = work;
		data['birthday'] = birthday.toIso8601String();
		return data;
	}
}
