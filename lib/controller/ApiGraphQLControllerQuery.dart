import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart' show QueryResult;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../model/GraphQLModels.dart';
import '../model/PatientData.dart';
import '../utils/AppUtil.dart';
import '../utils/Constant.dart';
import 'BaseApiGraphQLController.dart';
import 'MutationRequests.dart';
import 'QueryRequest.dart';
import 'QueryRequestAddress.dart';

class ApiGraphQLControllerQuery extends BaseApiGraphQLController {
  ApiGraphQLControllerQuery()
      : super('${dotenv.env['BASE_API_URL_GRAPHQL']}/graphql');

  int pageSize = 19;

  Constants constants = new Constants();
  AppUtil appUtil = new AppUtil();

  Future<QueryResult> requestGetAccountInfo(BuildContext context) async {
//    APIController apiController = new APIController();
    final QueryResult result = await getQuery(context, queryGetAccountInfo,
        variables: <String, dynamic>{});
//     \$filtered:[FilteredInput],\$sorted:[SortedInput],\$page:Int,\$pageSize:Int
    AppUtil.showPrint('APIController requestGetAccountInfo Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestqueryGetDepartmentId(
      BuildContext context, String _id) async {
    final QueryResult result = await getQuery(context, queryGetDepartmentById,
        variables: <String, dynamic>{'_id': _id});
    AppUtil.showPrint(
        'APIController requestqueryGetDepartmentId Response: $result');
    return result;
  }

  Future<QueryResult> requestGetAppConfig(
      BuildContext context, String platform) async {
    final QueryResult result = await getQuery(context, queryGetAppConfig,
        variables: <String, dynamic>{'platform': platform});
//     \$filtered:[FilteredInput],\$sorted:[SortedInput],\$page:Int,\$pageSize:Int
//    String msg = (result != null) ? jsonEncode(result) : "";
//   AppUtil.showPrint(
//        "APIController requestGetAppConfig Response: " + msg);
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

/*  Future<QueryResult> requestRegisterDevice(BuildContext context, DeviceInput appointment) async {
    QueryResult result = await getMutation(context, mutationRegisterDevice, variables: <String, dynamic>{'data': appointment});
//    String msg = (result != null) ? jsonEncode(result) : "";
//   AppUtil.showPrint(
//        "APIController requestRegisterDevice Response: " + msg);

    if (result.exception != null) {
      AppUtil.showLog("Response requestRegisterDevice exception: " + result.exception.toString());
    }
    return result;
  }*/

  Future<QueryResult> requestqueryGetServiceParentId(
      BuildContext context, String parentId) async {
    final QueryResult result = await getQuery(context, queryGetServiceParentId,
        variables: <String, dynamic>{'parentId': parentId});
    AppUtil.showPrint(
        'APIController requestqueryGetServiceParentId Response: $result');
    return result;
  }

  Future<QueryResult> requestSearchHisPatients(
      BuildContext context, PatientData patientData) async {
    final QueryResult result = await getQuery(context, querySearchHisPatients,
        variables: <String, dynamic>{'data': patientData});
    AppUtil.showPrint(
        'APIController requestSearchHisPatients Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetPatients(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result =
        await getQuery(context, queryGetPatients, variables: <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      'filtered': filterInput,
      'sorted': sortedInput
    });
    AppUtil.showPrint('APIController requestGetUsers Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetDetailPatient(
      BuildContext context, String patientCode) async {
    final QueryResult result = await getQuery(context, queryGetDetailPatient,
        variables: <String, dynamic>{
          'patientCode': patientCode,
        });
    AppUtil.showPrint(
        'APIController requestGetDetailPatient Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestCallVideoPatient(BuildContext context,
      String receiverId, String callerToken, bool video) async {
    final QueryResult result = await getQuery(context, queryCallVideoPatient,
        variables: <String, dynamic>{
          'receiverId': receiverId,
          'callerToken': callerToken,
          'video': video
        });
    AppUtil.showPrint(
        'APIController requestCallVideoPatient Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestAnswerCallVideo(
      BuildContext context, String callId, String token, bool accept) async {
    final QueryResult result = await getQuery(context, queryStopCallVideo,
        variables: <String, dynamic>{
          'callId': callId,
          'token': token,
          'accept': accept
        });
    AppUtil.showPrint(
        'APIController requestCallVideoPatient Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  //Request Address
  Future<QueryResult> requestGetNationalities(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetNationalitys,
        variables: <String, dynamic>{
          'page': page,
//          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint('APIController requestGetNationalitys Response: $result');
    return result;
  }

  Future<QueryResult> requestGetProvinces(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result =
        await getQuery(context, queryGetProvinces, variables: <String, dynamic>{
      'page': page,
//          'pageSize': pageSize,
      'filtered': filterInput,
      'sorted': sortedInput
    });
    AppUtil.showPrint('APIController requestGetProvinces Response: $result');
    return result;
  }

  Future<QueryResult> requestGetDistricts(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result =
        await getQuery(context, queryGetDistricts, variables: <String, dynamic>{
      'page': page,
//          'pageSize': pageSize,
      'filtered': filterInput,
      'sorted': sortedInput
    });
    AppUtil.showPrint('APIController requestGetDistricts Response: $result');
    return result;
  }

  Future<QueryResult> requestGetWards(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result =
        await getQuery(context, queryGetWards, variables: <String, dynamic>{
      'page': page,
//          'pageSize': pageSize,
      'filtered': filterInput,
      'sorted': sortedInput
    });
    AppUtil.showPrint('APIController requestGetWards Response: $result');
    return result;
  }

  Future<QueryResult> requestGetNations(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result =
        await getQuery(context, queryGetNations, variables: <String, dynamic>{
      'page': page,
//          'pageSize': pageSize,
      'filtered': filterInput,
      'sorted': sortedInput
    });
    AppUtil.showPrint('APIController requestGetNation Response: $result');
    return result;
  }

  Future<QueryResult> requestGetWorks(BuildContext context) async {
    final QueryResult result =
        await getQuery(context, queryGetWorks, variables: <String, dynamic>{});
    AppUtil.showPrint('APIController requestGetWorks Response: $result');
    return result;
  }

  Future<QueryResult> requestGetMedicalSessions(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetMedicalSessions,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint(
        'APIController requestGetMedicalSessions Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetMedicalSession(
      BuildContext context, String _id) async {
    final QueryResult result = await getQuery(context, queryGetMedicalSession,
        variables: <String, dynamic>{
          '_id': _id,
        });
    AppUtil.showPrint(
        'APIController requestGetMedicalSession Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetMedicalSessionsFollowingDoctor(
      BuildContext context,
      int page,
      List<FilteredInput> filterInput,
      List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(
        context, queryGetMedicalSessionsFollowingDoctor,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint(
        'APIController requestGetMedicalSessionFollowingDoctors Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetConclusions(
      BuildContext context, String _id) async {
    final QueryResult result = await getQuery(context, queryGetConclusions,
        variables: <String, dynamic>{'_id': _id});
    AppUtil.showPrint('APIController requestGetConclusions Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetUserActions(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetUserActions,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint('APIController requestGetUserActions Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetIndications(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetIndications,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint('APIController requestGetIndications Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetAppointments(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetAppointments,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint('APIController requestGetAppointments Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestReportAppointmentIndex(
    BuildContext context,
    DateTime fromDate,
    DateTime toDate,
    String departmentID,
  ) async {
    final QueryResult result = await getQuery(
        context, queryReportAppointmentIndex,
        variables: <String, dynamic>{
          'begin': new DateTime(fromDate.year, fromDate.month, fromDate.day)
              .toIso8601String(), // fromDate.toIso8601String(),
          'end': new DateTime(toDate.year, toDate.month, toDate.day + 1)
              .toIso8601String(), // toDate.toIso8601String(),
          'departmentId': departmentID,
        });
    AppUtil.showPrint(
        'APIController requestReportAppointmentIndex Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetNewsArticles(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetNewsArticles,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint('APIController requestGetNewsArticles Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetNewsArticleDetail(
      BuildContext context, String _id) async {
    final QueryResult result = await getQuery(
        context, queryGetNewsArticleDetail,
        variables: <String, dynamic>{
          '_id': _id,
        });
    AppUtil.showPrint(
        'APIController requestGetNewsArticleDetail Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetNotifications(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetNotifications,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint(
        'APIController requestGetNotificationSents Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetNotification(
      BuildContext context, String _id) async {
    final QueryResult result = await getQuery(context, queryGetNotification,
        variables: <String, dynamic>{
          '_id': _id,
        });
    AppUtil.showPrint(
        'APIController requestGetNotificationSent Response: $result');
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetPrescriptions(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryGetPrescriptions,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'filtered': filterInput,
          'sorted': sortedInput
        });
    AppUtil.showPrint(
        'APIController requestGetMyTransactions Response: $result');
    return result;
  }

  Future<QueryResult> requestGetDepartments(BuildContext context) async {
    final QueryResult result = await getQuery(context, queryGetDepartments,
        variables: <String, dynamic>{});
    AppUtil.showPrint('APIController requestGetDepartments Response: $result');
    return result;
  }

  Future<QueryResult> requestqueryGetServiceDemandOnlineGraph(
      BuildContext context) async {
    final QueryResult result = await getQuery(
        context, queryGetServiceDemandOnlineGraph,
        variables: <String, dynamic>{});
    AppUtil.showPrint(
        'APIController queryGetServiceDemandOnlineGraph Response: $result');
    return result;
  }

  Future<QueryResult> requestGetDepartmentWorkTimes(
      BuildContext context, String _id, DateTime date) async {
    final String dateOnly =
        DateFormat(Constants.FORMAT_DATEREQUEST).format(date);
    final QueryResult result = await getQuery(
        context, queryGetDepartmentWorktimes,
        variables: <String, dynamic>{'_id': _id, 'date': dateOnly});
    AppUtil.showPrint(
        'APIController requestGetDepartmentWorkTimes Response: $result');
    return result;
  }

  Future<QueryResult> getMedicalServices(BuildContext context, int page,
      filterInput, List<SortedInput> sortedInput) async {
    final QueryResult result = await getQuery(context, queryMedicalServices,
        variables: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
          'sorted': null,
          'filtered': filterInput
        });
    AppUtil.showPrint('APIController getMedicalServices Response: $result');
    return result;
  }

  Future<QueryResult> deleteConclusion(
      BuildContext context, String sessionId, String code) async {
    final QueryResult result = await getQuery(context, mutationDeleteConclusion,
        variables: <String, dynamic>{'sessionId': sessionId, 'code': code});
    AppUtil.showPrint('APIController deleteConclusion Response: $result');
    return result;
  }

  Future<QueryResult> updateConclusion(
      BuildContext context, String sessionId, data) async {
    final QueryResult result = await getQuery(context, mutationUpdateConclusion,
        variables: <String, dynamic>{'sessionId': sessionId, 'data': data});
    AppUtil.showPrint('APIController updateConclusion Response: $result');
    return result;
  }

  Future<QueryResult> createConclusion(
      BuildContext context, String sessionId, data) async {
    final QueryResult result = await getQuery(context, mutationCreateConclusion,
        variables: <String, dynamic>{'sessionId': sessionId, 'fileIds': data});
    AppUtil.showPrint('APIController createConclusion Response: $result');
    return result;
  }

  Future<QueryResult> updateImageConclusion(
      BuildContext context, String sessionId, List<String> fileIds) async {
    final QueryResult result = await getQuery(context, mutationImageConclusion,
        variables: <String, dynamic>{
          'sessionId': sessionId,
          'fileIds': fileIds
        });
    AppUtil.showPrint('APIController updateImageConclusion Response: $result');
    return result;
  }

  Future<QueryResult> createIndication(BuildContext context, data) async {
    final QueryResult result = await getQuery(context, mutationCreateIndication,
        variables: <String, dynamic>{'data': data});
    AppUtil.showPrint('APIController createIndication Response: $result');
    return result;
  }

  Future<QueryResult> terminateIndication(BuildContext context, _id) async {
    final QueryResult result = await getQuery(
        context, mutationTerminateIndication,
        variables: <String, dynamic>{'_id': _id, 'reason': ''});
    AppUtil.showPrint('APIController terminateIndication Response: $result');
    return result;
  }

  Future<QueryResult> confirmIndication(BuildContext context, _id) async {
    final QueryResult result = await getQuery(
        context, mutationConfirmIndication,
        variables: <String, dynamic>{'_id': _id, 'reason': ''});
    AppUtil.showPrint('APIController terminateIndication Response: $result');
    return result;
  }

  Future<QueryResult> getListIndication(BuildContext context, code) async {
    final QueryResult result = await getQuery(context, queryIndicationBySession,
        variables: <String, dynamic>{'code': code});
    AppUtil.showPrint('APIController getIndicationHistory Response: $result');
    return result;
  }

  Future<QueryResult> uploadFile(BuildContext context, XFile file) async {
    final QueryResult result = await getQuery(context, mutationUpFile,
        variables: <String, dynamic>{'file': file});
    return result;
  }
}
