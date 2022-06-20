import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:DoctorApp/controller/BaseApiGraphQLController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/AppUtil.dart';

class ApiConfig {
//  static String BASE_API_URL = "https://api.mecare.ehospital.tech";
//  String GRAPHAPI = Constants.BASE_API_URL + ";
//  String LOGINHOST = "https://auth.mecare.ehospital.tech/identity/connect/token";
//  String LOGINHOST = "https://auth.bvpshp.ehospital.tech/identity/connect/token";
//  String UPLOADURL = Constants.BASE_API_URL_CADB + "/stream/upload";
//  String FILE_PREVIEW_URL = Constants.BASE_API_URL_CADB + "/stream/upload?load=";
//  String AVATAR_PREVIEW_URL = "https://auth.app.benhvienphusanhanoi.vn/stream/upload?load=";
  String clientId = "admin.client";
  String clientSecret = "telehub-admin-secret";
  // ignore: non_constant_identifier_names
  String grant_type = "password";
  String scope = 'api profile openid';
}

abstract class LoginRepository {
  Future<Response> requestLogin(
      BuildContext context, String phoneNumber, String password);
}

// implements để có thể truy cập vào requestLogin của đối tượng cha LoginRepository
class LoginRepositoryImpl implements LoginRepository {
  AppUtil appUtil = new AppUtil();

  @override
  Future<Response> requestLogin(
      BuildContext context, String email, String password) async {
    AppUtil.showLoadingDialog(context);
    try {
      BaseApiGraphQLController apiGraphQLController =
          new BaseApiGraphQLController("");
      bool isConnectionAvailable =
          await apiGraphQLController.checkInternetConnection();
      if (isConnectionAvailable == true) {
        // set up POST request arguments
        ApiConfig apiConfig = new ApiConfig();
        String url = dotenv.env['BASE_API_URL_LOGIN'];

        AppUtil.showLog("requestLogin url: " + url);
        final headers = {"Content-Type": "application/x-www-form-urlencoded"};
        Map<String, dynamic> body = {
          'grant_type': apiConfig.grant_type,
          'username': email,
          'password': password,
          'client_secret': apiConfig.clientSecret,
          'client_id': apiConfig.clientId,
          // ignore: equal_keys_in_map
          'username': email
        };
//      String jsonBody = json.encode(body);
        final encoding = Encoding.getByName('utf-8');

        Response response = await post(
          Uri.parse(url),
          headers: headers,
          body: body,
          encoding: encoding,
        );
        if (response != null) {
          log("Login response: " + response.body);
          final jsonRespone = jsonDecode(response.body);
          if (jsonRespone != null &&
              jsonRespone.containsKey("error") &&
              jsonRespone["error"] == 'invalid_grant') {
            AppUtil.hideLoadingDialog(context);
            AppUtil.showPopup(
                context, "Thông báo", "Sai tên đăng nhập hoặc mật khẩu");
          }
        } else {
          log("Login response NULL");
        }
        return response;
      } else {
        AppUtil.hideLoadingDialog(context);
        AppUtil.showPopup(context, "Thông báo",
            "Không có kết nối Internet. Vui lòng kiểm tra lại kết nối Internet và thử lại.");
        return null;
      }
    } catch (e) {
      AppUtil.showPrint('requestLogin Error: ' + e.toString());
    }
    return null;
  }
}
