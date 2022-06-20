import 'package:DoctorApp/model/PatientData.dart';

class AppointmentInput {
  String _id;
  DateTime appointmentDate;
  String appointmentTime;
  String patientCode;
  String departmentId;
  String serviceDemandId;
  String channel;
  String note;
  DateTime createdTime;
  PatientData inputPatient;

  AppointmentInput();

  AppointmentInput.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        note = map["note"],
        appointmentTime = map["appointmentTime"],
        patientCode = map["patientCode"],
        departmentId = map["departmentId"],
        serviceDemandId = map["serviceDemandId"],
        channel = map["channel"],
        appointmentDate = map['appointmentDate']
            ? DateTime.parse(map['appointmentDate'].toString())
            : null,
        inputPatient = map['inputPatient']
            ? PatientData.fromJsonMap(map['inputPatient'])
            : null,
        createdTime = map['createdTime']
            ? DateTime.parse(map['createdTime'].toString())
            : null;

  // ignore: unnecessary_getters_setters
  get id => _id;

  // ignore: unnecessary_getters_setters
  set id(String newID) {
    _id = newID;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['appointmentTime'] = appointmentTime;
    data['patientCode'] = patientCode;
    data['departmentId'] = departmentId;
    data['serviceDemandId'] = serviceDemandId;
    data['channel'] = channel;
    data['note'] = note;
    data['inputPatient'] = inputPatient.toJson();
    data['appointmentDate'] = appointmentDate.toIso8601String();
    return data;
  }
}
