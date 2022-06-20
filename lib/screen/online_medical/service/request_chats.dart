import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../../../utils/AppUtil.dart';
import '../../../utils/Constant.dart';
import '../model/chat_data.dart';

class RequestChats {
  Future<List<ChatContact>> requestGetContact(BuildContext context) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.prefAccessToken);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }
    final String url = '${dotenv.env['URL_CHAT_VIDEO']}/api/Chat/contact';
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'from': 0, 'count': 55}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<ChatContact> result = List<ChatContact>.from(
              data.map((it) => ChatContact.fromJsonMap(it)));
          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
        return null;
      }
    }
    await AppUtil.showPopup(
        context, 'Thông báo', 'Hệ thống đang bận, vui lòng gửi lại sau');
    return null;
  }

  Future<List<ChatContact>> requestGetContactSearch(
      BuildContext context, String search) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.prefAccessToken);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }
    final String url =
        '${dotenv.env['URL_CHAT_VIDEO']}/api/Chat/contact/search?search=$search';
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'from': 0, 'count': 55}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<ChatContact> result = List<ChatContact>.from(
              data.map((it) => ChatContact.fromJsonMap(it)));
          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
        return null;
      }
    }
    await AppUtil.showPopup(
        context, 'Thông báo', 'Hệ thống đang bận, vui lòng gửi lại sau');
    return null;
  }

  Future<List<ChatHistory>> requestGetHistory(
      BuildContext context, String contactId) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.prefAccessToken);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }
    final String url =
        '${dotenv.env['URL_CHAT_VIDEO']}/api/Chat/history/contact?contactId=$contactId';
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'from': 0, 'count': 100}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<ChatHistory> result = List<ChatHistory>.from(
              data.map((it) => ChatHistory.fromJsonMap(it)));
          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
        return null;
      }
    }
    await AppUtil.showPopup(
        context, 'Thông báo', 'Hệ thống đang bận, vui lòng gửi lại sau');
    return null;
  }

  Future<bool> requestCheckOnline(
      BuildContext context, String contactId) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.prefAccessToken);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }
    final String url =
        '${dotenv.env['URL_CHAT_VIDEO']}/api/Chat/contact/online?contactId=$contactId';
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'from': 0, 'count': 100}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return jsonResponse['data'];
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
        return null;
      }
    }
    await AppUtil.showPopup(
        context, 'Thông báo', 'Hệ thống đang bận, vui lòng gửi lại sau');
    return null;
  }
}
