import 'dart:convert';

import 'package:DoctorApp/model/AppointmentData.dart';

class UserActionData {
  String _id;
  String name;
  String action;
  DateTime createdTime;
  ShortAppointmentData appointment;
  dynamic data;

  UserActionData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        name = map["name"],
        action = map["action"],
        appointment =
            map.containsKey("appointment") && map["appointment"] != null
                ? ShortAppointmentData.fromJsonMap(map["appointment"])
                : null,
        data =
            map.containsKey("data") && map["data"] != null ? map["data"] : null,
        createdTime = DateTime.parse(map['createdTime'].toString());

  get id => _id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataToJson = new Map<String, dynamic>();
    dataToJson['_id'] = _id;
    dataToJson['name'] = name;
    dataToJson['action'] = action;
    dataToJson['createdTime'] = createdTime.toIso8601String();
    dataToJson['appointment'] = appointment;
    dataToJson['data'] = data != null ? jsonEncode(data) : null;
    return dataToJson;
  }
}

class ShortUserActionData {
  String _id;
  String name;
  String action;
  DateTime createdTime;
  ShortAppointmentData appointment;

  ShortUserActionData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        name = map["name"],
        action = map["action"],
        appointment =
            map.containsKey("appointment") && map["appointment"] != null
                ? ShortAppointmentData.fromJsonMap(map["appointment"])
                : null,
        createdTime = DateTime.parse(map['createdTime'].toString());

  get id => _id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    data['action'] = action;
    data['createdTime'] = createdTime.toIso8601String();
    data['appointment'] = appointment;
    return data;
  }
}

/*class AppointmentUserActionData {

	String _id;
	String AppointmentId;
	String Sequence;
	String Code;
	String Reason;
	String PatientCode;
	String PatientCode;
	String PatientCode;

	String note;
	String patientCode;
	String channel;
	String state;
	DateTime appointmentDate;
	DateTime appointmentTime;
	DateTime updatedTime;
	DateTime createdTime;
	PatientData patient;
	BaseTypeData department;
	BaseTypeData service;

	AppointmentData.fromJsonMap(Map<String, dynamic> map):
				_id = map["_id"],
				AppointmentId = map["AppointmentId"],
				Sequence = map["Sequence"],
				Code = map["Code"],
				Reason = map["Reason"],
				PatientCode = map["PatientCode"],
				Sequence = map["Sequence"],
				Sequence = map["Sequence"],

				note = map["note"],
				patientCode = map["patientCode"],
				channel = map["channel"],
				state = map["state"],
				updatedTime = DateTime.parse(map['updatedTime'].toString()),
				createdTime = DateTime.parse(map['createdTime'].toString()),
				appointmentDate = DateTime.parse(map['appointmentDate'].toString()),
				appointmentTime = DateTime.parse(map['appointmentTime'].toString()),
				patient = map.containsKey("patient") && map["patient"] != null
						? PatientData.fromJsonMap(map["patient"])
						: null,
				department = map.containsKey("department") && map["department"] != null
						? BaseTypeData.fromJsonMap(map["department"])
						: null,
				service = map.containsKey("service") && map["service"] != null
						? BaseTypeData.fromJsonMap(map["service"])
						: null;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_id'] = _id;
		data['AppointmentId'] = AppointmentId;
		data['Sequence'] = Sequence;
		data['Code'] = Code;
		data['Reason'] = Reason;
		data['PatientCode'] = PatientCode;
		data['Sequence'] = Sequence;

		data['note'] = note;
		data['patientCode'] = patientCode;
		data['channel'] = channel;
		data['state'] = state;
		data['updatedTime'] = updatedTime.toIso8601String();
		data['createdTime'] = createdTime.toIso8601String();
		data['appointmentTime'] = appointmentTime.toIso8601String();
		data['appointmentDate'] = appointmentDate.toIso8601String();
		data['patient'] = patient;
		data['department'] = department;
		data['service'] = service;
		return data;
	}
}*/


