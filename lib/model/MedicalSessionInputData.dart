/*
class MedicalSessionInputData {
  String _id;
  String appointmentId;
  String code;
  DateTime createdTime;
  DateTime updatedTime;
  String reason; // 1 là nam, 2 là nữ
  String patientCode;
  String insuranceCode;
  bool terminated;
  String terminateReason;
  String process;
  EmployeeShortInfoInputData creator;

  String get id => _id;

  MedicalSessionInputData();

  */
/*
  1 là người bệnh đến mà không qua đăng ký online em chỉ cần 2 thông tin đó
  2 người bệnh đến mà có qua đăng ký online thì sẽ bổ xung cho anh cái appointmentId nhé
  trường hợp 2 cũng chỉ khác trường hợp 1 là có dữ liệu appointmentId thôi, nhưng mà về UI/UX là phải có thêm flow load thông tin đặt khám online
   *//*

  MedicalSessionInputData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        appointmentId = map["appointmentId"],
        code = map["code"],
        updatedTime = map["updatedTime"] != null
            ? DateTime.parse(map["updatedTime"].toString())
            : null,
        createdTime = map["createdTime"] != null
            ? DateTime.parse(map["createdTime"].toString())
            : null,
        reason = map["reason"],
        patientCode = map["patientCode"],
        insuranceCode = map["insuranceCode"],
        terminated = map["terminated"],
        terminateReason = map["terminateReason"],
        process = map["process"],
        creator = map.containsKey("creator") && map["creator"] != null ? EmployeeShortInfoInputData.fromJsonMap(map["creator"]) : null;


  Map<String, dynamic> toJson() {
    return {
      "_id": this._id,
      "appointmentId": this.appointmentId,
      "code": this.code,
      "reason": this.reason,
      "patientCode": this.patientCode,
      "insuranceCode": this.insuranceCode,
      "terminated": this.terminated,
      "terminateReason": this.terminateReason,
      "process": this.process,
      "creator": this.creator,
    };
  }

}
class EmployeeShortInfoInputData {
//  String _id;
  String fullName, code;
  String departmentName, departmentId;
  String work;

  EmployeeShortInfoInputData();

//  String get id => _id;

  EmployeeShortInfoInputData.fromJsonMap(Map<String, dynamic> map):
//        _id = map["_id"],
        fullName = map["fullName"],
        code = map["code"],
        departmentName = map["departmentName"],
        departmentId = map["departmentId"],
        work = map["work"]
  ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['_id'] = _id;
    data['fullName'] = fullName;
    data['code'] = code;
    data['departmentName'] = departmentName;
    data['departmentId'] = departmentId;
    data['work'] = work;
    return data;
  }
}
*/
