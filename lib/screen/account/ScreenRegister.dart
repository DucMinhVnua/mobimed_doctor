import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../extension/HexColor.dart';
import '../../extension/RaisedGradientButton.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenRegister extends StatefulWidget {
  final String title;
//  bool isLoading = false;

  const ScreenRegister({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();
//  RegisterBloc registerBloc;

  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
//  TextEditingController genderTextController = new TextEditingController();
//  TextEditingController birthDayTextController = new TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  bool _validateFullName = false,
      _validateUserName = false,
      _validatePassword = false,
      _validatePhoneNumber = false;
  String strGender = 'female';

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Constants constants = Constants();

  final logo = Container(
      width: 150.0,
      height: 150.0,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/logo_pshn.png'),
        fit: BoxFit.contain,
      )));

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

  DateTime selectedBirthDate = DateTime.now();

  final TextEditingController _controllerTime =
      TextEditingController(text: DateTime.now().toString());
  Widget viewSelectDay() => DateTimePicker(
        type: DateTimePickerType.date,
        dateMask: 'dd/MM/yyyy',
        controller: _controllerTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1910),
        lastDate: DateTime(2100),
        initialDate: selectedBirthDate,
        icon: Image.asset(
          'assets/icon_select_date.png',
          width: 22,
          height: 22,
          fit: BoxFit.fill,
        ),
        dateLabelText: 'Ngày sinh',
        calendarTitle: 'Chọn ngày sinh',
        cancelText: 'Huỷ bỏ',
        confirmText: 'Xong',
        onChanged: (val) => onSaveDay(val),
        validator: (val) {
          onSaveDay(val);
          return null;
        },
        onSaved: (val) => {onSaveDay(val)},
      );

  onSaveDay(String val) {
    setState(() {
      selectedBirthDate = DateTime.parse(val);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  requestRegister(
      BuildContext _context,
      String fullName,
      String userName,
      String password,
      String phoneNumber,
      String gender,
      String birthday,
      String email) async {
    AppUtil.showLoadingDialog(_context);
    try {
      final ApiGraphQLControllerMutation apiGraphQLController =
          ApiGraphQLControllerMutation();
      final QueryResult response = await apiGraphQLController.requestRegister(
          _context,
          fullName,
          userName,
          password,
          phoneNumber,
          gender,
          birthday,
          email);

      if (response != null) {
        try {
          final responseData = appUtil.processResponse(response);
          final int code = responseData.code;
          final String message = responseData.message;
          AppUtil.showPrint('### jsonData message: $message');
          if (code == 0) {
            final String jsonData = json.encode(responseData.data);
            AppUtil.showPrint('### jsonData: $jsonData');
            AppUtil.hideLoadingDialog(_context);
            await AppUtil.showPopup(
                _context, 'Thông báo', 'Đăng ký tài khoản thành công');
//            await appUtil.showPopupWithFunction(_context, "Thông báo",  "Đăng ký tài khoản thành công", backToPreviousScreen());
            Navigator.of(context).pop('success');
          } else {
            appUtil.showToastWithScaffoldState(
                _scaffoldKey, 'Đăng ký không thành công: $message');
          }
        } catch (ex) {
          appUtil.showToastWithScaffoldState(
              _scaffoldKey, 'Đăng ký không thành công: $ex');
        }
      } else {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Đăng ký không thành công');
      }
      AppUtil.hideLoadingDialog(_context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(_context);
      AppUtil.showLog('requestRegister Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
//    usernameTextController.text = "dungnt";
//    passwordTextController.text = "123456a@";

    final inputFullname = TextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        focusNode: _fullNameFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _fullNameFocus, _usernameFocus);
        },
        controller: fullNameTextController,
        decoration: InputDecoration(
//          enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(color: Color(0xFF009BE0), width: 1.0),
//          ),
          contentPadding: const EdgeInsets.all(13.0),
          errorText: _validateFullName ? 'Họ tên không được để trống' : null,
          hintText: 'Họ tên',
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF009BE0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF97DFFF)),
          ),
          /*  border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF009BE0)))
              ,*/
        ));
    final inputUsername = TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: _usernameFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _usernameFocus, _passwordFocus);
        },
        controller: usernameTextController,
        decoration: InputDecoration(
//          enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(color: Color(0xFF009BE0), width: 1.0),
//          ),
          contentPadding: const EdgeInsets.all(13.0),
          errorText:
              _validateUserName ? 'Tên đăng nhập không được để trống' : null,
          hintText: 'Tên đăng nhập',
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF009BE0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF97DFFF)),
          ),
          /*  border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF009BE0)))
              ,*/
        ));
    final inputPassword = TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _passwordFocus,
      onFieldSubmitted: (value) {
        _fieldFocusChange(context, _passwordFocus, _confirmPasswordFocus);
      },
      obscureText: true,
      controller: passwordTextController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(13.0),
        errorText: _validatePassword ? 'Mật khẩu không được để trống' : null,
        hintText: 'Mật khẩu',
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Color(0xFF009BE0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Color(0xFF97DFFF)),
        ),
        /*     border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xFF009BE0)))*/
      ),
    );
    final inputConfirmPassword = TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: _confirmPasswordFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _confirmPasswordFocus, _phoneNumberFocus);
        },
        obscureText: true,
        controller: confirmPasswordTextController,
        decoration: const InputDecoration(
//          enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(color: Color(0xFF009BE0), width: 1.0),
//          ),
          contentPadding: EdgeInsets.all(13.0),
          hintText: 'Xác nhận mật khẩu',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF009BE0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF97DFFF)),
          ),
          /*  border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF009BE0)))
              ,*/
        ));
    final inputPhoneNumber = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        focusNode: _phoneNumberFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _phoneNumberFocus, _emailFocus);
        },
        controller: phoneNumberTextController,
        decoration: InputDecoration(
//          enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(color: Color(0xFF009BE0), width: 1.0),
//          ),
          contentPadding: const EdgeInsets.all(13.0),
          errorText:
              _validatePhoneNumber ? 'Số điện thoại không được để trống' : null,
          hintText: 'Số điện thoại',
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF009BE0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF97DFFF)),
          ),
          /*  border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF009BE0)))
              ,*/
        ));
    final inputEmail = TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        focusNode: _emailFocus,
        /*    onFieldSubmitted: (value) {
          _fieldFocusChange(context, _phoneNumberFocus, _emailFocus);
        },*/
        controller: emailTextController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(13.0),
          hintText: 'Email',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF009BE0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xFF97DFFF)),
          ),
          /*  border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF009BE0)))
              ,*/
        ));
    final arrStrGender = ['Nữ', 'Nam'];
    final inputGender = Row(
      children: <Widget>[
        SizedBox(
          width: 104,
          child: Text(
            'Giới tính:',
            style: TextStyle(
                fontSize: Constants.Size_text_normal,
                color: HexColor.fromHex(Constants.Color_maintext)),
          ),
        ),
        Expanded(
          flex: 1,
          child: DropdownButton<String>(
            hint: const Text('Status'),
            value: strGender == 'male' ? 'Nam' : 'Nữ',
            items: arrStrGender
                .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                              fontSize: Constants.Size_text_normal,
                              color:
                                  HexColor.fromHex(Constants.Color_maintext))),
                    ))
                .toList(),
            onChanged: (String val) {
              setState(() {
                if (val == 'Nam') {
                  strGender = 'male';
                } else {
                  strGender = 'female';
                }
              });
            },
          ),
        ),
      ],
    );

    _onRegisterButtonPressed(BuildContext _context) {
      final String fullName = fullNameTextController.text;
      final String userName = usernameTextController.text;
      final String password = passwordTextController.text;
      final String confirmPassword = confirmPasswordTextController.text;
      final String phoneNumber = phoneNumberTextController.text;
      final String email = emailTextController.text;
//      String gender = fullNameTextController.text;
      final String birthDay = (selectedBirthDate != null)
          ? selectedBirthDate.toIso8601String()
          : '';

      setState(() {
        fullName.isEmpty ? _validateFullName = true : _validateFullName = false;
        usernameTextController.text.isEmpty
            ? _validateUserName = true
            : _validateUserName = false;
        passwordTextController.text.isEmpty
            ? _validatePassword = true
            : _validatePassword = false;
        phoneNumberTextController.text.isEmpty
            ? _validatePhoneNumber = true
            : _validatePhoneNumber = false;
      });
      if (fullName.isEmpty) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập họ tên.');
        return;
      }
      if (userName.isEmpty) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập tên đăng nhập.');
        return;
      }
      if (password.isEmpty) {
        _validateFullName = true;
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập mật khẩu.');
        return;
      }
      if (confirmPassword.isEmpty || confirmPassword != password) {
        _validateFullName = true;
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Xác nhân mật khẩu chưa chính xác.');
        return;
      }
      if (phoneNumber.isEmpty) {
        _validateFullName = true;
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập số điện thoại.');
        return;
      }
      if (selectedBirthDate == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn ngày sinh.');
        return;
      }

      AppUtil.showPrint('Start register: birthDate: $birthDay');
      /*  BlocProvider.of<RegisterBloc>(_context).add(
        ButtonRegisterClickEvent(fullName, userName, password, phoneNumber,
            strGender, birthDay, email, _context),
      );*/
      requestRegister(_context, fullName, userName, password, phoneNumber,
          strGender, birthDay, email);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'Đăng ký tài khoản'),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 50, right: 50, bottom: 15),
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              inputFullname,
              const SizedBox(
                height: 8,
              ),
              inputUsername,
              const SizedBox(
                height: 8,
              ),
              inputPassword,
              const SizedBox(
                height: 8,
              ),
              inputConfirmPassword,
              const SizedBox(
                height: 8,
              ),
              inputPhoneNumber,
              const SizedBox(
                height: 8,
              ),
              inputEmail,
              const SizedBox(
                height: 8,
              ),
              inputGender,
              const SizedBox(
                height: 8,
              ),
              viewSelectDay(),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 18,
              ),
//            btnRegister,
              RaisedGradientButton(
                  text: 'Đăng ký',
                  onPressed: () {
                    _onRegisterButtonPressed(context);
                  }),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
//          ),
        ],
      ),
    );
  }

  backToPreviousScreen() {
    Navigator.of(context).pop('success');
  }
}
