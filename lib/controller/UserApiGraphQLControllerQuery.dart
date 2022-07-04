import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' show QueryResult;
import 'package:DoctorApp/controller/BaseApiGraphQLController.dart';
import 'package:DoctorApp/controller/QueryRequest.dart';
import 'package:DoctorApp/model/GraphQLModels.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/Constant.dart';
import '../utils/AppUtil.dart';
import 'dart:async';

class UserApiGraphQLControllerQuery extends BaseApiGraphQLController {
  UserApiGraphQLControllerQuery()
      : super(dotenv.env['BASE_API_URL_USER_GRAPHQL'] + '/graphql');

  int pageSize = 19;

  Constants constants = new Constants();
  AppUtil appUtil = new AppUtil();

  Future<QueryResult> requestGetNewsArticles(BuildContext context, int page,
      List<FilteredInput> filterInput, List<SortedInput> sortedInput) async {
    QueryResult result = await getQuery(context, queryGetNewsArticles,
        variables: <String, dynamic>{
          'page': page,
          'filtered': filterInput,
          'pageSize': pageSize,
          'sorted': sortedInput
        });
    AppUtil.showPrint(
        "APIController requestGetNewsArticles Response: " + result.toString());
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetNewsArticleDetail(
      BuildContext context, String _id) async {
    QueryResult result = await getQuery(context, queryGetNewsArticleDetail,
        variables: <String, dynamic>{
          '_id': _id,
        });
    AppUtil.showPrint("APIController requestGetNewsArticleDetail Response: " +
        result.toString());
//    printWrapped("APIController requestLogin Response: " + result.toString());
    return result;
  }

  Future<QueryResult> requestGetHotNews(BuildContext context) async {
    QueryResult result = await getQuery(context, queryGetHotNews,
        variables: <String, dynamic>{});
    AppUtil.showPrint(
        "APIController requestGetHotNews Response: " + result.toString());
    return result;
  }
}
