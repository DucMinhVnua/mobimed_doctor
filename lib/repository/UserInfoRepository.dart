import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../controller/ApiGraphQLControllerQuery.dart';
import '../utils/AppUtil.dart';

abstract class UserInfoRepository {
  Future<QueryResult> requestUserInfo(BuildContext context);
}

class UserInfoRepositoryImpl implements UserInfoRepository {
  AppUtil appUtil = AppUtil();

  @override
  Future<QueryResult> requestUserInfo(BuildContext context) async {
//    appUtil.showLoadingDialog(context);
    try {
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();
      final QueryResult result =
          await apiController.requestGetAccountInfo(context);
      log('Response requestGetAccountInfo: ${result.data}');
      return result;
    } on Exception catch (e) {
//      appUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetAccountInfo Error: $e');
    }

    return null;
  }
}
