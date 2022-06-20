
class ResponseDataWithPages{
  String message;
  int code;
  int page;
  int pages;
  dynamic data;

  ResponseDataWithPages(this.code, this.message, this.data, this.page, this.pages);

  ResponseDataWithPages.fromJson(Map<String, dynamic> map):
        message = map["message"],
        code = map["code"],
        data = map["data"],
        page = map["page"],
        pages = map["pages"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['code'] = code;
    data['data'] = data;
    data['page'] = page;
    data['pages'] = pages;
    return data;
  }
}