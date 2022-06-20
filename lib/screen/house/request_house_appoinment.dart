import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'house_appoinmrnt_data.dart';

class RequestHouseAppoinment {
  Future<HomeBookHistoryData> requestGetDetail(
      BuildContext context, String id) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/appointment/$id';

    final response = await post(Uri.parse(url), headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final String jsonData = json.encode(jsonResponse['data']);
          final HomeBookHistoryData result =
              HomeBookHistoryData.fromJsonMap(jsonDecode(jsonData));

          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<String> requestGetValidateQR(
      BuildContext context, String qrCode) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/appointment/validateQR';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'qrCode': qrCode}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        final String data = jsonResponse['data'];
        if (code == 0) {
          return data;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<List<HomeBookHistoryData>> requestGetMyAppointment(
      BuildContext context) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/appointment/myAppointment';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'from': 0, 'count': 30}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<HomeBookHistoryData> result =
              List<HomeBookHistoryData>.from(
                  data.map((it) => HomeBookHistoryData.fromJsonMap(it)));

          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }
}
