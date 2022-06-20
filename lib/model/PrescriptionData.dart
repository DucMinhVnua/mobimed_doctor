import 'package:DoctorApp/model/AppointmentData.dart';
import 'package:DoctorApp/model/MedicalSessionData.dart';
import 'package:DoctorApp/model/PatientData.dart';
import 'package:DoctorApp/model/ShortEmployeeData.dart';

class PrescriptionData {
  String _id;
  String patientCode;
  DateTime createdTime;
  ShortEmployeeData creator;
  PatientData patient;
//  List<String> images;
  List<String> imageUrls;
  ShortAppointmentData appointment;
  ShortMedicalSessionData medicalSession;
  List<DrugData> drugs;

  String get id => _id;

  PrescriptionData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        patientCode = map["patientCode"],
        createdTime = map["createdTime"] != null
            ? DateTime.parse(map["createdTime"].toString())
            : null,
//        images = map.containsKey("images") && map["images"] != null ? map["images"].cast<String>() : null,
        imageUrls = map.containsKey("image_urls") && map["image_urls"] != null
            ? map["image_urls"].cast<String>()
            : null,
        patient = map.containsKey("patient") && map["patient"] != null
            ? PatientData.fromJsonMap(map["patient"])
            : null,
        appointment =
            map.containsKey("appointment") && map["appointment"] != null
                ? ShortAppointmentData.fromJsonMap(map["appointment"])
                : null,
        medicalSession =
            map.containsKey("medical_session") && map["medical_session"] != null
                ? ShortMedicalSessionData.fromJsonMap(map["medical_session"])
                : null,
        drugs = map.containsKey("drugs") && map["drugs"] != null
            ? List<DrugData>.from(
                map["drugs"].map((item) => DrugData.fromJsonMap(item)))
            : null,
        creator = map.containsKey("creator") && map["creator"] != null
            ? ShortEmployeeData.fromJsonMap(map["creator"])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['patientCode'] = patientCode;
    data['creator'] = creator == null ? null : creator.toJson();
    data['createdTime'] =
        createdTime == null ? null : createdTime.toIso8601String();
    data['patient'] = patient == null ? null : patient.toJson();
    data['appointment'] = appointment == null ? null : appointment.toJson();
    data['medical_session'] =
        medicalSession == null ? null : medicalSession.toJson();
//    data['images'] = images == null ? null : images;
    data['image_urls'] = imageUrls == null ? null : imageUrls;
    data['drugs'] = drugs == null ? null : drugs;

    return data;
  }
}

class DrugData {
  String _id;
  String name;
  String code;
  String instruction;
  String unit;
  double amount;

  String get id => _id;

  DrugData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        name = map["name"],
        code = map["code"],
        instruction = map["instruction"],
        amount = map["amount"],
        unit = map["unit"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    data['code'] = code;
    data['instruction'] = instruction;
    data['unit'] = unit;
    data['amount'] = amount;
    return data;
  }
}
