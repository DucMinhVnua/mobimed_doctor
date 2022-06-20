import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../../../utils/AppUtil.dart';
import '../../../utils/Constant.dart';
import 'house_appointment_book_data.dart';

class RequestHouseBook {
  Future<int> requestServer(BuildContext context, HomeBook body) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.prefAccessToken);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }
    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/user/appointment/booking';
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode(body.toJson()));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
        return -1;
      }
    }
    await AppUtil.showPopup(
        context, 'Thông báo', 'Hệ thống đang bận, vui lòng gửi lại sau');
    return null;
  }
}
