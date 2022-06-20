import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'house_appoinmrnt_data.dart';

class RequesstHouseMedical {
  Future<MedicalTicket> requestTicketAdd(
      BuildContext context, String appointmentId, String patientId) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/add';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          'appointmentId': appointmentId,
          'patientId': patientId,
          'doctorInfos': []
        }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final String jsonData = json.encode(jsonResponse['data']);
          final MedicalTicket result =
              MedicalTicket.fromJsonMap(jsonDecode(jsonData));

          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<MedicalTicket> requestTicketInfo(
      BuildContext context, String idTicket) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/$idTicket';

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
          final MedicalTicket result =
              MedicalTicket.fromJsonMap(jsonDecode(jsonData));

          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<MedicalTicketPrice> requestTicketInfoPrice(
      BuildContext context, String idTicket) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/getPrice/$idTicket';

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
          final MedicalTicketPrice result =
              MedicalTicketPrice.fromJsonMap(jsonDecode(jsonData));

          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<int> requestTicketFinish(BuildContext context, String idTicket) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/finish/$idTicket';

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
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<List<TicketIndication>> requestGetIndication(BuildContext context,
      String keySearch, int type, int from, int count) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/his/searchIndication';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          'text': keySearch,
          'type': type,
          'paging': {'from': from, 'count': count}
        }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<TicketIndication> result = List<TicketIndication>.from(
              data.map((it) => TicketIndication.fromJsonMap(it)));

          return result;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return null;
  }

  Future<int> requestTicketAddIndication(
      BuildContext context, String ticketId, List<String> indicationIds) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/addIndications';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json
            .encode({'ticketId': ticketId, 'indicationIds': indicationIds}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }

  Future<int> requestTicketAddService(BuildContext context, String ticketId,
      List<ServiceDataInput> data) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/addServices';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          'ticketId': ticketId,
          'services': data.map((it) => it.toJson()).toList()
        }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }

  Future<int> requestTicketRemoveIndication(
      BuildContext context, String indicationId) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/indication/terminate';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'indicationId': indicationId}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }

  Future<int> requestTicketUpdateHealth(
      BuildContext context, String idTicket, HealthData healthData) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/updateHealthData';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          'ticketId': idTicket,
          'healthData': {
            'height': healthData.height,
            'weight': healthData.weight,
            'bodyTemperature': healthData.bodyTemperature,
            'pulseRate': healthData.pulseRate,
            'respirationRate': healthData.respirationRate,
            'bloodPressure': healthData.bloodPressure
          }
        }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }

  Future<int> requestTicketUpdateNote(
      BuildContext context, String idTicket, String data) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/updateNoteResult';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'ticketId': idTicket, 'note': data}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }

  Future<List<HomeMedicalServiceData>> requestGetServicesSearch(
      BuildContext context, String keySearch) async {
    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/user/services/getServices/$keySearch';

    // final token = AppUtil.getFromSetting(Constants.prefAccessToken);
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
        body: json.encode({'fromId': '', 'from': 0, 'count': 55}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<HomeMedicalServiceData> result =
              List<HomeMedicalServiceData>.from(
                  data.map((it) => HomeMedicalServiceData.fromJsonMap(it)));
          return result;
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      }
    }
    return null;
  }

  Future<List<HomeMedicalPackData>> requestGetPackSearch(
      BuildContext context, String keySearch) async {
    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/user/services/getServicePacks/$keySearch';

    // final token = AppUtil.getFromSetting(Constants.prefAccessToken);
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
        body: json.encode({'fromId': '', 'from': 0, 'count': 55}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          final List<dynamic> data = jsonResponse['data'];
          final List<HomeMedicalPackData> result =
              List<HomeMedicalPackData>.from(
                  data.map((it) => HomeMedicalPackData.fromJsonMap(it)));
          return result;
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      }
    }
    return null;
  }

  Future<HomeMedicalServiceData> requestGetServiceInfo(
      BuildContext context, String id) async {
    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/user/services/getService/$id';

    // final token = AppUtil.getFromSetting(Constants.prefAccessToken);
    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
        body: json.encode({}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          // final String data = jsonResponse['data'];
          // final HomeMedicalServiceData result =
          //     HomeMedicalServiceData.fromJsonMap(jsonDecode(data));

          final String jsonData = json.encode(jsonResponse['data']);
          final HomeMedicalServiceData result =
              HomeMedicalServiceData.fromJsonMap(jsonDecode(jsonData));
          return result;
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      }
    }
    return null;
  }

  Future<int> requestUpdateServiceTicket(BuildContext context, String serviceId,
      String result, List<String> fileIds) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/indication/updateResultServices';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          'serviceId': serviceId,
          'result': result,
          'fileIds': fileIds ?? []
        }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }

  Future<int> requestUpdateFileIdsTicket(
      BuildContext context, String ticketId, List<String> fileIds) async {
    final String accessToken =
        await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
    if (accessToken == null || accessToken == '') {
      AppUtil.showPrint('APIController requestGetAccountInfo accessToken NULL');
      return null;
    }

    final String url =
        '${dotenv.env['BASE_URL_SERVER']}homemedical/admin/ticket/updateFileIds';

    final response = await post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({'ticketId': ticketId, 'fileIds': fileIds ?? []}));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        final int code = jsonResponse['code'];
        final String message = jsonResponse['message'];
        if (code == 0) {
          return code;
        }
        await AppUtil.showPopup(context, 'Thông báo', message);
      }
    }

    return -1;
  }
}
