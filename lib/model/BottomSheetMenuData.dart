class BottomSheetMenuData {
  String _id;
  String title, image;
  int menuid;

  BottomSheetMenuData(this._id, this.title, this.image, this.menuid);

  String get id => _id;

  BottomSheetMenuData.fromJsonMap(Map<String, dynamic> map):
        _id = map["_id"],
        title = map["title"],
        image = map["image"],
        menuid = map["menuid"]
      ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['title'] = title;
    data['image'] = image;
    data['menuid'] = menuid;
    return data;
  }
}