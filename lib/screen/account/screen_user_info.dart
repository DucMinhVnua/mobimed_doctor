import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../bloc/userinfo/userinfo_bloc.dart';
import '../../extension/HexColor.dart';
import '../../model/UserInfoData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'ScreenLogin.dart';
import 'ScreenUpdateProfile.dart';

class ScreenUserInfo extends StatefulWidget {
  ScreenUserInfo({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenUserInfoState();
}

class _ScreenUserInfoState extends State<ScreenUserInfo>
    with AutomaticKeepAliveClientMixin<ScreenUserInfo> {
  AppUtil appUtil = AppUtil();
  ScrollController _scrollController;
  UserInfoBloc userInfoBloc;
  UserInfoData userData;

  @override
  void initState() {
    super.initState();

    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    _scrollController = ScrollController();

    //Start load userinfo
    userInfoBloc.add(
      LoadUserInfoEvent(context),
    );
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
                        (content != null) ? content : 'Ch??a c?? th??ng tin',
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
                          (content != null) ? content : 'Ch??a c?? th??ng tin',
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
  Widget userInfoWidget(UserInfoData userData) {
    try {
      return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
              children: <Widget>[
                userData.base != null &&
                        userData.base.avatar !=
                            null // && appUtil.checkValidLocalPath(userData.base.avatar) == false
                    ? Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 62,
                              backgroundColor:
                                  HexColor.fromHex(Constants.Color_primary),
                              child: ClipOval(
                                child: userData.base.avatar != null &&
                                        !appUtil.checkValidLocalPath(
                                            userData.base.avatar)
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'assets/logo.png',
                                        image: userData.base.avatar,
                                        matchTextDirection: true,
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      )
                                    : Image.asset(
                                        'assets/logo.png',
                                        matchTextDirection: true,
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      ),
                              ),
                            ),
                          ),
                          /*  Positioned(
                            top: 38,
                            right: 33,
                            child: GestureDetector(
                              child: Image.asset(
                                "assets/take_photo_32.png",
                                width: 33,
                                height: 33,
                              ),
                              onTap: () async {
                                List<SelectionDialogData> optionItems = [];
                                SelectionDialogData optionItem =SelectionDialogData();
                                optionItem.itemID = "0";
                                optionItem.itemTitle = "Ch???p ???nh m???i";
                                optionItems.add(optionItem);
                                optionItem =SelectionDialogData();
                                optionItem.itemID = "1";
                                optionItem.itemTitle = "L???y t??? th?? vi???n";
                                optionItems.add(optionItem);
                                optionItem =SelectionDialogData();
                                optionItem.itemID = "2";
                                optionItem.itemTitle = "????ng";
                                optionItems.add(optionItem);

                                int selectedIndex = await showSelectionDialog(context, "Ch???n thao t??c", optionItems);
                                AppUtil.showLog("selectedIndex: " + selectedIndex.toString());
                                ImageSource imageSource;
                                switch (selectedIndex) {
                                  case 0:
                                    AppUtil.showLog("Ch???n chup anh moi");
                                    imageSource = ImageSource.camera;
                                    break;
                                  case 1:
                                    AppUtil.showLog("Ch???n l???y t??? th?? vi???n");
                                    imageSource = ImageSource.gallery;
                                    break;
                                }
                                if (imageSource != null) {
                                  File image = await ImagePicker.pickImage(source: imageSource);
                                  if (image != null) {
//                            uploadFile(context, imageFieldData, image);
                                  } else {
                                    AppUtil.showLog("Image picked NULL");
                                  }
                                }
                              },
                            ),
                          )*/
                        ],
                      )
                    : const SizedBox(),
                rowInfo('H??? t??n:', userData.base.fullName ?? '', 16, false),
                rowInfo(
                    'Ng??y sinh:',
                    userData.base.birthday != null
                        ? DateFormat(Constants.FORMAT_DATEONLY)
                            .format(userData.base.birthday)
                        : '',
                    15,
                    false),
                rowInfo('Khoa/Ph??ng:', userData.base.departmentName ?? '', 15,
                    false),
                rowInfo('Ch???c v???:', userData.base.work ?? '', 15, false),
                rowInfo('S??? ??i???n tho???i:', userData.base.phoneNumber ?? '', 15,
                    false),
                rowInfo(
                    'Gi???i t??nh:',
                    userData.base.gender != null &&
                            (userData.base.gender == 'male' ||
                                userData.base.gender == '1')
                        ? 'Nam'
                        : 'N???',
                    15,
                    false),
                rowInfo('Email:', userData.base.email ?? '', 15, false),
                rowInfo('?????a ch???:', userData.base.address ?? '', 15, false),
//              rowInfo("T??n t??i kho???n:", userData.base, 16, false),
//              rowInfo("H??? t??n:", userData.base.name, 16, false),
//            rowInfo("?????a ch???:", userData.base.address, 15, false),
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
            backgroundColor: Colors.white,
            appBar: AppUtil.customAppBar(context, 'TH??NG TIN C?? NH??N'),
            body: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        BlocListener<UserInfoBloc, UserInfoState>(
                          listener: (context, state) => {
//                    if (state is UserInfoLoadingState) {
//                      Scaffold.of(context).showSnackBar(
//                          SnackBar(
//                            content: Text('??ang ti???n h??nh ????ng nh???p'),
//                            backgroundColor: Colors.red,
//                          ),
//                        )
//                    }
                          },
                          child: BlocBuilder<UserInfoBloc, UserInfoState>(
                              builder: (context, state) {
                            if (state is UserInfoInitialState) {
                              return const Center(
                                  child: Text(
                                      '??ang l???y th??ng tin t??i kho???n. Xin ch??? ...',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal)));
                            }
                            if (state is UserInfoLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is UserInfoLoadedState) {
                              final QueryResult result =
                                  state.responseUserInfoData;

                              if (result != null) {
                                //UserInfo th??nh c??ng
                                final responseData =
                                    appUtil.processResponse(result);
                                if (responseData != null) {
                                  final int code = responseData.code;

                                  final Map data = responseData.data;
                                  //    var json = jsonDecode(result.);

                                  if (code == 0) {
                                    //Login th??nh c??ng
                                    userData = UserInfoData.fromJson(data);
                                    AppUtil.showLog(
                                        'json UserInfo: ${jsonEncode(userData.toJson())}');
                                    return userInfoWidget(userData);
                                  } else {
                                    return const Center(
                                        child: Text(
                                            'T???i th??ng tin t??i kho???n th??nh c??ng'));
                                  }
                                } else {
                                  return const Center(
                                      child: Text(
                                          'T???i th??ng tin t??i kho???n th??nh c??ng'));
                                }
                              } else {
                                if (state is UserInfoErrorState) {
                                  return const Center(
                                      child: Text(
                                          '????ng nh???p kh??ng th??nh c??ng. Vui l??ng ki???m tra l???i'));
                                }
                              }
                              if (state is UserInfoLoadedState) {
                                return const Center(
                                    child:
                                        Text('??ang x??? l?? th??ng tin ????ng nh???p'));
                              }
                              if (state is UserInfoErrorState) {
                                return const Center(
                                    child: Text(
                                        '????ng nh???p kh??ng th??nh c??ng. Vui l??ng ki???m tra l???i'));
                              }
                            }
                            return const Center(
                                child: Text(
                                    '????ng nh???p kh??ng th??nh c??ng. Vui l??ng ki???m tra l???i'));
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            viewBtn(onClickEdit, Constants.colorMain,
                                'S???A TH??NG TIN'),
                          ]),
                    ))
              ],
            )),
      );

  Widget viewBtn(Function clickButton, Color color, String name) =>
      GestureDetector(
          onTap: clickButton,
          child: SizedBox(
              height: 55,
              width: 300,
              child: Card(
                color: color,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                elevation: 6,
                child: Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: Constants.fontName,
                      fontSize: 18,
                      letterSpacing: 0,
                      color: Constants.white,
                    ),
                  ),
                ),
              )));

  Future<void> onClickEdit() async {
    final String result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenUpdateProfile(
            userData: userData,
          ),
        ));
    AppUtil.showLog(result != null
        ? 'Back from creean add => result: $result'
        : 'Back from creean add => result: NULL');
    if (result != null && result == Constants.SignalSuccess) {
      userInfoBloc.add(
        LoadUserInfoEvent(context),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
