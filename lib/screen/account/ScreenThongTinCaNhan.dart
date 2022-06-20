import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../bloc/userinfo/userinfo_bloc.dart';
import '../../extension/HexColor.dart';
import '../../model/UserInfoData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenThongTinCaNhan extends StatefulWidget {
  final String title;

  const ScreenThongTinCaNhan({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenThongTinCaNhanState();
}

class _ScreenThongTinCaNhanState extends State<ScreenThongTinCaNhan> {
  AppUtil appUtil = new AppUtil();
  ScrollController _scrollController;
  UserInfoBloc userInfoBloc;

  @override
  void initState() {
    super.initState();

    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    _scrollController = new ScrollController();

    //Start load userinfo
    userInfoBloc.add(
      LoadUserInfoEvent(context),
    );
  }

  Widget rowInfo(String title, String content, double fontSize, bool isBold) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                  color: HexColor.fromHex(Constants.Color_maintext),
                  fontWeight: FontWeight.normal,
                  fontSize: fontSize),
            ),
          ),
          (isBold == true)
              ? Flexible(
                  child: Text(
                    (content != null) ? content : 'Chưa có thông tin',
                    style: TextStyle(
                        color: HexColor.fromHex(Constants.Color_maintext),
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize),
                  ),
                )
              : Text(
                  (content != null) ? content : 'Chưa có thông tin',
                  style: TextStyle(
                      color: HexColor.fromHex(Constants.Color_maintext),
                      fontWeight: FontWeight.normal,
                      fontSize: fontSize),
                )
        ],
      );

  Widget userInfoWidget(UserInfoData userData) => Container(
        width: double.infinity,
        child: Column(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 62,
                backgroundColor: HexColor.fromHex(Constants.Color_primary),
                child: ClipOval(
                  child: !appUtil.checkValidLocalPath(userData.base.avatar)
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/logo.png',
                          image: userData.base.avatar,
//                    image: 'http://static.benhvienphusanhanoi.vn/w640/images/upload/01302019/logo787ac38d.jpg',
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
            const SizedBox(
              height: 25,
            ),
            rowInfo('Họ tên:', userData.base.name, 16, true),
            const SizedBox(
              height: 10,
            ),
            rowInfo('Địa chỉ:', userData.base.address, 15, false),
            const SizedBox(
              height: 10,
            ),
            rowInfo('Số điện thoại:', userData.base.phoneNumber, 15, false),
            const SizedBox(
              height: 10,
            ),
            rowInfo('Email:', userData.base.email, 15, false),
            const SizedBox(
              height: 10,
            ),
            rowInfo(
                'Khoa/Phòng:',
                userData.department != null
                    ? userData.department.name
                    : 'Chưa có thông tin',
                15,
                true),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  BlocListener<UserInfoBloc, UserInfoState>(
                    listener: (context, state) => {},
                    child: BlocBuilder<UserInfoBloc, UserInfoState>(
                        builder: (context, state) {
                      if (state is UserInfoInitialState) {
                        return const Center(
                            child: Text(
                                'Đang lấy thông tin tài khoản. Xin chờ ...',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal)));
                      }
                      if (state is UserInfoLoadingState) {
                        return const Center(
                            child: const CircularProgressIndicator());
                      }
                      if (state is UserInfoLoadedState) {
                        final QueryResult result = state.responseUserInfoData;

                        if (result != null) {
                          final responseData = appUtil.processResponse(result);
                          if (responseData != null) {
                            final int code = responseData.code;

                            final Map data = responseData.data;
                            //    var json = jsonDecode(result.);

                            if (code == 0) {
                              //Login thành công
                              final UserInfoData userData =
                                  new UserInfoData.fromJson(data);
                              AppUtil.showLog('requestSaveArticleMedia: ' +
                                  jsonEncode(userData.toJson()));
                              return userInfoWidget(userData);
                            } else {
                              return const Center(
                                  child: const Text(
                                      'Tải thông tin tài khoản thành công'));
                            }
                          } else {
                            return const Center(
                                child:
                                    Text('Tải thông tin tài khoản thành công'));
                          }
                          // ignore: dead_code
                          return const Center(
                              child:
                                  Text('Tải thông tin tài khoản thành công'));
                        } else {
                          if (state is UserInfoErrorState) {
                            return const Center(
                                child: Text(
                                    'Đăng nhập không thành công. Vui lòng kiểm tra lại'));
                          }
                        }
                        if (state is UserInfoLoadedState) {
                          return const Center(
                              child: Text('Đang xử lý thông tin đăng nhập'));
                        }
                        if (state is UserInfoErrorState) {
                          return const Center(
                              child: const Text(
                                  'Đăng nhập không thành công. Vui lòng kiểm tra lại'));
                        }
                      }
                      return const Center(
                          child: const Text(
                              'Đăng nhập không thành công. Vui lòng kiểm tra lại'));
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
