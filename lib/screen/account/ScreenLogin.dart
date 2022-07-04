import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../bloc/login/login_bloc.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../extension/RaisedGradientButton.dart';
import '../../model/AppConfigData.dart';
import '../../model/ResponseLoginData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../home/ScreenHome.dart';
import '../ui/ui_input.dart';
import 'ScreenRegister.dart';

// ignore: must_be_immutable
class ScreenLogin extends StatefulWidget {
  // Dữ liệu
  final String title;
  bool isLoading = false;

  ScreenLogin({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  String inReview = 'false';
  // String inReview = "true";\

  // Khởi tạo đối tượng loginBloc
  LoginBloc loginBloc;

  // controller của text field
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  // validate
  bool _validateUserName = false, _validatePassword = false;

  // khởi tạo đối tượng AppUntil hỗ trợ ứng dụng
  AppUtil appUtil = AppUtil();

  //
  bool isShowRegisterButton = false;
  bool isRememberPasswordChecked = true;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Khai báo focusnode (click focus vào textfield)
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (!UniversalPlatform.isWeb) requestGetAppConfig(context);

    loginBloc = BlocProvider.of<LoginBloc>(context);
//    loginBloc.add(FetchLoginEvent());

    //Gọi sau lần build widget đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) => loadLoginInfo(context));
  }

  Constants constants = Constants();
  loadLoginInfo(context) async {
    try {
      // Lấy userName & password từ local
      final String userName =
          await AppUtil.getFromSetting(Constants.PREF_USERNAME);
      final String password =
          await AppUtil.getFromSetting(Constants.PREF_PASSWORD);
      setState(() {
        usernameTextController.text = userName;
        passwordTextController.text = password;

        if (userName.isNotEmpty && password.isNotEmpty) {
          _onLoginButtonPressed();
        }
      });
    } catch (e) {
      AppUtil.showPrint(e.toString());
    }
  }

  // ignore: unused_element
  static Future<dynamic> popAndPushNamed(BuildContext context, String routeName,
      {dynamic result}) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pop(result);
    return navigator.pushNamed(routeName);
  }

  final forgotPass = TextButton(
    onPressed: () {},
    child: const Text(
      'Quên mật khẩu',
      style: TextStyle(color: Colors.blue),
    ),
  );

  checkLogin() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
      return const ScreenHome();
    }), (Route<dynamic> route) => false);
  }

  requestGetAppConfig(BuildContext _context) async {
    await AppUtil.saveToSettting(Constants.PREF_INREVIEW, 'false');
    try {
      String platform = 'android';
      if (UniversalPlatform.isAndroid) {
        // Android-specific code
        platform = 'android';
      } else if (UniversalPlatform.isIOS) {
        // iOS-specific code
        platform = 'ios';
      }

      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();
      final QueryResult result =
          await apiController.requestGetAppConfig(_context, platform);
      AppUtil.showLog('Response requestGetAppConfig: ${result.data}');
      final responseData = appUtil.processResponse(result);
      if (responseData != null) {
        final int code = responseData.code;
        final String message = responseData.message;
        final Map data = responseData.data;
        AppUtil.showLog('requestGetAppConfig code: $code, message: $message');

        if (code == 0) {
          //Login thành công
          final AppConfigData responseData = AppConfigData.fromJsonMap(data);
          AppUtil.showLog(
              'requestRegisterDevice: ${jsonEncode(responseData.toJson())}');
          final PackageInfo packageInfo = await PackageInfo.fromPlatform();

          final String version = packageInfo.version;
          AppUtil.showLog('PackageInfo version: $version');
          final List<String> listVersion =
              responseData.versionReview.split(',');
          for (final String versionReview in listVersion) {
            if (version == versionReview) {
              inReview = 'true';

              AppUtil.showLog('PREF_INREVIEW: $inReview');
              await AppUtil.saveToSettting(Constants.PREF_INREVIEW, inReview);
              //Trường hợp review ==> vào thẳng trang home
              await Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) {
                return const ScreenHome();
              }), (Route<dynamic> route) => false);

              setState(() {
                if (responseData.registerable == true) {
                  isShowRegisterButton = true;
                } else {
                  isShowRegisterButton = false;
                }
              });
            }
          }
          AppUtil.showLog('PREF_INREVIEW: $inReview');
          await AppUtil.saveToSettting(Constants.PREF_INREVIEW, inReview);

          if (version == responseData.version) {
          } else {
            if (responseData.description != null) {
              //Phải thông báo cập nhật
              if (responseData.forceUpdate == true) {
                final ConfirmAction action = await appUtil.asyncConfirmDialog(
                    context, 'Thông báo', responseData.description);
                if (action == ConfirmAction.ACCEPT) {
                  // OpenAppstore.launch(androidAppId: "com.elsaga.dkptnoibo", iOSAppId: "1526229828");
                  await SystemChannels.platform
                      .invokeMethod<void>('SystemNavigator.pop');
                } else if (action == ConfirmAction.CANCEL) {
                  //Tắt app
                  await SystemChannels.platform
                      .invokeMethod<void>('SystemNavigator.pop');
                }
              } else {
                if (responseData.description != null &&
                    responseData.description.isNotEmpty) {
                  final ConfirmAction action = await appUtil.asyncConfirmDialog(
                      context, 'Thông báo', responseData.description);
                  if (action == ConfirmAction.ACCEPT) {
                    // OpenAppstore.launch(androidAppId: "com.elsaga.dkptnoibo", iOSAppId: "1526229828");
                  }
                }
              }
            }
          }
        } else {
          await AppUtil.hideLoadingDialog(_context);
          await AppUtil.showPopup(_context, 'Thông báo', message);
        }
      } else {
//        AppUtil.hideLoadingDialog(_context);
        AppUtil.showLog('requestRegisterDevice: Response NULL');
      }
    } on Exception catch (e) {
      AppUtil.showLog('requestRegisterDevice Error: $e');
    }
  }

  bool isShowPass = true;

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoginButtonPressed() {
    setState(() {
      usernameTextController.text.isEmpty
          ? _validateUserName = true
          : _validateUserName = false;
      passwordTextController.text.isEmpty
          ? _validatePassword = true
          : _validatePassword = false;
    });
    if (usernameTextController.text.isEmpty ||
        passwordTextController.text.isEmpty) {
      appUtil.showToast(context, 'Vui lòng nhập đủ thông tin');
      return;
    }

    BlocProvider.of<LoginBloc>(context).add(
      ButtonLoginClickEvent(
          usernameTextController.text, passwordTextController.text, context),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                HexColor.fromHex(Constants.Color_primary),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/logo.png',
                                matchTextDirection: true,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            ),
                          ),
//                logo,
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              dotenv.env['HOSPITAL_NAME'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color(0xFF002154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          inReview == 'false'
                              ? Column(
                                  children: <Widget>[
                                    RoundedInputField(
                                        controller: usernameTextController,
                                        hintText: 'Tên đăng nhập',
                                        icon: Icons.person_outline,
                                        onChange: (String value) {
                                          // sdt = value;
                                        }),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    RoundedInputFieldPass(
                                      controller: passwordTextController,
                                      hintText: 'Mật khẩu',
                                      isObscure: isShowPass,
                                      onChangeObscure: () {
                                        setState(() {
                                          isShowPass = !isShowPass;
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                        transform: Matrix4.translationValues(
                                            -22, 0, 0),
//                      padding: EdgeInsets.fromLTRB(-20, 0, 0, 0),

                                        child: Theme(
                                          data: ThemeData(
                                            checkboxTheme: CheckboxThemeData(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                          child: CheckboxListTile(
                                            activeColor: Constants.colorMain,
                                            title: const Text(
                                              'Ghi nhớ mật khẩu',
                                              style: Constants
                                                  .styleTextNormalBlueColor,
                                            ),
                                            value: isRememberPasswordChecked,
                                            onChanged: (newValue) {
                                              setState(() {
                                                isRememberPasswordChecked =
                                                    newValue;
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    BlocListener<LoginBloc, LoginState>(
                                      listener: (context, state) => {},
                                      child: BlocBuilder<LoginBloc, LoginState>(
                                        builder: (context, state) {
                                          if (state is LoginInitialState) {
                                            return const SizedBox();
                                          } else if (state
                                              is LoginLoadingState) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (state
                                              is LoginLoadedState) {
                                            final http.Response response =
                                                state.responseLoginData;

                                            if (response != null &&
                                                response.statusCode == 200) {
                                              log('Login data: ${response.body}');
                                              final ResponseLoginData userData =
                                                  ResponseLoginData.fromJson(
                                                      jsonDecode(
                                                          response.body));
//        log("Response requestLogin userData: " + json.encode(userData));
                                              AppUtil.saveToSettting(
                                                  Constants.PREF_ACCESSTOKEN,
                                                  userData.accessToken);
                                              if (isRememberPasswordChecked ==
                                                  true) {
                                                AppUtil.saveToSettting(
                                                    Constants.PREF_USERNAME,
                                                    usernameTextController
                                                        .text);
                                                AppUtil.saveToSettting(
                                                    Constants.PREF_PASSWORD,
                                                    passwordTextController
                                                        .text);
                                              } else {
                                                AppUtil.saveToSettting(
                                                    Constants.PREF_USERNAME,
                                                    '');
                                                AppUtil.saveToSettting(
                                                    Constants.PREF_PASSWORD,
                                                    '');
                                              }
                                              SchedulerBinding.instance
                                                  .addPostFrameCallback(
                                                      (_) async {
                                                await Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const ScreenHome()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                                /*      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
                                      return ScreenHome();
                                    }), null);*/
                                                /*     var result = await Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                    '/home', (Route<dynamic> route) => false);
                                AppUtil.showPrint("Result from pop: $result");
                                if (result == 'success') {
                                  appUtil.showToast(
                                      context, "Đăng kí tài khoản thành công!");
                                  loadLoginInfo(context);
//                              reloadData();
                                }*/
                                                return;
//                            return Center(child: Text('Đang xử lý thông tin đăng nhập'));
                                              });

                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .add(
                                                LoginInitialEvent(context),
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'Đăng nhập không thành công'));
                                            }
                                          } else {
                                            if (state is LoginErrorState) {
                                              return const Center(
                                                  child: Text(
                                                      'Đăng nhập không thành công. Vui lòng kiểm tra lại'));
                                            } else {
                                              return const SizedBox();
                                            }
                                          }
                                          if (state is LoginLoadedState) {
                                            return const Center(
                                                child: Text(
                                                    'Đang xử lý thông tin đăng nhập'));
                                          } else if (state is LoginErrorState) {
                                            return const Center(
                                                child: Text(
                                                    'Đăng nhập không thành công. Vui lòng kiểm tra lại'));
                                          } else {
                                            return const Center(
                                                child: Text(
                                                    'Đăng nhập không thành công. Vui lòng kiểm tra lại'));
                                          }
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 12,
                                    ),
//            btnLogin,
                                    RaisedGradientButton(
                                        text: 'Đăng nhập',
                                        onPressed: () {
                                          _onLoginButtonPressed();
                                        }),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    isShowRegisterButton == false
                                        ? const SizedBox(
                                            height: 0,
                                          )
                                        : SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ScreenRegister()),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                      Constants
                                                          .Color_gradient_green_end),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30))),
                                              child: Text(
                                                'ĐĂNG KÝ TÀI KHOẢN',
                                                style: TextStyle(
                                                  color: HexColor.fromHex(
                                                      Constants.Color_bluetext),
                                                ),
                                              ),
                                            )),
                                  ],
                                )
                              : const SizedBox(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),

                          const SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                    ))),
            /*    Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: GestureDetector(
                child: Text('Quên mật khẩu', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.normal, fontSize: 13)),
              ),
            ),
          )*/
          ],
        ),
      );
}
