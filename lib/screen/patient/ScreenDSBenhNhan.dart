import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/PatientData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../online_medical/model/chat_data.dart';
import '../online_medical/screen/messages/message_screen.dart';
import 'ScreenAddPatient.dart';
import 'ScreenDatKham.dart';
import 'ScreenPatientDetail.dart';
import 'screen_call_patient.dart';

class ScreenDSBenhNhan extends StatefulWidget {
  const ScreenDSBenhNhan({
    Key key,
  }) : super(key: key);

  @override
  _ScreenDSBenhNhanState createState() => _ScreenDSBenhNhanState();
}

class _ScreenDSBenhNhanState extends State<ScreenDSBenhNhan> {
  DateFormat formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

//  List<int> items = List.generate(10, (i) => i);
  List<Map<String, dynamic>> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  TextEditingController editingController = TextEditingController();
  String keySearch = '';

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

  Future<void> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    await _getMoreData();
  }

  Future<void> _getMoreData() async {
    AppUtil.showPrint('_getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      List<int> newEntries = await fakeRequest(items.length, items.length); //returns empty list
      List<Map<String, dynamic>> newEntries = [];
      //show loading
//      appUtil.showLoadingDialog(context);
      try {
        final List<FilteredInput> arrFilterinput = [];
        final List<SortedInput> arrSortedinput = [];
//        arrFilterinput.add(FilteredInput("action", "APPOINTMENT", ""));
        arrFilterinput.add(FilteredInput(
            'fullName,name,patientCode', keySearch.toUpperCase(), ''));
        arrSortedinput.add(SortedInput('createdTime', true));
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        final QueryResult result = await apiController.requestGetPatients(
            context, page, arrFilterinput, arrSortedinput);
        final String response = result.data.toString();
        AppUtil.showPrint('Response requestGetPatients: $response');
        if (response != null) {
          final responseData = appUtil.processResponseWithPage(result);
          final int code = responseData.code;
          final String message = responseData.message;

          if (code == 0) {
            final String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull('### jsonData: $jsonData');
            if (jsonData == null || jsonData.isEmpty) {
              totalPages = 0;
            } else {
              AppUtil.showPrint('### pages: ${responseData.pages}');
              totalPages = responseData.pages;
            }
            newEntries = json.decode(jsonData).cast<Map<String, dynamic>>();
          } else {
            await AppUtil.showPopup(context, 'Thông báo', message);
          }
        } else {
          await AppUtil.showPopup(context, 'Thông báo',
              'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: $e');
      }

      if (newEntries.isEmpty) {
//        double edge = 10.0;
        final double edge = 50;
        final double offsetFromBottom =
            _scrollController.position.maxScrollExtent -
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
        items.addAll(newEntries);
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
      appBar: AppUtil.customAppBar(context, 'DANH SÁCH BỆNH NHÂN'),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScreenAddPatient()),
          );
          if (result != null && result == Constants.SignalSuccess) {
            await reloadData();
          }
        },
        backgroundColor: Constants.colorMain,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/add_more.png',
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                onRefresh: reloadData,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items == null ? 2 : items.length + 2,
//                    itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // return the header
                      return Column(
                        children: <Widget>[
                          AppUtil.searchWidget('Tìm kiếm bệnh nhân',
                              _onChangeHandler, editingController),
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
                      final PatientData itemData =
                          PatientData.fromJsonMap(items[index]);
                      if (itemData != null) {
                        return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ScreenPatientDetail(
                                            patientCode: itemData.patientCode,
                                          )));
                            },
                            child:
//                              Card(
//                                  color: Colors.white,
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(5.0),
//                                  ),
//                                  margin: EdgeInsets.only(
//                                      left: 10, right: 10, bottom: 10),
//                                  child:

                                Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
//                                       CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: Colors.white,
// //                              backgroundColor: HexColor.fromHex(Constants.Color_primary),
//                                         child: ClipOval(
//                                           child: itemData.avatar != null &&
//                                                   !appUtil.checkValidLocalPath(
//                                                       itemData.avatar)
//                                               ? FadeInImage.assetNetwork(
//                                                   placeholder:
//                                                       'assets/defaultimage.png',
//                                                   image: itemData.avatar,
//                                                   matchTextDirection: true,
//                                                   fit: BoxFit.cover,
//                                                   width: 50,
//                                                   height: 50,
//                                                 )
//                                               : Image.asset(
//                                                   'assets/defaultimage.png',
//                                                   matchTextDirection: true,
//                                                   fit: BoxFit.cover,
//                                                   width: 50,
//                                                   height: 50,
//                                                 ),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 12,
//                                       ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: (itemData?.fullName !=
                                                          null)
                                                      ? Text(itemData.fullName,
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
                                                        'assets/qrcode_16.png',
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      itemData.patientCode !=
                                                              null
                                                          ? Text(
                                                              itemData
                                                                  .patientCode,
                                                              style: Constants
                                                                  .styleTextSmallBlueColor)
                                                          : const Text(
                                                              'Chưa có mã BN',
                                                              style: Constants
                                                                  .styleTextSmallRedColor)
//                                                        itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()
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
                                                      (itemData?.phoneNumber !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/phone_16.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      itemData
                                                                          .phoneNumber,
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
                                                      (itemData?.birthDay !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/icon_select_date.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      DateFormat(Constants
                                                                              .FORMAT_DATEONLY)
                                                                          .format(itemData
                                                                              .birthDay),
                                                                      style: Constants
                                                                          .styleTextNormalSubColor),
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
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ScreenPatientDetail(
                                                                  patientCode:
                                                                      itemData
                                                                          .patientCode,
                                                                )));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 0, 8),
                                                    child: Image.asset(
                                                      'assets/icon_next_function.png',
                                                      width: 30,
                                                      height: 22,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            (itemData?.address != null)
                                                ? Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/location_16.png',
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            itemData.address,
                                                            style: Constants
                                                                .styleTextNormalSubColor),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 1,
                                                  ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                viewBtn(() {
                                                  onClickBookHospital(itemData);
                                                }, 'Đặt khám tại viện',
                                                    Constants.colorMain),
                                                // viewBtn(() {
                                                //   onClickBookHouse(itemData);
                                                // }, 'Đặt khám tại nhà',
                                                //     Colors.green),
                                                viewBtn(() {
                                                  onClickContact(itemData);
                                                }, 'Liên hệ', Colors.orange)
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color:
                                      HexColor.fromHex(Constants.Color_divider),
                                )
                              ],
                            )
//                              )
                            );
                      } else {
                        AppUtil.showPrint(
                            '### appointmentData KHÔNG CÓ DỮ LIỆU ');
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
            )
          ],
        ),
      ));

  Widget viewBtn(Function onClick, String name, Color color) => GestureDetector(
      onTap: onClick,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            name,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: Constants.Size_text_small),
          ),
        ),
      ));

  Future<void> onClickBookHospital(PatientData itemData) async {
    final String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ScreenDatKham(
                  patientInput: itemData,
                )));

    AppUtil.showLog(result != null
        ? 'Back from creean add => result: $result'
        : 'Back from creean add => result: NULL');
    if (result != null && result == Constants.SignalSuccess) {
//                                                    Navigator.pop(context, Constants.SignalSuccess);
      await reloadData();
    }
  }

  Future<void> onClickContact(PatientData itemData) async {
    final ChatContact chat = ChatContact()
      ..id = itemData.id
      ..fullName = itemData.fullName
      ..phoneNumber = itemData.phoneNumber
      ..online = false;
    final String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MessagesScreen(
                  chat: chat,
                )));

    AppUtil.showLog(result != null
        ? 'Back from creean add => result: $result'
        : 'Back from creean add => result: NULL');
    if (result != null && result == Constants.SignalSuccess) {
//                                                    Navigator.pop(context, Constants.SignalSuccess);
      await reloadData();
    }
  }

  Future<void> onClickBookHouse(PatientData itemData) async {
    final ChatContact chat = ChatContact()
      ..id = itemData.id
      ..fullName = itemData.fullName
      ..phoneNumber = itemData.phoneNumber
      ..online = false;
    final String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MessagesScreen(
                  chat: chat,
                )));

    AppUtil.showLog(result != null
        ? 'Back from creean add => result: $result'
        : 'Back from creean add => result: NULL');
    if (result != null && result == Constants.SignalSuccess) {
//                                                    Navigator.pop(context, Constants.SignalSuccess);
      await reloadData();
    }
  }

  Widget iconButton(Color color, Function onClick, String name) =>
      GestureDetector(
          onTap: onClick,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: color,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: Constants.Size_text_small),
              ),
            ),
          ));

  Timer searchOnStoppedTyping;
  void _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            1000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  Future<void> search(value) async {
    AppUtil.showPrint('Search key: $value');

    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();

    setState(() {
      keySearch = value;
    });

    await _getMoreData();
  }

  Constants constants = Constants();
  Future<void> onClickCallVideo(PatientData patientData) async {
    // ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    // String fcmID = await AppUtil.getFromSetting(constants.PREF_FCM_ID);
    // QueryResult result = await apiController.requestCallVideoPatient(
    //     context, patientData.id, fcmID, true);
    // String response = result.data.toString();
    // AppUtil.showPrint("Response requestGetPatients: " + response);
    // if (response != null) {
    //   var responseData = appUtil.processResponseWithPage(result);
    //   int code = responseData.code;
    //   String message = responseData.message;

    //   if (code == 0) {
    //     await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               ScreenCallPatient(patientData: patientData)),
    //     );
    //   } else {
    //     AppUtil.showPopup(context, "Thông báo", message);
    //   }
    // } else {
    //   AppUtil.showPopup(context, "Thông báo",
    //       "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
    // }
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScreenCallPatient(patientData: patientData)),
    );
  }
}
