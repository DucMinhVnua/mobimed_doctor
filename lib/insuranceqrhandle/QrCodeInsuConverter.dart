import 'dart:convert';
import 'dart:core';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/utils/AppUtil.dart';

import 'QrInfos.dart';

enum QRTYPE { INVALID, FULL_INFO, SHORT_INFO }

class QrCodeInsuConverter {
  QRTYPE getType(String str) {
    var split = str.split("|");
    if (split.length >= 15) {
//  if (split.length == 15 && str.trim().endsWith("\$")) {
      return QRTYPE.FULL_INFO;
    }
    if (split.length == 9) {
      return QRTYPE.SHORT_INFO;
    }
    return QRTYPE.INVALID;
  }

  AppUtil appUtil = new AppUtil();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  QrInfos convertFromCode(String str) {
    bool z = true;
    var split;
    QrInfos qrInfos;
    switch (getType(str)) {
      case QRTYPE.INVALID:
        return null;
      case QRTYPE.FULL_INFO:
        split = str.split("|");
        qrInfos = new QrInfos();
        try {
          //      qrInfos = new QrInfos(context);
          qrInfos.qrcode = str;
          qrInfos.code = split[0].trim();
//        qrInfos.Hoten = (base32.decode(split[1].trim()));
          qrInfos.Hoten = (hexToString(split[1].trim()));
          qrInfos.ngaysinh = (dateFormat.parse(split[2].trim()));
          if (split[3].trim().compareTo("1") != 0) {
            z = false;
          }
          qrInfos.gioitinh = (z); //true -- Nam
          qrInfos.donvi = (hexToString(split[4].trim()));
          qrInfos.benhVienBanDau = (split[5].trim());
          qrInfos.thoihan_tu =
              (split[6].trim() != null && split[6].toString().length > 5)
                  ? (dateFormat.parse((split[6].trim())))
                  : null; //(dateFormat.parse((split[6].trim())));
          qrInfos.thoihan_den =
              (split[7].trim() != null && split[7].toString().length > 5)
                  ? (dateFormat.parse((split[7].trim())))
                  : null;
          qrInfos.ngaycap =
              (split[8].trim() != null && split[8].toString().length > 5)
                  ? (dateFormat.parse((split[8].trim())))
                  : null; //(dateFormat.parse((split[8].trim())));
          qrInfos.start5Years =
              (split[12].trim() != null && split[12].toString().length > 5)
                  ? (dateFormat.parse((split[12].trim())))
                  : null; // (dateFormat.parse((split[12].trim())));
          var ssss = hexToString(split[13].trim());
          AppUtil.showLog("Qrinfos: " + qrInfos.toJson().toString());
        } on Exception catch (e) {
          AppUtil.showPrint('convertFromCode FULL Error: ' + e.toString());
        }

        return qrInfos;
      case QRTYPE.SHORT_INFO:
        split = str.split("|");
        qrInfos = new QrInfos();
        try {
          //      qrInfos = new QrInfos(context);
          qrInfos.qrcode = (str);
          qrInfos.code = (split[0].trim());
          qrInfos.Hoten = (hexToString(split[1].trim()));
          qrInfos.ngaysinh = (dateFormat.parse((split[2].trim())));
          if (split[3].trim().compareTo("1") != 0) {
            z = false;
          }
          qrInfos.gioitinh = (z);
          qrInfos.benhVienBanDau = (split[4].trim());
          qrInfos.thoihan_tu =
              (split[5].trim() != null && split[5].toString().length > 5)
                  ? (dateFormat.parse((split[5].trim())))
                  : null; //(dateFormat.parse((split[5].trim())));
          qrInfos.thoihan_den =
              (split[6].trim() != null && split[6].toString().length > 5)
                  ? (dateFormat.parse((split[6].trim())))
                  : null; // (dateFormat.parse((split[6].trim())));
          qrInfos.ngaycap =
              (split[7].trim() != null && split[7].toString().length > 5)
                  ? (dateFormat.parse((split[7].trim())))
                  : null; //(dateFormat.parse((split[7].trim())));
        } on Exception catch (e) {
          AppUtil.showPrint('convertFromCode SHORT Error: ' + e.toString());
        }
        AppUtil.showLog("Qrinfos: " + qrInfos.toJson().toString());
        return qrInfos;
      default:
        return null;
    }
  }

  String hexToString(String hexInput) {
    String outStr = "";
    try {
      outStr = utf8.decode(HEX
          .decode(hexInput)); //.map((c)=> String.fromCharCode(c)).toString());
    } on Exception catch (e) {
      e.toString();
    }
    return outStr;
  }

// public static String getStringFromHex(String str) {
//   ByteBuffer allocate = ByteBuffer.allocate(str.length() / 2);
//   int i = 0;
//   while (i < str.length()) {
//     int i2 = i + 2;
//     allocate.put((byte) Integer.parseInt(str.substring(i, i2), 16));
//   i = i2;
//   }
//   allocate.rewind();
//   return Charset.forName("UTF-8").decode(allocate).toString();
// }
}
