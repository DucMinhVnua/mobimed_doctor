import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../utils/AppUtil.dart';

abstract class RegisterRepository {
  Future<QueryResult> requestRegister(
      BuildContext context,
      String fullName,
      String userName,
      String password,
      String phoneNumber,
      String gender,
      String birthday,
      String email);
}

class RegisterRepositoryImpl implements RegisterRepository {
  AppUtil appUtil = new AppUtil();

  @override
  Future<QueryResult> requestRegister(
      BuildContext context,
      String fullName,
      String userName,
      String password,
      String phoneNumber,
      String gender,
      String birthday,
      String email) async {
//    appUtil.showLoadingDialog(context);
    try {
      /*  ApiGraphQLCaDBController apiGraphQLController = new ApiGraphQLCaDBController();
      bool isConnectionAvailable = await apiGraphQLController.checkInternetConnection();
      if (isConnectionAvailable == true) {
        QueryResult queryResult = await apiGraphQLController.requestRegister(context, fullName, userName, password, phoneNumber, gender, birthday, email);
        return queryResult;
      }else {
        AppUtil.hideLoadingDialog(context);
        AppUtil.showPopup(context, "Thông báo",
            "Không có kết nối Internet. Vui lòng kiểm tra lại kết nối Internet và thử lại.");
        return null;
      }*/
    } catch (e) {
      AppUtil.showPrint('requestRegister Error: ' + e.toString());
    }

    /* try {
      APIController apiController = new APIController();
      QueryResult result =  await apiController.requestRegister(context, phoneNumber, password);
      log("Response requestRegister: " + result.data.toString());
//    final jsonResponse = json.decode(jsonString);

//      Constants constants = new Constants();
//      var responseData = appUtil.processResponse(result);
      return result;
//      int code = responseData.code;
//      String message = responseData.message;
//      Map data = responseData.data;
////    var json = jsonDecode(result.);
//
//      if (code == 0) {
//        //Register thành công
//        ResponseRegisterData userData = new ResponseRegisterData.fromJson(data);
////        log("Response requestRegister userData: " + json.encode(userData));
//        AppUtil.saveToSettting(
//            constants.PREF_ACCESSTOKEN, userData.oauth_token);
//        AppUtil.saveToSettting(
//            constants.PREF_USERNAME, userData.name);
//        AppUtil.showPrint("Register Name: " + userData.name);
//
////        appUtil.hideLoadingDialog(context);
//
////        Navigator.of(context)
////            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//      } else {
////        appUtil.hideLoadingDialog(context);
////        AppUtil.showPopup(context, "Thông báo", message);
//      }
    } on Exception catch (e) {
//      appUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestRegister Error: ' + e.toString());
    }*/
    return null;
  }
}
