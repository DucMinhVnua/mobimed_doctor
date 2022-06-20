import 'dart:convert';
import 'package:DoctorApp/screen/patient/ScreenPatientDetail.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/controller/ApiGraphQLControllerQuery.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/model/GraphQLModels.dart';
import 'package:DoctorApp/model/MedicalSessionData.dart';
import 'package:DoctorApp/utils/AppStyle.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:DoctorApp/utils/DialogUtil.dart';

class ScreenQLDatKhamDaKham extends StatefulWidget {
  final String keySearch;

  const ScreenQLDatKhamDaKham({Key key, this.keySearch}) : super(key: key);

  @override
  ScreenQLDatKhamDaKhamState createState() => ScreenQLDatKhamDaKhamState();
}

class ScreenQLDatKhamDaKhamState extends State<ScreenQLDatKhamDaKham> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<MedicalSessionData> items = [];
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;
  // String keySearch = "";

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
    AppUtil.showPrint("_getMoreData page: $page / total: $totalPages");
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
      try {
        List<FilteredInput> arrFilterinput = [];
        List<SortedInput> arrSortedinput = [];
        arrFilterinput.add(FilteredInput("process", "wating_conclusion", ""));
        arrFilterinput.add(FilteredInput("textSearch", widget.keySearch, ""));
        arrSortedinput.add(SortedInput("createdTime", true));
        ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

        QueryResult result = await apiController.requestGetMedicalSessions(
            context, page, arrFilterinput, arrSortedinput);
        String response = result.data.toString();
        AppUtil.showPrint("Response requestGetMedicalSessions: " + response);
        if (response != null) {
          var responseData = appUtil.processResponseWithPage(result);
          int code = responseData.code;
          String message = responseData.message;

          if (code == 0) {
            String jsonData = json.encode(responseData.data);
            AppUtil.showPrint("### jsonData: " + jsonData);
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint("### pages: " + responseData.pages.toString());
              totalPages = responseData.pages;
            }
            var tmpItems = List<MedicalSessionData>.from(responseData.data
                .map((item) => MedicalSessionData.fromJsonMap(item)));
            items.addAll(tmpItems);
          } else {
            totalPages = 0;
            appUtil.showToast(context, message);
          }
        } else {
          AppUtil.showPopup(context, "Thông báo",
              "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
      }

      if (items.isEmpty) {
        double edge = 50;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
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
//        appBar: appUtil.getAppBar(new Text("Tin tức")),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 10),
//            child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: reloadData,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return _buildProgressIndicator();
              } else {
                MedicalSessionData itemData = items[index];
                if (itemData != null) {
                  return GestureDetector(
                      onTap: () async {
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return ScreenPatientDetail(itemID: itemData.id,);
//                    }));
                      },
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
                                itemData.patient != null
                                    ? Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
//                              backgroundColor: HexColor.fromHex(Constants.Color_primary),
                                            child: ClipOval(
                                              child: itemData.patient.avatar !=
                                                          null &&
                                                      !appUtil
                                                          .checkValidLocalPath(
                                                              itemData.patient
                                                                  .avatar)
                                                  ? FadeInImage.assetNetwork(
                                                      placeholder:
                                                          'assets/defaultimage.png',
                                                      image: itemData
                                                          .patient.avatar,
                                                      matchTextDirection: true,
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                    )
                                                  : Image.asset(
                                                      'assets/defaultimage.png',
                                                      matchTextDirection: true,
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      itemData.patient != null
                                          ? Column(
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: (itemData.patient
                                                                  ?.fullName !=
                                                              null)
                                                          ? Text(
                                                              itemData.patient
                                                                  .fullName,
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
                                                          Image.asset(
                                                            "assets/qrcode_16.png",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          itemData.appointment !=
                                                                      null &&
                                                                  itemData.appointment
                                                                          .code !=
                                                                      null
                                                              ? Text(
                                                                  itemData
                                                                      .appointment
                                                                      .code,
                                                                  style: Constants
                                                                      .styleTextSmallBlueColor)
                                                              : const Text(
                                                                  "Chưa có mã KCB",
                                                                  style: Constants
                                                                      .styleTextSmallRedColor)
                                                          /*        itemData.patientCode != null
                                                                ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor)
                                                                : Text("Chưa có mã BN", style: Constants.styleTextSmallRedColor)*/
//                                                            itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    )
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
                                                          (itemData.patient
                                                                      ?.phoneNumber !=
                                                                  null)
                                                              ? Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/phone_16.png",
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                          itemData
                                                                              .patient
                                                                              .phoneNumber,
                                                                          style:
                                                                              Constants.styleTextNormalSubColor),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(
                                                                  height: 0,
                                                                ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          (itemData.patient
                                                                      ?.birthDay !=
                                                                  null)
                                                              ? Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/icon_select_date.png",
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                          "NS: " +
                                                                              DateFormat(Constants.FORMAT_DATEONLY).format(itemData
                                                                                  .patient.birthDay),
                                                                          style:
                                                                              Constants.styleTextNormalSubColor),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(
                                                                  height: 0,
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (_) {
                                                          return ScreenPatientDetail(
                                                            patientCode: itemData
                                                                .patient
                                                                .patientCode,
                                                          );
                                                        }));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 0, 8),
                                                        child: Image.asset(
                                                          "assets/icon_next_function.png",
                                                          width: 30,
                                                          height: 22,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.userAction?.createdTime != null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icon_select_date.png",
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "Ngày đặt: " +
                                                          DateFormat(Constants
                                                                  .FORMAT_DATEONLY)
                                                              .format(itemData
                                                                  .userAction
                                                                  .createdTime),
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.userAction != null &&
                                              itemData.userAction
                                                      ?.appointment !=
                                                  null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icon_select_date.png",
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "Ngày khám: " +
                                                          DateFormat(Constants
                                                                  .FORMAT_DATEONLY)
                                                              .format(itemData
                                                                  .userAction
                                                                  ?.appointment
                                                                  ?.appointmentDate),
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      GestureDetector(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          color: HexColor.fromHex(
                                              Constants.Color_primary),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: const Text(
                                              "Kết quả",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: Constants
                                                      .Size_text_small),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (itemData == null ||
                                              itemData.conclusions == null ||
                                              itemData.conclusions.isEmpty) {
                                            appUtil.showToast(context,
                                                "Chưa có kết luận khám cho bệnh nhân này");
                                          } else {
                                            try {
                                              String dialogMessage = "";
                                              try {
                                                for (var i = 0;
                                                    i <
                                                        itemData
                                                            .conclusions.length;
                                                    ++i) {}
                                              } catch (ex) {}
                                              DialogUtil.showDialogWithTitle(
                                                  _scaffoldKey, context,
                                                  dialogTitle: "KẾT QUẢ KHÁM",
                                                  dialogMessage: dialogMessage,
                                                  okBtnFunction: null);
                                            } catch (e) {
                                              AppUtil.showLog(
                                                  "Error: " + e.toString());
                                            }
                                          }
                                          /*    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                              return ScreenKetQuaKham(
                                                itemID: itemData.id,
                                              );
                                            }));*/
                                        },
                                      ),
                                      const SizedBox(
                                        height: 0,
                                      ),
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
                  AppUtil.showPrint("### appointmentData KHÔNG CÓ DỮ LIỆU ");
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                  return const SizedBox(
                    height: 0,
                  );
                }
              }
            },
            controller: _scrollController,
          ),
        ),
      ));
}
