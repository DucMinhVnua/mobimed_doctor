import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/IndicationItem.dart';
import '../../model/MedicalSessionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenQLChiDinhAddChiDinh extends StatefulWidget {
  String sessionCode = '';
  MedicalSessionData medicalSessionData;

  ScreenQLChiDinhAddChiDinh({Key key, this.medicalSessionData})
      : super(key: key);

  @override
  _ScreenQLChiDinhAddChiDinhState createState() =>
      _ScreenQLChiDinhAddChiDinhState();
}

class _ScreenQLChiDinhAddChiDinhState extends State<ScreenQLChiDinhAddChiDinh> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<IndicationItem> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Null> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
    AppUtil.showPrint('_getMoreData page: $page / total: $totalPages');
    if (totalPages == null) return;
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      try {
      // List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      // arrFilterinput.add(FilteredInput("name,code,categoryCode", value: keySearch, ""));
      var arrFilterinput = [];
      arrFilterinput.add({'id': 'name,code,categoryCode', 'value': keySearch});
      arrSortedinput.add(SortedInput('createdTime', true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.getMedicalServices(
          context, page, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetPrescriptions: $response');
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData: $jsonData');
          if (jsonData == null || jsonData.isEmpty) {
            totalPages = 0;
          } else {
            AppUtil.showPrint('### pages: ${responseData.pages}');
            totalPages = responseData.pages;
          }
          var tmpItems = List<IndicationItem>.from(responseData.data
              .map((item) => IndicationItem.fromJsonMap(item)));
          items.addAll(tmpItems);
        } else {
          totalPages = 0;
          appUtil.showToastWithScaffoldState(_scaffoldKey, message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
//      } on Exception catch (e) {
//        AppUtil.showPrint('requestGetMedicalSessions Error: ' + e.toString());
//      }

      if (items.isEmpty) {
        double edge = 50;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          await _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      if (!mounted) {
        return;
      }
//      if(newEntries.length > 0) {
      setState(() {
        isPerformingRequest = false;
        page++;
      });
//      }
      //hide loading
//      appUtil.hideDialog(context);
    }
  }
//  @override
//  bool wantKeepAlive = true;

  Widget _buildProgressIndicator() => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: const CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'Thêm chỉ định '),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: reloadData,
        child: ListView.builder(
          shrinkWrap: true,
          // itemCount: items.length + 1,
          itemCount: items == null ? 2 : items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    color: HexColor.fromHex(Constants.Color_divider),
                    child: TextField(
//                textAlign: TextAlign.center,
                      style: TextStyle(
                          color: HexColor.fromHex(Constants.Color_maintext),
                          fontSize: 14),
                      onChanged: _onChangeHandler,
                      onSubmitted: _onChangeHandler,
                      controller: editingController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
//                    labelText: "Mã bệnh nhân ",
                        hintText: 'Tìm kiếm',
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }

            index -= 1;

            if (index == items.length) {
              return _buildProgressIndicator();
            } else {
              IndicationItem itemData = items[index];
              if (itemData != null) {
                return GestureDetector(
                    onTap: () async {},
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    itemData.name != null
                                        ? Column(
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: (itemData.name !=
                                                            null)
                                                        ? Text(itemData.name,
                                                            style: Constants
                                                                .styleTextNormalBlueColorBold)
                                                        : const SizedBox(
                                                            height: 1,
                                                          ),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  GestureDetector(
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        // Text("Xoá",
                                                        //     style: Constants
                                                        //         .styleTextNormalRedColorBold)
                                                        Image.asset(
                                                          'assets/img_add.png',
                                                          width: 20,
                                                          height: 20,
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      callAdd(itemData);
                                                    },
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: HexColor.fromHex(Constants.Color_divider),
                        )
                      ],
                    )
//                              )
                    );
              } else {
                AppUtil.showPrint('### appointmentData KHÔNG CÓ DỮ LIỆU ');
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                return const SizedBox(
                  height: 0,
                );
              }
            }
          },
          controller: _scrollController,
        ),
      ));

  TextEditingController editingController = TextEditingController();
  String keySearch = '';
  Timer searchOnStoppedTyping;
  _onChangeHandler(value) {
    setState(() {
      keySearch = value;
    });

    const duration = Duration(
        milliseconds:
            1000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    AppUtil.showPrint('Search key: $value');
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    _getMoreData();
  }

  callAdd(IndicationItem item) async {
    ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    QueryResult result = await apiController.createIndication(context,
        {'sessionCode': widget.medicalSessionData.code, 'serviceId': item.id});
    String response = result.data.toString();
    AppUtil.showPrint('Response createIndication: $response');
    if (response != null) {
      var responseData = appUtil.processResponseWithPage(result);
      int code = responseData.code;

      if (code == 0) {
        _getMoreData();
        await AppUtil.showPopup(
            context, 'Thông báo', 'Thêm chỉ định thành công!');
      }
    } else {
      await AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }
}
