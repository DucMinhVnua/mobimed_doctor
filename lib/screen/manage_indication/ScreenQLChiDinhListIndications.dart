import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/IndicationData.dart';
import '../../model/MedicalSessionData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';
import '../../utils/DialogUtil.dart';
import 'ScreenQLChiDinhAddChiDinh.dart';
import 'ScreenQLChiDinhResultIndication.dart';

// ignore: must_be_immutable
class ScreenQLChiDinhListIndications extends StatefulWidget {
  MedicalSessionData medicalSessionData;

  ScreenQLChiDinhListIndications({Key key, this.medicalSessionData})
      : super(key: key);

  @override
  _ScreenQLChiDinhListIndicationsState createState() =>
      _ScreenQLChiDinhListIndicationsState();
}

class _ScreenQLChiDinhListIndicationsState
    extends State<ScreenQLChiDinhListIndications> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<IndicationData> items = [];
  AppUtil appUtil = AppUtil();
  ScrollController _scrollController = ScrollController();
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

    WidgetsBinding.instance.addPostFrameCallback((_) => _getMoreData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Null> reloadData() async {
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
    setState(() => isPerformingRequest = true);
    ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

    QueryResult result = await apiController.getListIndication(
        context, widget.medicalSessionData.code);
    String response = result.data.toString();
    AppUtil.showPrint('Response getIndicationHistory: $response');
    if (response != null) {
      var responseData = appUtil.processResponseWithPage(result);
      int code = responseData.code;

      if (code == 0) {
        setState(() {
          items = List<IndicationData>.from(
              responseData.data.map((it) => IndicationData.fromJsonMap(it)));
        });
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    }
  }

  // ignore: unused_element
  Widget _buildProgressIndicator() => Padding(
        padding: const EdgeInsets.all(8.0),
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
      appBar: AppUtil.customAppBar(context, 'CHỈ ĐỊNH KHÁM'),
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                                (widget.medicalSessionData != null &&
                                        widget.medicalSessionData.patient !=
                                            null &&
                                        widget.medicalSessionData.patient
                                                .fullName !=
                                            null)
                                    ? 'BN: ${widget.medicalSessionData.patient.fullName}'
                                    : 'Không có thông tin BN',
                                style: Constants.styleTextTitleSubColor)),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 3,
                              ),
                              Image.asset(
                                'assets/img_add.png',
                                width: 32,
                                height: 32,
                              )
                            ],
                          ),
                          onTap: () async {
                            clickAddChiDinh();
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              );
            }

            index -= 1;
            // if (items.length <= 0 || index >= items.length) {
            if (index == items.length) {
              return const SizedBox(); //_buildProgressIndicator();
            } else {
              IndicationData itemData = items[index];
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
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: checkState(
                                                                  itemData
                                                                      .state),
                                                            ),
                                                            (itemData.state.toLowerCase() !=
                                                                        'pending' &&
                                                                    itemData.state
                                                                            .toLowerCase() !=
                                                                        'confirm')
                                                                ? DefaultSmallRowButtonUI(
                                                                    clickButton:
                                                                        () => {
                                                                              onClickKQ(itemData)
                                                                            },
                                                                    color:
                                                                        '#009933',
                                                                    name:
                                                                        'Kết quả')
                                                                : const SizedBox(),
                                                            (itemData.state
                                                                        .toLowerCase() ==
                                                                    'pending')
                                                                ? DefaultSmallRowButtonUI(
                                                                    clickButton:
                                                                        () => {
                                                                              clickDelete(itemData)
                                                                            },
                                                                    color: Constants
                                                                        .Color_red,
                                                                    name: 'Xoá')
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
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

  checkState(state) {
    if (state.toLowerCase() == 'confirm') {
      return const Text('Đang thực hiện',
          style: Constants.styleTextNormalBlueColor);
    } else if (state.toLowerCase() == 'pending') {
      return const Text('Chờ xử lý', style: Constants.styleTextNormalRedColor);
    } else {
      return const Text('Hoàn thành',
          style: Constants.styleTextNormalGreenColor);
    }
  }

  clickDelete(IndicationData item) async {
    await DialogUtil.showDialogConfirmYesNo(_scaffoldKey, context,
        title: 'XÁC NHẬN XOÁ CHỈ ĐỊNH',
        message: 'Chỉ định ${item.code}\n${item.name}',
        nameButton: 'Đồng ý', okBtnFunction: () async {
      terminateIndication(item);
    });
  }

  terminateIndication(IndicationData item) async {
    ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    QueryResult result =
        await apiController.terminateIndication(context, item.id);
    String response = result.data.toString();
    AppUtil.showPrint('Response terminateIndication: $response');
    if (response != null) {
      var responseData = appUtil.processResponseWithPage(result);
      int code = responseData.code;

      if (code == 0) {
        _getMoreData();
        AppUtil.showPopup(context, 'Thông báo', 'Xoá chỉ định thành công!');
      }
    } else {
      AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }

  clickAddChiDinh() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScreenQLChiDinhAddChiDinh(
              medicalSessionData: widget.medicalSessionData)),
    );
    ScaffoldMessenger.of(context).setState(() {
      _getMoreData();
    });
  }

  onClickKQ(IndicationData indication) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScreenQLChiDinhResultIndication(indication: indication)),
    );
  }
}
