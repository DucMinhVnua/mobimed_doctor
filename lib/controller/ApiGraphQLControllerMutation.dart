import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' show QueryResult;
import 'package:http/http.dart';
import 'package:DoctorApp/controller/BaseApiGraphQLController.dart';
import 'package:DoctorApp/controller/MutationRequests.dart';
import 'package:DoctorApp/controller/QueryRequest.dart';
import 'package:DoctorApp/model/AppointmentInput.dart';
import 'package:DoctorApp/model/PatientData.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/Constant.dart';
import '../utils/AppUtil.dart';
import 'dart:async';
import 'package:DoctorApp/model/DeviceInput.dart';

class ApiGraphQLControllerMutation extends BaseApiGraphQLController {
  ApiGraphQLControllerMutation()
      : super(dotenv.env['BASE_API_URL_GRAPHQL'] + '/graphql');

  int pageSize = 19;

  Constants constants = new Constants();
  AppUtil appUtil = new AppUtil();

  Future<QueryResult> requestRegister(
      BuildContext context,
      String fullName,
      String userName,
      String password,
      String phoneNumber,
      String gender,
      String birthday,
      String email) async {
    QueryResult result = await getMutation(context, mutationRegister,
        variables: <String, dynamic>{
          'userName': userName,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'password': password,
          'gender': gender,
          'birthday': birthday,
          'email': email
        });
//        variables: <String, dynamic>{'page': page, 'pageSize': pageSize, 'sorted':[{'id': '', 'desc': true}], 'filtered':[{'id': '', 'value': '', 'ne':true}]});
    AppUtil.showPrint("APIController requestRegister Response: $result");
//    printWrapped("APIController requestLogin Response: " + result.toString());

    if (result.exception != null) {
      AppUtil.showLog("Response requestSaveArticleMedia exception: " +
          result.exception.toString());
    }
    return result;
  }

  Future<QueryResult> requestRegisterDevice(
      BuildContext context, DeviceInput appointment) async {
    QueryResult result = await getMutation(context, mutationRegisterDevice,
        variables: <String, dynamic>{'data': appointment});
//    String msg = (result != null) ? jsonEncode(result) : "";
//    AppUtil.showPrint(
//        "APIController requestRegisterDevice Response: " + msg);

    if (result.exception != null) {
      AppUtil.showLog("Response requestRegisterDevice exception: " +
          result.exception.toString());
    }
    return result;
  }

  Future<QueryResult> requestUploadFIle(
      BuildContext context, MultipartFile file) async {
    ApiGraphQLControllerMutation apiController =
        new ApiGraphQLControllerMutation();
    QueryResult result = await apiController.getMutation(
        context, mutationUploadFile,
        variables: <String, dynamic>{'file': file});
    return result;
  }

  Future<QueryResult> requestUpdatePatient(
      BuildContext context, PatientData data) async {
    QueryResult result = await getMutation(context, mutationUpdatePatient,
        variables: <String, dynamic>{'data': data});
    AppUtil.showPrint(
        "APIController requestUpdatePatient Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestCreateAppointmentOffline(
      BuildContext context, String patientCode, String reason) async {
    QueryResult result = await getMutation(
        context, mutationCreateAppointmentOffline, variables: <String, dynamic>{
      'patientCode': patientCode,
      'reason': reason
    });
    AppUtil.showPrint(
        "APIController requestCreateAppointmentOffline Response: " +
            result.toString());
    return result;
  }

  Future<QueryResult> requestChangePassword(
      BuildContext context, String oldPw, String newPw) async {
    QueryResult result = await getMutation(context, mutationChangePassword,
        variables: <String, dynamic>{
          'old_password': oldPw,
          'new_password': newPw
        });
    AppUtil.showPrint(
        "APIController requestChangePassword Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestCreateAppointment(
      BuildContext context, AppointmentInput userInput) async {
    QueryResult result = await getMutation(context, mutationCreateAppointment,
        variables: <String, dynamic>{'data': userInput});
    AppUtil.showPrint("APIController requestCreateAppointment Response: " +
        result.toString());
    return result;
  }

  Future<QueryResult> requestChangeAppointmentState(BuildContext context,
      String _id, String terminateReason, String state) async {
    QueryResult result = await getMutation(
        context, mutationChangeAppointmentState, variables: <String, dynamic>{
      '_id': _id,
      'terminateReason': terminateReason,
      'state': state
    });
    AppUtil.showPrint("APIController requestChangeAppointmentState Response: " +
        result.toString());
    return result;
  }

  Future<QueryResult> uploadFileImage(
      BuildContext context, MultipartFile file) async {
    QueryResult result = await getMutation(context, mutationUploadFileImage,
        variables: <String, dynamic>{'file': file});
    AppUtil.showPrint(
        "APIController uploadFileImage Response: " + result.toString());
    return result;
  }

  Future<QueryResult> updateIndicationResult(BuildContext context, String _id,
      String results, List<String> fileIds) async {
    QueryResult result = await getMutation(
        context, mutationUpdateIndicationResult, variables: <String, dynamic>{
      'fileIds': fileIds,
      "_id": _id,
      "result": results
    });
    AppUtil.showPrint(
        "APIController updateIndicationResult Response: " + result.toString());
    return result;
  }

  Future<QueryResult> updateMedicalSessionWaiting(
      BuildContext context, String code) async {
    QueryResult result = await getMutation(
        context, mutationUpdateMedicalSessionWaiting,
        variables: <String, dynamic>{'code': code});
    AppUtil.showPrint("APIController updateMedicalSessionWaiting Response: " +
        result.toString());
    return result;
  }

  Future<QueryResult> updateMedicalSessionConclusion(
      BuildContext context, data) async {
    QueryResult result = await getMutation(
        context, mutationUpdateMedicalSessionConclusion,
        variables: <String, dynamic>{"data": data});
    AppUtil.showPrint(
        "APIController updateMedicalSessionConclusion Response: " +
            result.toString());
    return result;
  }
}
