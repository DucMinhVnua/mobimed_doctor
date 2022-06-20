import 'package:DoctorApp/model/AppointmentData.dart';
import 'package:DoctorApp/model/BaseTypeData.dart';
import 'package:DoctorApp/model/IndicationItem.dart';
import 'package:DoctorApp/model/PatientData.dart';
import 'package:DoctorApp/model/ShortEmployeeData.dart';

class IndicationData {
  String _id;
  String code;
  String sessionCode;
  String note;
  String state;
  String name;
  String result;
  bool paid;
  DateTime confirmedTime;
  DateTime updatedTime;
  DateTime createdTime;
  PatientData patient;
  BaseTypeData department;
  BaseTypeData clinic;
  BaseTypeData service;
  ShortEmployeeData doctor;
  ShortAppointmentData appointment;
  List<IndicationFiles> files;

  String get id => _id;

  IndicationData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        code = map["code"],
        sessionCode = map["sessionCode"],
        note = map["note"],
        state = map["state"],
        name = map["name"],
        result = map["result"],
        files = map.containsKey("files") && map["files"] != null
            ? List<IndicationFiles>.from(
                map["files"].map((item) => IndicationFiles.fromJsonMap(item)))
            : null,
        paid = map["paid"],
        confirmedTime = DateTime.parse(map["confirmedTime"]),
        updatedTime = DateTime.parse(map["updatedTime"]),
        createdTime = DateTime.parse(map["createdTime"]),
        appointment =
            map.containsKey("appointment") && map["appointment"] != null
                ? ShortAppointmentData.fromJsonMap(map["appointment"])
                : null,
        patient = map.containsKey("patientInfo") && map["patientInfo"] != null
            ? PatientData.fromJsonMap(map["patientInfo"])
            : null,
        service = map.containsKey("service") && map["service"] != null
            ? BaseTypeData.fromJsonMap(map["service"])
            : null,
        department = map.containsKey("department") && map["department"] != null
            ? BaseTypeData.fromJsonMap(map["department"])
            : null,
        clinic = map.containsKey("clinic") && map["clinic"] != null
            ? BaseTypeData.fromJsonMap(map["clinic"])
            : null,
        doctor = map.containsKey("doctor") && map["doctor"] != null
            ? ShortEmployeeData.fromJsonMap(map["doctor"])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['files'] = files;
    data['sessionCode'] = sessionCode;
    data['note'] = note;
    data['state'] = state;
    data['name'] = name;
    data['result'] = result;
    data['paid'] = paid;
    data['confirmedTime'] = confirmedTime.toIso8601String();
    data['updatedTime'] = updatedTime.toIso8601String();
    data['createdTime'] = createdTime.toIso8601String();
    data['service'] = service == null ? null : service.toJson();
    data['patientInfo'] = patient == null ? null : patient.toJson();
    data['department'] = department == null ? null : department.toJson();
    data['clinic'] = clinic == null ? null : clinic.toJson();
    data['doctor'] = doctor == null ? null : doctor.toJson();
    data['appointment'] = appointment == null ? null : appointment.toJson();
    return data;
  }
}

class ShortIndicationData {
  String _id;
  String code;
  String note;
  String patientCode;
  PatientData patient;
  BaseTypeData department;
  BaseTypeData clinic;
  BaseTypeData service;
  ShortEmployeeData doctor;

  String get id => _id;

  ShortIndicationData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        code = map["code"],
        note = map["note"],
        patientCode = map["patientCode"],
        patient = map.containsKey("patient") && map["patient"] != null
            ? PatientData.fromJsonMap(map["patient"])
            : null,
        service = map.containsKey("service") && map["service"] != null
            ? BaseTypeData.fromJsonMap(map["service"])
            : null,
        department = map.containsKey("department") && map["department"] != null
            ? BaseTypeData.fromJsonMap(map["department"])
            : null,
        clinic = map.containsKey("clinic") && map["clinic"] != null
            ? BaseTypeData.fromJsonMap(map["clinic"])
            : null,
        doctor = map.containsKey("doctor") && map["doctor"] != null
            ? ShortEmployeeData.fromJsonMap(map["doctor"])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['note'] = note;
    data['patientCode'] = patientCode;
    data['service'] = service == null ? null : service.toJson();
    data['patient'] = patient == null ? null : patient.toJson();
    data['department'] = department == null ? null : department.toJson();
    data['clinic'] = clinic == null ? null : clinic.toJson();
    data['doctor'] = doctor == null ? null : doctor.toJson();
    return data;
  }
}
