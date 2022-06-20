import 'package:DoctorApp/model/BaseTypeData.dart';
import 'package:DoctorApp/model/CommonTypeData.dart';
import 'package:DoctorApp/model/ConclusionData.dart';
import 'package:DoctorApp/model/PatientData.dart';
import 'package:DoctorApp/model/UserInfoData.dart';

class AppointmentData {
  String _id;
  String note;
  String code;
  String channel;
  String state;
  DateTime appointmentDate;
  String appointmentTime;
  DateTime updatedTime;
  DateTime createdTime;
  PatientData patient;
  PatientData inputPatient;
  CommonTypeData department;
  BaseTypeData service;
  UserInfoData doctor;

  AppointmentData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        note = map["note"],
        code = map["code"],
        channel = map["channel"],
        state = map["state"],
        updatedTime = DateTime.parse(map['updatedTime'].toString()),
        createdTime = DateTime.parse(map['createdTime'].toString()),
        appointmentDate = DateTime.parse(map['appointmentDate'].toString()),
        appointmentTime = map["appointmentTime"],
//				appointmentTime = DateTime.parse(map['appointmentTime'].toString()),
        doctor = map.containsKey("doctor") && map["doctor"] != null
            ? UserInfoData.fromJson(map["doctor"])
            : null,
        patient = map.containsKey("patientInfo") && map["patientInfo"] != null
            ? PatientData.fromJsonMap(map["patientInfo"])
            : null,
        inputPatient =
            map.containsKey("inputPatient") && map["inputPatient"] != null
                ? PatientData.fromJsonMap(map["inputPatient"])
                : null,
        department = map.containsKey("department") && map["department"] != null
            ? CommonTypeData.fromJsonMap(map["department"])
            : null,
        service = map.containsKey("service") && map["service"] != null
            ? BaseTypeData.fromJsonMap(map["service"])
            : null;

  get id => _id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['note'] = note;
    data['code'] = code;
    data['channel'] = channel;
    data['state'] = state;
    data['updatedTime'] = updatedTime.toIso8601String();
    data['createdTime'] = createdTime.toIso8601String();
    data['appointmentTime'] = appointmentTime;
//		data['appointmentTime'] = appointmentTime.toIso8601String();
    data['appointmentDate'] = appointmentDate.toIso8601String();
    data['patientInfo'] = patient;
    data['inputPatient'] = inputPatient;
    data['department'] = department;
    data['service'] = service;
    data['doctor'] = doctor;
    return data;
  }
}

class ShortAppointmentData {
  String _id;
  DateTime appointmentDate;
  String appointmentTime;
  String channel;
  String note;
  String code;
  DateTime createdTime;
  // CommonTypeData department;
  List<ConclusionData> conclusions;

  ShortAppointmentData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        note = map["note"],
        code = map["code"],
        appointmentTime = map["appointmentTime"],
        channel = map["channel"],
//				appointmentDate = DateTime.parse(map['appointmentDate'].toString()),
        appointmentDate = map['appointmentDate'] != null
            ? DateTime.parse(map['appointmentDate'].toString())
            : null,
        conclusions =
            map.containsKey("conclusions") && map["conclusions"] != null
                ? List<ConclusionData>.from(map["conclusions"]
                    .map((item) => ConclusionData.fromJsonMap(item)))
                : null,
        createdTime = map['createdTime'] != null
            ? DateTime.parse(map['createdTime'].toString())
            : null;
  // department = map['department'] != null ? CommonTypeData.fromJsonMap(map['department']) : null;

  get id => _id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['appointmentTime'] = appointmentTime;
    data['channel'] = channel;
    data['note'] = note;
    data['code'] = code;
    data['conclusions'] = conclusions;
//		data['appointmentDate'] = appointmentDate.toIso8601String();
    data['appointmentDate'] =
        appointmentDate != null ? appointmentDate.toIso8601String() : null;
    data['createdTime'] =
        createdTime != null ? createdTime.toIso8601String() : null;
    return data;
  }
}
/*
class ShortAppointmentData {

  String _id;
  DateTime appointmentDate;
  String appointmentTime;

	ShortAppointmentData.fromJsonMap(Map<String, dynamic> map):
				_id = map["_id"],
				appointmentDate = DateTime.parse(map['appointmentDate'].toString()),
				appointmentTime = map['appointmentTime'];

  get id => _id;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_id'] = _id;
		data['appointmentTime'] = appointmentTime;
		data['appointmentDate'] = appointmentDate.toIso8601String();
		return data;
	}
}
*/

