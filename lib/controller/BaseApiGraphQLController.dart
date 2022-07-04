import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart'
    show GraphQLClient, HttpLink, QueryOptions, QueryResult;
import '../utils/Constant.dart';
import '../utils/AppUtil.dart';
import 'dart:async';
import 'package:graphql/client.dart';
export 'package:gql_link/gql_link.dart';

export 'package:gql_http_link/gql_http_link.dart';

class BaseApiGraphQLController {
  BaseApiGraphQLController(this.endpoint);

  String endpoint = '';
  int pageSize = 19;

  Constants constants = new Constants();
  AppUtil appUtil = new AppUtil();

  Future<dynamic> getQuery(
    BuildContext context,
    String body, {
    Map<String, dynamic> variables,
  }) async {
    try {
      bool isConnectionAvailable = await checkInternetConnection();
      if (isConnectionAvailable == true) {
        String accessToken =
            await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
        final _httpLink = HttpLink(endpoint);

        // Xử lý add token
        final _authLink = AuthLink(
          getToken: () async => 'Bearer $accessToken',
          // 'Content-Type': 'application/json; charset=utf-8',
        );

        Link link = _authLink.concat(_httpLink);
        log("### accessToken: " + "Bearer " + accessToken);

        GraphQLClient client = GraphQLClient(
          cache: GraphQLCache(),
          link: link,
        );

        QueryOptions options = QueryOptions(
          document: gql(body),
          variables: variables,
        );
        QueryResult queryResult = await client.query(options);

        log("Request Url: " + endpoint);
        log("getQuery query: " + body.toString());
        log("getQuery variables: " + json.encode(variables));
//    AppUtil.showPrint("getQuery variables: " + variables.toString());
//    final Future<Map<String, dynamic>> result =  link.query(query: body, variables: variables);

        if (queryResult.hasException) {
          AppUtil.showPrint("### Query fail:");
          AppUtil.showPrint(queryResult.exception.toString());
          return;
        } else {
          AppUtil.showPrint("### Query success");
          AppUtil.showPrint(queryResult.data.toString());
        }
//    if(queryResult.then(queryResult).
        AppUtil.showPrint("getQuery Result: " + queryResult.toString());
//    return result;
        return queryResult;
      } else {
        AppUtil.hideLoadingDialog(context);
        AppUtil.showPopup(context, "Thông báo",
            "Không có kết nối Internet. Vui lòng kiểm tra lại kết nối Internet và thử lại.");
        return "";
      }
    } on Exception catch (e) {
      AppUtil.showLog("Error getMutation: " + e.toString());
      AppUtil.hideLoadingDialog(context);
    }
  }

  Future<dynamic> getMutation(
    BuildContext context,
    String body, {
    Map<String, dynamic> variables,
  }) async {
    try {
      bool isConnectionAvailable = await checkInternetConnection();
      if (isConnectionAvailable == true) {
        String accessToken =
            await AppUtil.getFromSetting(Constants.PREF_ACCESSTOKEN);
        final _httpLink = HttpLink(endpoint);
        final _authLink = AuthLink(
          getToken: () async => 'Bearer $accessToken',
          // 'Content-Type': 'application/json; charset=utf-8',
        );
        Link link = _authLink.concat(_httpLink);
        log("### accessToken: " + "Bearer " + accessToken);

        GraphQLClient client = GraphQLClient(
          cache: GraphQLCache(),
          link: link,
        );

        final QueryOptions options = QueryOptions(
          document: gql(body),
          variables: variables,
        );
        final QueryResult queryResult = await client.query(options);

        log("Request Url: " + endpoint);
        log("getMutation query: " + body.toString());
//      AppUtil.showPrint("getMutation variables: " + variables.toString());
        // log("getQuery variables: " + json.encode(variables));
        return queryResult;
      } else {
        AppUtil.hideLoadingDialog(context);
        AppUtil.showPopup(context, "Thông báo",
            "Không có kết nối Internet. Vui lòng kiểm tra lại kết nối Internet và thử lại.");
        return "";
      }
    } on Exception catch (e) {
      AppUtil.showLog("Error getMutation: " + e.toString());
      AppUtil.hideLoadingDialog(context);
    }
  }

  Future<bool> checkInternetConnection() async {
    if (kIsWeb) return true;

    bool isConnect = false;
    try {
      // Tim kiem google.com
      final result = await InternetAddress.lookup('google.com');

      // check internet
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppUtil.showPrint('connected');
        isConnect = true;
      }
    } on SocketException catch (_) {
      isConnect = false;
      AppUtil.showPrint('not connected');
    }
    return isConnect;
  }
}
