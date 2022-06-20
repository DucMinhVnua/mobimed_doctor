import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../extension/HexColor.dart';
import '../../extension/ListChoiceDialog.dart';
import '../../model/PatientData.dart';
import '../../model/SelectedDialogData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenPatientDetailInfo extends StatefulWidget {
  final PatientData patientData;

  const ScreenPatientDetailInfo({Key key, this.patientData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenPatientDetailInfoState();
}

class _ScreenPatientDetailInfoState extends State<ScreenPatientDetailInfo>
    with AutomaticKeepAliveClientMixin<ScreenPatientDetailInfo> {
  AppUtil appUtil = AppUtil();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  Widget rowInfo(String title, String content, double fontSize, bool isBold) =>
      Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//        SizedBox(
//          width: 90,
//          child:
              Text(
                title,
                style: TextStyle(
                    color: HexColor.fromHex(Constants.Color_subtext),
                    fontWeight: FontWeight.normal,
                    fontSize: fontSize),
              ),
//        ),
              const SizedBox(
                width: 20,
              ),

              (isBold == true)
                  ? Flexible(
                      child: Text(
                        (content != null) ? content : 'Chưa có thông tin',
                        style: TextStyle(
                            color: HexColor.fromHex(Constants.Color_bluetext),
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (content != null) ? content : 'Chưa có thông tin',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: HexColor.fromHex(Constants.Color_bluetext),
                              fontWeight: FontWeight.normal,
                              fontSize: fontSize),
                        ),
                      ),
                    )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Divider(
            height: 1,
            color: HexColor.fromHex(Constants.Color_divider),
          ),
        ],
      );

  // ignore: missing_return
  Widget userInfoWidget(PatientData userData) {
    try {
      return Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                userData !=
                        null // && appUtil.checkValidLocalPath(userData.base.avatar) == false
                    ? Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 62,
                              backgroundColor:
                                  HexColor.fromHex(Constants.Color_primary),
                              child: ClipOval(
                                child: userData.avatar != null &&
                                        !appUtil.checkValidLocalPath(
                                            userData.avatar)
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'assets/logo.png',
                                        image: userData.avatar,
                                        matchTextDirection: true,
                                        fit: BoxFit.cover,
                                        width: 120.0,
                                        height: 120.0,
                                      )
                                    : Image.asset(
                                        'assets/logo.png',
                                        matchTextDirection: true,
                                        fit: BoxFit.cover,
                                        width: 120.0,
                                        height: 120.0,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 38,
                            right: 33,
                            child: GestureDetector(
                              child: Image.asset(
                                'assets/take_photo_32.png',
                                width: 33,
                                height: 33,
                              ),
                              onTap: () async {
                                List<SelectionDialogData> optionItems = [];
                                SelectionDialogData optionItem =
                                    SelectionDialogData();
                                optionItem.itemID = '0';
                                optionItem.itemTitle = 'Chụp ảnh mới';
                                optionItems.add(optionItem);
                                optionItem = SelectionDialogData();
                                optionItem.itemID = '1';
                                optionItem.itemTitle = 'Lấy từ thư viện';
                                optionItems.add(optionItem);
                                optionItem = SelectionDialogData();
                                optionItem.itemID = '2';
                                optionItem.itemTitle = 'Đóng';
                                optionItems.add(optionItem);

                                int selectedIndex = await showSelectionDialog(
                                    context, 'Chọn thao tác', optionItems);
                                AppUtil.showLog(
                                    'selectedIndex: $selectedIndex');
                                ImageSource imageSource;
                                switch (selectedIndex) {
                                  case 0:
                                    AppUtil.showLog('Chọn chup anh moi');
                                    imageSource = ImageSource.camera;
                                    break;
                                  case 1:
                                    AppUtil.showLog('Chọn lấy từ thư viện');
                                    imageSource = ImageSource.gallery;
                                    break;
                                }
//                    return;
//                    processUploadFileToServer(context, appointmentData);
                                if (imageSource != null) {
                                  var imagePicker = ImagePicker();
                                  XFile image = await imagePicker.pickImage(
                                      source: imageSource);
                                  if (image != null) {
//                            uploadFile(context, imageFieldData, image);
                                  } else {
                                    AppUtil.showLog('Image picked NULL');
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 25,
                ),
                rowInfo('Họ tên:', userData.fullName ?? '', 16, false),
                rowInfo(
                    'Ngày sinh:',
                    userData.birthDay != null
                        ? DateFormat(Constants.FORMAT_DATEONLY)
                            .format(userData.birthDay)
                        : '',
                    15,
                    false),
                rowInfo('Công việc:',
                    userData.work != null ? userData.work.name : '', 15, false),
                rowInfo(
                    'Số điện thoại:', userData.phoneNumber ?? '', 15, false),
                rowInfo(
                    'Giới tính:',
                    userData.gender != null &&
                            (userData.gender == 'male' ||
                                userData.gender == '1')
                        ? 'Nam'
                        : 'Nữ',
                    15,
                    false),
                rowInfo('Email:', userData.email ?? '', 15, false),
                rowInfo('Địa chỉ:', userData.address ?? '', 15, false),
//              rowInfo("Tên tài khoản:", userData.base, 16, false),
//              rowInfo("Họ tên:", userData.base.name, 16, false),
//            rowInfo("Địa chỉ:", userData.base.address, 15, false),
              ],
            ),
          ));
    } catch (e) {
      AppUtil.showPrint(e);
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppUtil.customAppBar(context, 'CHI TIẾT BỆNH NHÂN'),
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        userInfoWidget(widget.patientData),
                        const SizedBox(
                          height: 75,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      );

  @override
  bool get wantKeepAlive => true;
}
