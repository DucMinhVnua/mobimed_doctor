class OBWheelData{

  OBWheelData();

  DateTime dateCalculate;
  DateTime dateLMP;
  DateTime dateConception;
  DateTime dateEndTri1;
  DateTime dateEndTri2;
  DateTime dateDateEDD;

  OBWheelData.fromJsonMap(Map<String, dynamic> map):
        dateCalculate = map["dateCalculate"] != null ?DateTime.parse(map['dateCalculate'].toString()) : null,
        dateLMP = map["dateLMP"] != null ?DateTime.parse(map['dateLMP'].toString()) : null,
        dateConception = map["dateConception"] != null ?DateTime.parse(map['dateConception'].toString()) : null,
        dateEndTri1 = map["dateEndTri1"] != null ?DateTime.parse(map['dateEndTri1'].toString()) : null,
        dateEndTri2 = map["dateEndTri2"] != null ?DateTime.parse(map['dateEndTri2'].toString()) : null,
        dateDateEDD = map["dateDateEDD"] != null ?DateTime.parse(map['dateDateEDD'].toString()) : null
  ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateCalculate'] = dateCalculate.toIso8601String();
    data['dateLMP'] = dateLMP.toIso8601String();
    data['dateConception'] = dateConception.toIso8601String();
    data['dateEndTri1'] = dateEndTri1.toIso8601String();
    data['dateEndTri2'] = dateEndTri2.toIso8601String();
    data['dateDateEDD'] = dateDateEDD.toIso8601String();
    return data;
  }
}