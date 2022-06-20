import 'package:DoctorApp/screen/ui/ui_input.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:DoctorApp/controller/ApiGraphQLControllerMutation.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/extension/RaisedGradientButton.dart';
import 'package:DoctorApp/utils/DialogUtil.dart';

class ScreenChangePassword extends StatefulWidget {
  final String phoneNumber, regID;

  ScreenChangePassword({Key key, this.phoneNumber, this.regID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenChangePasswordState();
}

class _ScreenChangePasswordState extends State<ScreenChangePassword> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController textControllerOldPassword = new TextEditingController();
  TextEditingController textControllerNewPassword = new TextEditingController();
  TextEditingController textControllerConfirmNewPassword =
      new TextEditingController();

  bool _validateOldPassword = false;
  bool _validateNewPassword = false;

  final FocusNode focusNodeOldPassword = FocusNode();
  final FocusNode focusNodeNewPassword = FocusNode();
  final FocusNode focusNodeConfirmNewPassword = FocusNode();

  AppUtil appUtil = new AppUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
//    loginBloc.?
    super.dispose();
  }

  bool isShowPassOld = true;
  bool isShowPassNew = true;
  bool isShowPassRenew = true;
  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppUtil.customAppBar(context, 'ĐỔI MẬT KHẨU'),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
//          Center(
//              child:
            Container(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedInputFieldPass(
                        controller: textControllerOldPassword,
                        hintText: 'Nhập mật khẩu hiện tại',
                        isObscure: isShowPassOld,
                        onChangeObscure: () {
                          setState(() {
                            isShowPassOld = !isShowPassOld;
                          });
                        },
                      ),
                      RoundedInputFieldPass(
                        controller: textControllerNewPassword,
                        hintText: 'Nhập  mật khẩu mới',
                        isObscure: isShowPassNew,
                        onChangeObscure: () {
                          setState(() {
                            isShowPassNew = !isShowPassNew;
                          });
                        },
                      ),
                      RoundedInputFieldPass(
                        controller: textControllerConfirmNewPassword,
                        hintText: 'Nhập lại mật khẩu mới',
                        isObscure: isShowPassRenew,
                        onChangeObscure: () {
                          setState(() {
                            isShowPassRenew = !isShowPassRenew;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Lưu ý: Mật khẩu có phân biệt chữ hoa và chữ thường!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HexColor.fromHex('#F84366'),
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RaisedGradientButton(
                          text: 'XÁC NHẬN',
                          onPressed: () {
                            setState(() {
                              textControllerOldPassword.text.isEmpty
                                  ? _validateOldPassword = true
                                  : _validateOldPassword = false;
                              textControllerNewPassword.text.isEmpty
                                  ? _validateNewPassword = true
                                  : _validateNewPassword = false;
                            });
                            if (textControllerOldPassword.text.isEmpty) {
                              appUtil.showToastWithScaffoldState(_scaffoldKey,
                                  'Vui lòng nhập mật khẩu hiện tại');
                              return;
                            }
                            if (textControllerNewPassword.text.isEmpty ||
                                textControllerConfirmNewPassword.text.isEmpty) {
                              appUtil.showToastWithScaffoldState(
                                  _scaffoldKey, 'Vui lòng nhập mật khẩu mới');
                              return;
                            }
                            if (textControllerNewPassword.text !=
                                textControllerConfirmNewPassword.text) {
                              appUtil.showToastWithScaffoldState(_scaffoldKey,
                                  'Xác nhận mật khẩu không chính xác');
                              return;
                            }

                            onButtonPressed();
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ))
//          ),
          ],
        ),
      );

  onButtonPressed() async {
    try {
      AppUtil.showLoadingDialog(context);
      ApiGraphQLControllerMutation apiController =
          new ApiGraphQLControllerMutation();

      QueryResult result = await apiController.requestChangePassword(context,
          textControllerOldPassword.text, textControllerNewPassword.text);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestChangePassword: ' + response);
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        var responseData = appUtil.processResponse(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
              messageSuccess: 'Đổi mật khẩu thành công!', okBtnFunction: () {});

          Navigator.pop(context, Constants.SignalSuccess);
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestChangePassword Error: ' + e.toString());
    }
  }
}
