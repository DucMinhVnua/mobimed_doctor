import '../utils/AppUtil.dart';
import 'AppointmentData.dart';
import 'BaseTypeData.dart';
import 'ConclusionData.dart';
import 'IndicationData.dart';
import 'PatientData.dart';
import 'ShortEmployeeData.dart';
import 'UserActionData.dart';

class MedicalSessionData {
  String _id;
  String code;
  String insuranceCode;
  String process;
  String reason;
  String sequence;
  bool terminated;
  String terminateReason;
  DateTime updatedTime;
  DateTime createdTime;
  String appointmentId;
  PatientData patient;
  // PatientData patientInfo;
  List<ShortIndicationData> indications;
  ShortUserActionData userAction;
  ShortEmployeeData creator;
  ShortAppointmentData appointment;
  List<ConclusionData> conclusions;

  String get id => _id;

  String getIndicationToString() {
    String strIndications = '';
    if (indications != null && indications.isNotEmpty) {
      AppUtil.showPrint(
          'Indication sequence: $sequence, length: ${indications.length}');
      for (var i = 0; i < indications.length; ++i) {
        final indication = indications[i];
        if (i == indications.length - 1) {
          if (indication.service != null) {
            strIndications += indication.service.name;
          }
        } else {
          if (indication.service != null) {
            strIndications += '${indication.service.name},\n ';
          }
        }
      }
    }
    return strIndications;
  }

  MedicalSessionData.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        code = map['code'],
        insuranceCode = map['insuranceCode'],
        process = map['process'],
        reason = map['reason'],
        sequence = map['sequence'],
        terminated = map['terminated'],
        terminateReason = map['terminateReason'],
        updatedTime = map['updatedTime'] != null
            ? DateTime.parse(map['updatedTime'])
            : null,
        createdTime = map['createdTime'] != null
            ? DateTime.parse(map['createdTime'])
            : null,
        appointmentId = map['appointmentId'],
        indications =
            map.containsKey('indications') && map['indications'] != null
                ? List<ShortIndicationData>.from(map['indications']
                    .map((item) => ShortIndicationData.fromJsonMap(item)))
                : null,
        conclusions =
            map.containsKey('conclusions') && map['conclusions'] != null
                ? List<ConclusionData>.from(map['conclusions']
                    .map((item) => ConclusionData.fromJsonMap(item)))
                : null,
        creator = map.containsKey('creator') && map['creator'] != null
            ? ShortEmployeeData.fromJsonMap(map['creator'])
            : null,
        patient = map.containsKey('patientInfo') && map['patientInfo'] != null
            ? PatientData.fromJsonMap(map['patientInfo'])
            : null,
        appointment =
            map.containsKey('appointment') && map['appointment'] != null
                ? ShortAppointmentData.fromJsonMap(map['appointment'])
                : null,
        userAction = map.containsKey('userAction') && map['userAction'] != null
            ? ShortUserActionData.fromJsonMap(map['userAction'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['insuranceCode'] = insuranceCode;
    data['process'] = process;
    data['reason'] = reason;
    data['sequence'] = sequence;
    data['terminated'] = terminated;
    data['terminateReason'] = terminateReason;
    data['updatedTime'] = updatedTime.toIso8601String();
    data['createdTime'] = createdTime.toIso8601String();
    data['appointmentId'] = appointmentId;
    data['conclusions'] = conclusions;
    data['creator'] = creator == null ? null : creator.toJson();
    data['patientInfo'] = patient == null ? null : patient.toJson();
    data['indications'] = indications == null ? null : indications;
    data['userAction'] = userAction == null ? null : userAction.toJson();
    data['appointment'] = appointment == null ? null : appointment.toJson();
    return data;
  }
}

class ShortMedicalSessionData {
  String _id;
  String code;
  String patientCode;
  List<ConclusionData> conclusions;
  PatientData patient;
  List<ShortIndicationData> indications;
  BaseTypeData doctor;
  ShortAppointmentData appointment;

  String get id => _id;

  String getIndicationToString() {
    String strIndications = '';
    if (indications != null && indications.isNotEmpty) {
//      AppUtil.showPrint("Indication sequence: $sequence, length: " +
//          indications.length.toString());
      for (var i = 0; i < indications.length; ++i) {
        final indication = indications[i];
        if (i == indications.length - 1) {
          if (indication.service != null) {
            strIndications += indication.service.name;
          }
        } else {
          if (indication.service != null) {
            strIndications += '${indication.service.name},\n ';
          }
        }
      }
    }
    return strIndications;
  }

  ShortMedicalSessionData.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        code = map['code'],
        patientCode = map['patientCode'],
        conclusions =
            map.containsKey('conclusions') && map['conclusions'] != null
                ? List<ConclusionData>.from(map['conclusions']
                    .map((item) => ConclusionData.fromJsonMap(item)))
                : null,
        indications =
            map.containsKey('indications') && map['indications'] != null
                ? List<ShortIndicationData>.from(map['indications']
                    .map((item) => ShortIndicationData.fromJsonMap(item)))
                : null,
//				indications = map.containsKey("indications") && map["indications"] != null ? List<CommonTypeData>.from(map["indications"].map(item) => CommonTypeData.fromJsonMap(item)) : null,
        doctor = map.containsKey('doctor') && map['doctor'] != null
            ? BaseTypeData.fromJsonMap(map['doctor'])
            : null,
        patient = map.containsKey('patientInfo') && map['patientInfo'] != null
            ? PatientData.fromJsonMap(map['patientInfo'])
            : null,
        appointment =
            map.containsKey('appointment') && map['appointment'] != null
                ? ShortAppointmentData.fromJsonMap(map['appointment'])
                : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['code'] = code;
    data['patientCode'] = patientCode;
    data['conclusions'] = conclusions;
    data['doctor'] = doctor == null ? null : doctor.toJson();
    data['patientInfo'] = patient == null ? null : patient.toJson();
    data['indications'] = indications == null ? null : indications;
    data['appointment'] = appointment == null ? null : appointment.toJson();
    return data;
  }
}
