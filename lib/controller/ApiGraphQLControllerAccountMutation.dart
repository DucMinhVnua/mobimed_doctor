import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' show QueryResult;
import 'package:http/http.dart';
import 'package:DoctorApp/controller/BaseApiGraphQLController.dart';
import 'package:DoctorApp/controller/MutationRequests.dart';
import 'package:DoctorApp/model/UserInfoInputData.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/Constant.dart';
import '../utils/AppUtil.dart';
import 'dart:async';

class ApiGraphQLControllerAccountMutation extends BaseApiGraphQLController {
  ApiGraphQLControllerAccountMutation()
      : super(dotenv.env['BASE_API_URL_GRAPHQL_ACCOUNT'] + '/graphql');

  int pageSize = 19;

  Constants constants = new Constants();
  AppUtil appUtil = new AppUtil();

  Future<QueryResult> requestUploadFIle(
      BuildContext context, MultipartFile file) async {
    ApiGraphQLControllerAccountMutation apiController =
        new ApiGraphQLControllerAccountMutation();
    QueryResult result = await apiController.getMutation(
        context, mutationUploadFile,
        variables: <String, dynamic>{'file': file});
    return result;
  }

  Future<QueryResult> requestUpdateProfile(
      BuildContext context, UserInfoInputData data) async {
    QueryResult result = await getMutation(context, mutationUdateProfile,
        variables: <String, dynamic>{'account': data});
    AppUtil.showPrint(
        "APIController requestUpdateProfile Response: " + result.toString());
    return result;
  }
}
