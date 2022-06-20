class ResultCallBackData {
  String _id;
  String data1;
  String data2;

  ResultCallBackData();
//  ResultCallBackData(this._id, this.data1, this.data2);

  String get id => _id;

  ResultCallBackData.fromJsonMap(Map<String, dynamic> map):
        _id = map["_id"] != null ? map["_id"] :  "",
        data1 = map["data1"] != null ? map["data1"] :  "",
        data2 = map["data2"] != null ? map["data2"] :  ""
  ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['data1'] = data1;
    data['data2'] = data2;
    return data;
  }
}