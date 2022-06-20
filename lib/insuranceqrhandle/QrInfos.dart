import 'dart:core';

class QrInfos {
//  Context cxt;
  // ignore: non_constant_identifier_names
  String Hoten = "";
  String benhVienBanDau = "";
  String code = "";
  String donvi = "";
  bool gioitinh = true;
  String huyen = "";
  // ignore: non_constant_identifier_names
  int muc_huong = 0;
  String qrcode = "";
  String tinh = "";
  String type = "";
  // ignore: avoid_init_to_null
  DateTime ngaycap = null;
  // ignore: avoid_init_to_null
  DateTime ngaysinh = null;
  // ignore: avoid_init_to_null
  DateTime start5Years = null;
  // ignore: non_constant_identifier_names, avoid_init_to_null
  DateTime thoihan_den = null;
  // ignore: non_constant_identifier_names, avoid_init_to_null
  DateTime thoihan_tu = null;

  QrInfos();

//  ServiceData(this.id, this.name, this.price, this.numberOfDayUsed);

  QrInfos.fromJson(Map<String, dynamic> json)
      : Hoten = json['Hoten'],
        benhVienBanDau = json['benhVienBanDau'],
        code = json['code'],
        donvi = json['donvi'],
        gioitinh = json['gioitinh'],
        huyen = json['huyen'],
        muc_huong = json['muc_huong'],
        qrcode = json['qrcode'],
        tinh = json['tinh'],
        type = json['type'],
        ngaycap = DateTime.parse(json['ngaycap']),
        ngaysinh = DateTime.parse(json['ngaysinh']),
        start5Years = DateTime.parse(json['start5Years']),
        thoihan_den = DateTime.parse(json['thoihan_den']),
        thoihan_tu = DateTime.parse(json['thoihan_tu']);

//        claims = json['claims'];

  Map<String, dynamic> toJson() => {
        'Hoten': Hoten,
        'benhVienBanDau': benhVienBanDau,
        'code': code,
        'donvi': donvi,
        'gioitinh': gioitinh,
        'huyen': huyen,
        'muc_huong': muc_huong,
        'qrcode': qrcode,
        'tinh': tinh,
        'type': type,
        'ngaycap': ngaycap,
        'ngaysinh': ngaysinh,
        'start5Years': start5Years,
        'thoihan_den': thoihan_den,
        'thoihan_tu': thoihan_tu
      };
}
