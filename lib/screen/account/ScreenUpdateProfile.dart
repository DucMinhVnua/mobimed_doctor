import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerAccountMutation.dart';
import '../../design_widget/widget_button_align.dart';
import '../../extension/HexColor.dart';
import '../../model/CommonTypeData.dart';
import '../../model/UserInfoData.dart';
import '../../model/UserInfoInputData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';

// ignore: must_be_immutable
class ScreenUpdateProfile extends StatefulWidget {
  final String title;
  UserInfoData userData;

  ScreenUpdateProfile({Key key, this.title, @required this.userData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenUpdateProfileState();
}

class _ScreenUpdateProfileState extends State<ScreenUpdateProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();
//  RegisterBloc registerBloc;

  TextEditingController textControllerFullName = TextEditingController();
  TextEditingController textControllerPhoneNumber = TextEditingController();
  TextEditingController textControllerEmail = TextEditingController();
  TextEditingController textControllerAddress = TextEditingController();
//  TextEditingController textControllerWork = TextEditingController();
  bool _validateFullName = false,
      _validateAddress = false,
      _validatePhoneNumber = false;
//  String strGender = "2";

  String strGender = '2';
  // ignore: avoid_init_to_null
  CommonTypeData selectedGender = null;
  List<CommonTypeData> arrGender = [];
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_NAM = CommonTypeData('1', 'male', 'Nam');
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_NU = CommonTypeData('2', 'female', 'Nữ');
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_KHAC = CommonTypeData('3', 'other', 'Khác');

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeAddress = FocusNode();
//  final FocusNode _focusNodeWork = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      arrGender.clear();
      // 1 là nam, 2 là nữ
      arrGender.add(GENDER_NU);
      arrGender.add(GENDER_NAM);
      arrGender.add(GENDER_KHAC);
    });

    bindDataIfEdit();
  }

  bindDataIfEdit() async {
//    await requestGetDepartments();

    if (widget.userData != null && widget.userData.base != null) {
      setState(() {
        textControllerFullName.text = widget.userData.base.fullName;
        textControllerPhoneNumber.text = widget.userData.base.phoneNumber;
        textControllerEmail.text = widget.userData.base.email;
        textControllerAddress.text = widget.userData.base.address;
//        textControllerWork.text = widget.userData.base.work;

        if (widget.userData.base.gender != null &&
            widget.userData.base.gender == 'female') {
          selectedGender = GENDER_NU;
        } else {
          selectedGender = GENDER_NAM;
        }

        if (widget.userData.base.birthday != null) {
          selectedBirthDate = widget.userData.base.birthday;
          _controllerTime.text = widget.userData.base.birthday.toString();
        }
      });
    }
  }

  Constants constants = Constants();

  final logo = Container(
      width: 150,
      height: 150,
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

  @override
  void dispose() {
    super.dispose();
  }

  Future _selectBirthDate() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) => Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedBirthDate ?? DateTime.now(),
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  selectedBirthDate = date;
                });
              },
              use24hFormat: false,
              minuteInterval: 1,
            )));
  }

  final TextEditingController _controllerTime =
      TextEditingController(text: DateTime.now().toString());
  Widget viewSelectDay() => GestureDetector(
        onTap: () {
          _selectBirthDate();
        },
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: selectedBirthDate != null
                        ? Text(
//                              strHintDateDisplay,
                            DateFormat(Constants.FORMAT_DATEONLY)
                                .format(selectedBirthDate),
                            style: selectedBirthDate != null
                                ? Constants.styleTextNormalBlueColor
                                : Constants.styleTextNormalHintColor,
                          )
                        : Text(
                            'Chọn ngày sinh',
                            style: TextStyle(
                                color:
                                    HexColor.fromHex(Constants.Color_subtext),
                                fontSize: Constants.Size_text_normal),
                          ),
                  ),
                  Image.asset(
                    'assets/icon_select_date.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color:
                            HexColor.fromHex(Constants.Color_input_underline),
                        width: 1),
                  ),
                ),
              ),
            )
          ],
        ),
      );
  Widget viewSelectDaysss() => DateTimePicker(
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
  Widget build(BuildContext context) {
//    usernameTextController.text = "dungnt";
//    passwordTextController.text = "123456a@";

    final inputFullname = TextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        focusNode: _focusNodeFullName,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _focusNodeFullName, _focusNodePhoneNumber);
        },
        controller: textControllerFullName,
        style: Constants.styleTextNormalBlueColor,
        decoration: constants.getInputDecoration(
            'Nhập Họ tên', _validateFullName, 'Họ tên không được để trống'));
    final inputPhoneNumber = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        focusNode: _focusNodePhoneNumber,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _focusNodePhoneNumber, _focusNodeEmail);
        },
        controller: textControllerPhoneNumber,
        style: Constants.styleTextNormalBlueColor,
        decoration: constants.getInputDecoration('Số điện thoại',
            _validatePhoneNumber, 'Số điện thoại không được để trống'));
    final inputEmail = TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        focusNode: _focusNodeEmail,
        controller: textControllerEmail,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _focusNodeEmail, _focusNodeAddress);
        },
        style: Constants.styleTextNormalBlueColor,
        decoration: constants.getInputDecoration('Nhập Email', null, ''));

    final inputAddress = TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: _focusNodeAddress,
        onFieldSubmitted: (value) {
          appUtil.dismissKeyboard(context);
//          _fieldFocusChange(context, _focusNodeAddress, _passwordFocus);
        },
        controller: textControllerAddress,
        style: Constants.styleTextNormalBlueColor,
        decoration: constants.getInputDecoration(
            'Nhập địa chỉ', _validateAddress, 'Địa chỉ không được để trống'));

//    var arrStrGender = ['Nữ', 'Nam'];
    final inputGender = Row(
      children: <Widget>[
        const SizedBox(
          width: 0,
        ),
        const Expanded(
          child: Text(
            'Giới tính',
            style: Constants.styleTextNormalBlueColor,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: DropdownButton<CommonTypeData>(
            isExpanded: true,
            hint: Row(
              children: const <Widget>[
                SizedBox(
                  width: 12,
                ),
                Text(
                  'Giới tính',
                  style: Constants.styleTextNormalHintColor,
                )
              ],
            ),
            value: selectedGender,
            onChanged: (CommonTypeData value) {
              setState(() {
                selectedGender = value;
              });
            },
            items: arrGender
                .map((CommonTypeData user) => DropdownMenuItem<CommonTypeData>(
                    value: user,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          user.name,
                          style: Constants.styleTextNormalBlueColor,
                        ),
                      ],
                    )))
                .toList(),
          ),
        )
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'CẬP NHẬT THÔNG TIN CÁ NHÂN'),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              inputFullname,
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
              inputAddress,
              const SizedBox(
                height: 8,
              ),
              inputGender,
              const SizedBox(
                height: 8,
              ),
              viewSelectDay(),
              const SizedBox(
                height: 4,
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 58,
              ),
            ],
          ),
//          ),
          WidgetButtonAlign(
            clickButton: () {
              onSubmitButtonPressed(context);
            },
            name: 'CẬP NHẬT',
          )
        ],
      ),
    );
  }

  onSubmitButtonPressed(BuildContext _context) async {
    final String fullName = textControllerFullName.text;
    final String phoneNumber = textControllerPhoneNumber.text;
    final String email = textControllerEmail.text;
    final String address = textControllerAddress.text;

    setState(() {
      fullName.isEmpty ? _validateFullName = true : _validateFullName = false;
      textControllerAddress.text.isEmpty
          ? _validateAddress = true
          : _validateAddress = false;
      textControllerPhoneNumber.text.isEmpty
          ? _validatePhoneNumber = true
          : _validatePhoneNumber = false;
    });
    if (fullName.isEmpty) {
      appUtil.showToastWithScaffoldState(_scaffoldKey, 'Vui lòng nhập họ tên.');
      return;
    }
    if (phoneNumber.isEmpty) {
      _validateFullName = true;
      appUtil.showToastWithScaffoldState(
          _scaffoldKey, 'Vui lòng nhập số điện thoại.');
      return;
    }
    if (address.isEmpty) {
      appUtil.showToastWithScaffoldState(
          _scaffoldKey, 'Vui lòng nhập địa chỉ.');
      return;
    }
    if (selectedBirthDate == null) {
      appUtil.showToastWithScaffoldState(
          _scaffoldKey, 'Vui lòng chọn ngày sinh.');
      return;
    }
//    if (selectedDepartment == null) {
//      appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn phòng/ban.");
//      return;
//    } else {
//      departmentID = selectedDepartment.id;
//    }

    AppUtil.showPrint(
        'Start register: birthDate: ${selectedBirthDate.toIso8601String()}');

    final UserInfoInputData userInfoInputData = UserInfoInputData()
      ..id = widget.userData.id
      ..fullName = fullName
      ..phoneNumber = phoneNumber
      ..email = email
      ..address = address
      ..gender = selectedGender.code
      ..birthday = selectedBirthDate;

    AppUtil.showLoadingDialog(_context);
    try {
      final ApiGraphQLControllerAccountMutation apiGraphQLController =
          ApiGraphQLControllerAccountMutation();
      final QueryResult response = await apiGraphQLController
          .requestUpdateProfile(_context, userInfoInputData);

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
            await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
                messageSuccess: 'Cập nhật thông tin tài khoản thành công',
                okBtnFunction: () {});

            Navigator.pop(context, Constants.SignalSuccess);
          } else {
            appUtil.showToastWithScaffoldState(
                _scaffoldKey, 'Cập nhật thông tin không thành công: $message');
          }
        } catch (ex) {
          appUtil.showToastWithScaffoldState(
              _scaffoldKey, 'Cập nhật thông tin không thành công: $ex');
        }
      } else {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Cập nhật thông tin không thành công');
      }
      AppUtil.hideLoadingDialog(_context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(_context);
      AppUtil.showLog('requestRegister Error: $e');
    }
  }

  backToPreviousScreen() {
    Navigator.of(context).pop('success');
  }
}
