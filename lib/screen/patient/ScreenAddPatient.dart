import 'dart:convert';

//import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../insuranceqrhandle/QrCodeInsuConverter.dart';
import '../../insuranceqrhandle/QrInfos.dart';
import '../../model/AddressData.dart';
import '../../model/BaseTypeData.dart';
import '../../model/CommonTypeData.dart';
import '../../model/GraphQLModels.dart';
import '../../model/PatientData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'ScreenDatKham.dart';

class ScreenAddPatient extends StatefulWidget {
  final PatientData userInfoData;

  const ScreenAddPatient({Key key, this.userInfoData}) : super(key: key);

  @override
  _ScreenAddPatientState createState() => _ScreenAddPatientState();
}

class _ScreenAddPatientState extends State<ScreenAddPatient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();
  Constants constants = Constants();
  String title = 'THÊM BỆNH NHÂN';

//  TextEditingController textControllerLastName = TextEditingController();
//  TextEditingController textControllerMiddleName = TextEditingController();
//  TextEditingController textControllerFirstName = TextEditingController();
  TextEditingController textControllerFullName = TextEditingController();
  TextEditingController textControllerPhoneNumber = TextEditingController();
  TextEditingController textControllerStreet = TextEditingController();
  TextEditingController textControllerInsuranceCode = TextEditingController();

//  final FocusNode focusNodeLastName = FocusNode();
//  final FocusNode focusNodeMiddleName = FocusNode();
//  final FocusNode focusNodeFirstName = FocusNode();
  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodePhoneNumber = FocusNode();
  final FocusNode focusNodeAddress = FocusNode();
  final FocusNode focusNodeInsuranceCode = FocusNode();

  bool _validateFullName = false, _validatePhoneNumber = false;
//  bool _validateLastName = false, _validateFirstName = false, _validatePhoneNumber = false;
  String strGender = '2';
  // ignore: avoid_init_to_null
  CommonTypeData selectedGender = null;
  List<CommonTypeData> arrGender = [];

  // ignore: avoid_init_to_null
  DateTime selectedBirthDate = null;
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_NAM = CommonTypeData('1', '1', 'Nam');
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_NU = CommonTypeData('2', '2', 'Nữ');
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_KHAC = CommonTypeData('3', '3', 'Khác');

  bool isLoadingDataProvince = false,
      isLoadingDataDistrict = false,
      isLoadingDataWard = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      arrGender
        ..clear()
        ..add(GENDER_NU)
        ..add(GENDER_NAM)
        ..add(GENDER_KHAC);
      selectedGender = GENDER_NU;
    });

    bindDataIfEdit();
  }

  void bindDataIfEdit() {
    if (widget.userInfoData != null) {
      setState(() {
        title = 'SỬA THÔNG TIN BỆNH NHÂN';
//        textControllerFirstName.text = widget.userInfoData.firstName;
//        textControllerMiddleName.text = widget.userInfoData.middleName;
//        textControllerLastName.text = widget.userInfoData.lastName;
        textControllerFullName.text = widget.userInfoData.fullName;
//        textControllerRelationShipName.text =
//            widget.userInfoData.relationshipName;
        textControllerPhoneNumber.text = widget.userInfoData.phoneNumber;
//        textControllerCMND.text = widget.userInfoData.nationIdentification;
        textControllerStreet.text = widget.userInfoData.street;

        if (widget.userInfoData.gender != null &&
            widget.userInfoData.gender == '1') {
          selectedGender = GENDER_NAM;
        } else {
          selectedGender = GENDER_NU;
        }

        if (widget.userInfoData.birthDay != null) {
          selectedBirthDate = widget.userInfoData.birthDay;
        }
      });

//      AppUtil.showPrint("arrProvinces size: " + arrProvinces.length.toString());
//      AppUtil.showPrint("arrDistricts size: " + arrDistricts.length.toString());
//      AppUtil.showPrint("arrWards size: " + arrWards.length.toString());
      if (widget.userInfoData.nationality != null) {
        requestGetNationalities(true);
      } else {
        //luôn phải load dữ liệu nationality
        requestGetNationalities(false);
      }
      if (widget.userInfoData.nation != null) {
        requestGetNations(true);
      } else {
        requestGetNations(false);
      }
      if (widget.userInfoData.work != null) {
        requestGetWorks(true);
      } else {
        requestGetWorks(false);
      }

      if (widget.userInfoData.province != null) {
        requestGetProvinces(true);
      } else {
        //luôn phải load dữ liệu province
        requestGetProvinces(false);
      }
      if (widget.userInfoData.district != null) {
        requestGetDistrict(widget.userInfoData.province.code, true);
      }
      if (widget.userInfoData.ward != null) {
        requestGetWards(widget.userInfoData.district.code, true);
      }
    } else {
//      requestGetProvinces(false);
      requestGetNationalities(false);
      requestGetNations(false);
      requestGetProvinces(false);
      requestGetWorks(false);
    }
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

  Widget viewSearchNations() => SearchChoices.single(
      items: arrNations
          .map((BaseTypeData item) => DropdownMenuItem(
                value: item.name,
                onTap: () {
                  setState(() {
                    selectedNation = item;
                  });
                },
                child: Text(
                  item.name,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ))
          .toList(),
      style: Constants.styleTextNormalBlueColor,
      value: selectedNation?.name,
      hint: 'Chọn dân tộc',
      searchHint: 'Chọn dân tộc',
      onChanged: (BaseTypeData value) {
        setState(() {
          selectedNation = value;
        });
      },
      isExpanded: true,
      closeButton: 'Đóng');

  Widget viewSearchWards() => SearchChoices.single(
      items: arrWards
          .map((AddressData item) => DropdownMenuItem(
                value: item.name,
                onTap: () {
                  setState(() {
                    selectedWard = item;
                  });
                },
                child: Text(
                  item.name,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ))
          .toList(),
      style: Constants.styleTextNormalBlueColor,
      value: selectedWard?.name,
      hint: 'Chọn phường/xã',
      searchHint: 'Chọn phường/xã',
      onChanged: (AddressData value) {
        setState(() {
          selectedWard = value;
        });
      },
      isExpanded: true,
      closeButton: 'Đóng');
  Widget viewSearchDistricts() => SearchChoices.single(
      items: arrDistricts
          .map((AddressData item) => DropdownMenuItem(
                value: item.name,
                onTap: () {
                  setState(() {
                    selectedDistrict = item;
                    isLoadingDataWard = true;
                    requestGetWards(item.code, false);
                  });
                },
                child: Text(
                  item.name,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ))
          .toList(),
      style: Constants.styleTextNormalBlueColor,
      value: selectedDistrict?.name,
      hint: 'Chọn quận/huyện',
      searchHint: 'Chọn quận/huyện',
      onChanged: (AddressData value) {
        setState(() {
          selectedDistrict = value;
          isLoadingDataWard = true;
          requestGetWards(value.code, false);
        });
      },
      isExpanded: true,
      closeButton: 'Đóng');

  Widget viewSearchProvinces() => SearchChoices.single(
      items: arrProvinces
          .map((BaseTypeData item) => DropdownMenuItem(
                value: item.name,
                onTap: () {
                  setState(() {
                    selectedProvince = item;
                    isLoadingDataDistrict = true;
                    requestGetDistrict(item.code, false);
                  });
                },
                child: Text(
                  item.name,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ))
          .toList(),
      style: Constants.styleTextNormalBlueColor,
      value: selectedProvince?.name,
      hint: 'Chọn tỉnh/ thành phố',
      searchHint: 'Chọn tỉnh/ thành phố',
      onChanged: (BaseTypeData value) {
        setState(() {
          selectedProvince = value;
          isLoadingDataDistrict = true;
          requestGetDistrict(value.code, false);
        });
      },
      isExpanded: true,
      closeButton: 'Đóng');
  Widget viewSearchNationality() => SearchChoices.single(
      items: arrNationalitys
          .map((BaseTypeData item) => DropdownMenuItem(
                value: item.name,
                onTap: () {
                  setState(() {
                    selectedNationality = item;
                  });
                },
                child: Text(
                  item.name,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ))
          .toList(),
      style: Constants.styleTextNormalBlueColor,
      value: selectedNationality?.name,
      hint: 'Chọn quốc gia',
      searchHint: 'Chọn quốc gia',
      onChanged: (BaseTypeData value) {
        setState(() {
          selectedNationality = value;
        });
      },
      isExpanded: true,
      closeButton: 'Đóng');

  Widget viewSearchWork() => SearchChoices.single(
      items: arrWorks
          .map((BaseTypeData item) => DropdownMenuItem(
                value: item.name,
                onTap: () {
                  setState(() {
                    selectedWork = item;
                  });
                },
                child: Text(
                  item.name,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ))
          .toList(),
      style: Constants.styleTextNormalBlueColor,
      value: selectedWork?.name,
      hint: 'Chọn ngành nghề',
      searchHint: 'Chọn ngành nghề',
      onChanged: (BaseTypeData value) {
        setState(() {
          selectedWork = value;
        });
      },
      isExpanded: true,
      closeButton: 'Đóng');

  @override
  Widget build(BuildContext context) {
    final inputFullName = TextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        focusNode: focusNodeFullName,
        style: Constants.styleTextNormalBlueColor,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, focusNodeFullName, focusNodePhoneNumber);
        },
        controller: textControllerFullName,
        decoration: InputDecoration(
//            contentPadding: const EdgeInsets.all(13.0),
            errorText: _validateFullName ? 'Họ tên không được để trống' : null,
            hintText: 'Nhập họ tên ',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: HexColor.fromHex(Constants.Color_divider)))));
    final inputPhoneNumber = TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: focusNodePhoneNumber,
        keyboardType: TextInputType.phone,
        onFieldSubmitted: (value) {
          _fieldFocusChange(
              context, focusNodePhoneNumber, focusNodeInsuranceCode);
        },
        controller: textControllerPhoneNumber,
        style: Constants.styleTextNormalBlueColor,
        decoration:
//        constants.getInputDecoration("Nhập số điện thoại", _validatePhoneNumber, 'Số điện thoại không được để trống')
            InputDecoration(
                errorText: _validatePhoneNumber
                    ? 'Số điện thoại không được để trống'
                    : null,
                hintText: 'Nhập số điện thoại',
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: HexColor.fromHex(Constants.Color_divider)))));
    final inputAddress = TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: focusNodeAddress,
        style: Constants.styleTextNormalBlueColor,
        onFieldSubmitted: (value) {
//          _fieldFocusChange(context, focusNodeAddress, focusNodeInsuranceCode);
          appUtil.dismissKeyboard(context);
        },
        controller: textControllerStreet,
        decoration: InputDecoration(
//            contentPadding: const EdgeInsets.all(13.0),
//            errorText: _validatePhoneNumber ? 'Số điện thoại không được để trống' : null,
            hintText: 'Nhập số nhà/tên đường/khu',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: HexColor.fromHex(Constants.Color_divider)))));
    final inputInsuranceCode = TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: focusNodeInsuranceCode,
//        keyboardType: TextInputType.phone,
        style: Constants.styleTextNormalBlueColor,
        onFieldSubmitted: (value) {
//          _fieldFocusChange(context, focusNodePhoneNumber, _passwordFocus);
          appUtil.dismissKeyboard(context);
        },
        controller: textControllerInsuranceCode,
        decoration: InputDecoration(
//            contentPadding: const EdgeInsets.all(13.0),
//            errorText: _validatePhoneNumber ? 'Số điện thoại không được để trống' : null,
            hintText: 'Nhập mã BHYT',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: HexColor.fromHex(Constants.Color_divider)))));

    return GestureDetector(
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
//            appBar: appUtil.getAppBar(new Text("THÊM BỆNH NHÂN")),
            appBar: AppUtil.customAppBar(context, title),
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // Add your onPressed code here!
//                String cameraScanResult = await scanner.scan();
                String qrcode;
                try {
                  //final result = await BarcodeScanner.scan();
                  final result = null;
                  AppUtil.showPrint(result
                      .type); // The result type (barcode, cancelled, failed)
                  AppUtil.showPrint(result.rawContent); // The barcode content
                  AppUtil.showPrint(
                      result.format); // The barcode format (as enum)
                  AppUtil.showPrint(result.formatNote); //
//                  qrcode = await FlutterPluginQrcode.getQRCode;

                  qrcode = result.rawContent;
                  final QrCodeInsuConverter qrCodeInverter =
                      QrCodeInsuConverter();
//      barcodeScanRes = r'''TE1252521650840|59c3aa6e2042e1baa36f204368c3a275|15/11/2017|2|6b687520342c205468e1bb8b207472e1baa56e205468616e68205468e1bba7792c20487579e1bb876e205468616e6820546875e1bbb72c2054e1bb896e68205068c3ba205468e1bb8d|25 - 005|15/11/2017|-|22/01/2018|25122521650840|yên th? hi?p|4|15/11/2022|3dc98f0b6e690184-7102|$''';
                  final QrInfos qrInfos =
                      qrCodeInverter.convertFromCode(qrcode);
                  try {
                    if (qrInfos != null) {
                      AppUtil.showLog(
                          'QrCodeInsuConverter Result: ${qrInfos.Hoten}');

                      setState(() {
                        if (qrInfos.Hoten != null && qrInfos.Hoten.isNotEmpty) {
                          textControllerFullName.text = qrInfos.Hoten;
                        }
                        textControllerInsuranceCode.text = qrInfos.code;

                        if (qrInfos.ngaysinh != null) {
                          String formattedDate =
                              DateFormat(Constants.FORMAT_DATEONLY)
                                  .format(qrInfos.ngaysinh);
                          selectedBirthDate = qrInfos.ngaysinh;
//                          selectedBirthDate = formattedDate;
                        }
                        if (qrInfos.gioitinh != null &&
                            qrInfos.gioitinh == false) {
                          //nữ
//                          _radioValue1 = 1;
                          selectedGender = GENDER_NU;
                        } else {
                          selectedGender = GENDER_NAM;
                        }
                      });

//                      searchUserByInsuranceCode(qrInfos.code);
                    }
                  } on Exception catch (e) {
                    e.toString();
                  }
                } on PlatformException {
                  qrcode = 'Failed to get platform version.';
                }
                AppUtil.showLog('QRCode ScanResult: $qrcode');
              },
              backgroundColor: Constants.colorMain,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/scan_qr.png',
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 14,
                          ),
                          /*    inputLastName,
                          SizedBox(
                            height: 4,
                          ),
                          inputMiddleName,
                          SizedBox(
                            height: 4,
                          ),
                          inputFirstName,
                          SizedBox(
                            height: 4,
                          ),*/
                          inputFullName,
                          const SizedBox(
                            height: 4,
                          ),
                          inputPhoneNumber,
                          const SizedBox(
                            height: 4,
                          ),
                          inputInsuranceCode,
                          const SizedBox(
                            height: 4,
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectBirthDate();
                            },
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: selectedBirthDate != null
                                            ? Text(
//                              strHintDateDisplay,
                                                DateFormat(Constants
                                                        .FORMAT_DATEONLY)
                                                    .format(selectedBirthDate),
                                                style: selectedBirthDate != null
                                                    ? Constants
                                                        .styleTextNormalBlueColor
                                                    : Constants
                                                        .styleTextNormalHintColor,
                                              )
                                            : Text(
                                                'Chọn ngày sinh',
                                                style: TextStyle(
                                                    color: HexColor.fromHex(
                                                        Constants
                                                            .Color_subtext),
                                                    fontSize: Constants
                                                        .Size_text_normal),
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
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: HexColor.fromHex(Constants
                                                .Color_input_underline),
                                            width: 1.0),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          DropdownButton<CommonTypeData>(
                            isExpanded: true,
                            hint: const Text(
                              'Giới tính',
                              style: Constants.styleTextNormalHintColor,
                            ),
                            value: selectedGender,
                            onChanged: (CommonTypeData value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            items: arrGender
                                .map((CommonTypeData user) =>
                                    DropdownMenuItem<CommonTypeData>(
                                      value: user,
                                      child: Text(
                                        user.name,
                                        style:
                                            Constants.styleTextNormalBlueColor,
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: viewSearchNationality())
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: viewSearchProvinces()),
                              viewLoad(isLoadingDataProvince)
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: viewSearchDistricts()),
                              viewLoad(isLoadingDataDistrict)
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          viewSearchWards(),
                          const SizedBox(
                            height: 4,
                          ),
                          inputAddress,
                          const SizedBox(
                            height: 4,
                          ),
                          viewSearchNations(),
                          viewSearchWork(),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 25),
                        height: 50,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          color: HexColor.fromHex(Constants.Color_primary),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.userInfoData == null
                                      ? 'TẠO BỆNH NHÂN'
                                      : 'CẬP NHẬT',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () async {
                        onClickSavePatient();
                      },
                    )),
              ],
            )));
  }

  Widget viewLoad(bool isCheck) => isCheck
      ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            backgroundColor: Colors.black26,
          ),
        )
      : const SizedBox();

  void onClickSavePatient() {
    try {
      /*    if (textControllerLastName.text.trim().length == 0) {
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng nhập họ bệnh nhân");
        return;
      }
      if (textControllerFirstName.text.trim().length == 0) {
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng nhập tên bệnh nhân");
        return;
      }*/
      if (textControllerFullName.text.trim().isEmpty) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập họ tên bệnh nhân');
        return;
      }
      if (textControllerPhoneNumber.text.trim().isEmpty) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập số điện thoại bệnh nhân');
        return;
      }
      if (selectedBirthDate == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn ngày sinh');
        return;
      }
      if (selectedGender == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn giới tính');
        return;
      }
      if (selectedNationality == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn quốc gia');
        return;
      }
      if (selectedProvince == null ||
          selectedDistrict == null ||
          selectedWard == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng nhập địa chỉ');
        return;
      }
      if (selectedNation == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn dân tộc');
        return;
      }
      if (selectedWork == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn nghề nghiệp');
        return;
      }

      final PatientData patientInputData = PatientData();
      if (widget.userInfoData != null) {
        //Trường hợp chỉ cập nhật thông tin người dùng
        patientInputData
          ..id = widget.userInfoData.id
          ..patientCode = widget.userInfoData.patientCode;
      }
//      patientInputData.lastName = textControllerLastName.text;
//      patientInputData.middleName = textControllerMiddleName.text;
//      patientInputData.firstName = textControllerFirstName.text;
      patientInputData
        ..fullName = textControllerFullName.text
        ..phoneNumber = textControllerPhoneNumber.text
        ..birthDay = selectedBirthDate
        ..gender = selectedGender.id
        ..nationality = selectedNationality
        ..province = selectedProvince
        ..district = BaseTypeData(selectedDistrict.name, selectedDistrict.code)
        ..ward = BaseTypeData(selectedWard.name, selectedWard.code)
        ..street = textControllerStreet.text
        ..nation = selectedNation
        ..work = selectedWork
        ..insuranceCode = textControllerInsuranceCode.text;

      requestSavePatient(context, patientInputData);
    } catch (e) {
      AppUtil.showPrint(e);
    }
  }

  Future<void> requestSavePatient(
      BuildContext context, PatientData patientInputData) async {
    try {
      AppUtil.showLoadingDialog(context);
      final ApiGraphQLControllerMutation apiController =
          ApiGraphQLControllerMutation();

      final QueryResult result =
          await apiController.requestUpdatePatient(context, patientInputData);
      final String response = result.data.toString();
      AppUtil.showLogFull('Response requestSavePatient: $response');
      await AppUtil.hideLoadingDialog(context);
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showPrint('### jsonData: $jsonData');
//          setState(() async {
          final PatientData itemData =
              PatientData.fromJsonMap(jsonDecode(jsonData));
          AppUtil.showPrint(
              '### PatientData: ${jsonEncode(itemData.toString())}');

          if (widget.userInfoData != null) {
            //Trường hợp chỉ cập nhật thông tin người dùng ==> back lại trang trước
            Navigator.pop(context, Constants.SignalSuccess);
          } else {
            final ConfirmAction action = await appUtil.asyncConfirmDialog(
                context,
                'Thông báo',
                'Thêm bệnh nhân thành công. Bạn có muốn đặt khám cho bệnh nhân này?');
            if (action == ConfirmAction.ACCEPT) {
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
                Navigator.pop(context, Constants.SignalSuccess);
              }
            } else {
              Navigator.pop(context, Constants.SignalSuccess);
            }
          }

          /*     String reason = await DialogUtil.showDialogCreatePatientSuccess(_scaffoldKey, context, patientCode: itemData.patientCode, okBtnFunction: () {});
          reason != null ? AppUtil.showLog("dialogResult Reason: " + reason) : "dialogResult NULL";
          if (reason != null) {
            requestCreateAppointmentOffline(context, itemData.patientCode, reason, itemData.id);
          } else {
//            Navigator.pop(context);
//            bool dialogResult = await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context, messageSuccess: "Đổi mật khẩu thành công!", okBtnFunction: () {});

            Navigator.pop(context, Constants.SignalSuccess);
          }*/
//          });
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      await AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      await AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestSavePatient Error: $e');
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  List<BaseTypeData> arrNationalitys = [];
  List<BaseTypeData> arrProvinces = [];
  List<AddressData> arrDistricts = [];
  List<AddressData> arrWards = [];
  List<BaseTypeData> arrNations = [];
  List<BaseTypeData> arrWorks = [];
  // ignore: avoid_init_to_null
  BaseTypeData selectedNationality = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedNation = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedProvince = null;
  // ignore: avoid_init_to_null
  AddressData selectedDistrict = null;
  // ignore: avoid_init_to_null
  AddressData selectedWard = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedWork = null;
//  BaseTypeData selectedNationality = BaseTypeData("", "", "", "");
//  BaseTypeData selectedNation = BaseTypeData("", "", "", "");
//  BaseTypeData selectedProvince = BaseTypeData("", "", "", "");
//  FullAddressData selectedDistrict = FullAddressData("", "", "", "");
//  FullAddressData selectedWard = FullAddressData("", "", "", "");
  Future<void> requestGetNations(bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedNation = null;
        arrNations.clear();
      });
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
//      arrFilterinput.add(FilteredInput("fullName", keySearch, ""));
//      arrSortedinput.add(SortedInput("createdTime", true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetNations(
          context, 0, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNations: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetNations: $jsonData');
          setState(() {
            arrNations = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if (arrNations != null && arrNations.length > 0) {
//              selectedNation = arrNations[0];
//            }
          });
          if (isBindDataForEdit == true && widget.userInfoData.nation != null) {
            setState(() {
              for (final tmpItem in arrNations) {
                if (tmpItem.code == widget.userInfoData.nation.code) {
                  AppUtil.showLog(
                      'From persion nation: ${widget.userInfoData.nation.toJson()}');
                  AppUtil.showLog('From   ward  nation: ${tmpItem.toJson()}');
                  selectedNation = tmpItem;
                }
              }
            });
          } else if (arrNations != null && arrNations.isNotEmpty) {
            for (final tmpItem in arrNations) {
              if (tmpItem != null &&
                  tmpItem.code != null &&
                  tmpItem.code == dotenv.env['CODE_DEFAULT_Nation']) {
                setState(() {
                  selectedNation = tmpItem;
                });
              }
            }
          }
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
  }

  Future<void> requestGetNationalities(bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedNationality = null;
        arrNationalitys.clear();
      });
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetNationalities(
          context, 0, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNationalitys: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetNationalitys: $jsonData');
          setState(() {
            arrNationalitys = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if (arrNationalitys != null && arrNationalitys.length > 0) {
//              selectedNationality = arrNationalitys[0];
//            }
          });
          if (isBindDataForEdit == true &&
              widget.userInfoData.nationality != null) {
            setState(() {
              for (final tmpItem in arrNationalitys) {
                if (tmpItem.code == widget.userInfoData.nationality.code) {
                  AppUtil.showLog(
                      'From persion nationality: ${widget.userInfoData.nationality.toJson()}');
                  AppUtil.showLog(
                      'From   ward  nationality: ${tmpItem.toJson()}');
                  selectedNationality = tmpItem;
                }
              }
            });
          } else if (arrNationalitys != null && arrNationalitys.isNotEmpty) {
            for (final tmpItem in arrNationalitys) {
              if (tmpItem != null &&
                  tmpItem.code != null &&
                  tmpItem.code == dotenv.env['CODE_DEFAULT_Nationality']) {
                setState(() {
                  selectedNationality = tmpItem;
                });
              }
            }
          }
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
  }

  Future<void> requestGetWorks(bool isBindDataForEdit) async {
    try {
      setState(() {
//        isLoadingDataWorks = true;
        selectedWork = null;
        arrWorks.clear();
      });
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetWorks(context);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetWorks: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetWorks: $jsonData');
          setState(() {
//            isLoadingDataWorks = false;
            arrWorks = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true && widget.userInfoData.work != null) {
            setState(() {
              for (final tmpItem in arrWorks) {
                if (tmpItem.code == widget.userInfoData.work.code) {
                  AppUtil.showLog(
                      'From persion work: ${widget.userInfoData.work.toJson()}');
                  AppUtil.showLog('From   ward  work: ${tmpItem.toJson()}');
                  selectedWork = tmpItem;
                }
              }
            });
          }
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetWorks Error: $e');
    }
  }

  Future<void> requestGetProvinces(bool isBindDataForEdit) async {
    try {
      setState(() {
        isLoadingDataProvince = true;
        selectedProvince = null;
        arrProvinces.clear();
      });
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
//      arrFilterinput.add(FilteredInput("fullName", keySearch, ""));
//      arrSortedinput.add(SortedInput("createdTime", true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetProvinces(
          context, 0, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetProvinces: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetProvinces: $jsonData');
          setState(() {
            isLoadingDataProvince = false;
            arrProvinces = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true &&
              widget.userInfoData.province != null) {
            setState(() {
              for (final tmpItem in arrProvinces) {
                if (tmpItem.code == widget.userInfoData.province.code) {
                  AppUtil.showLog(
                      'From persion province: ${widget.userInfoData.province.toJson()}');
                  AppUtil.showLog('From   ward  province: ${tmpItem.toJson()}');
                  selectedProvince = tmpItem;
                }
              }
            });
          } else if (arrProvinces != null && arrProvinces.isNotEmpty) {
            for (final tmpItem in arrProvinces) {
              if (tmpItem != null &&
                  tmpItem.code != null &&
                  tmpItem.code == dotenv.env['CODE_DEFAULT_Province']) {
                setState(() {
                  selectedProvince = tmpItem;
                  isLoadingDataDistrict = true;
                  requestGetDistrict(tmpItem.code, false);
                });
              }
            }
          }
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
  }

  Future<void> requestGetDistrict(
      String provinceCode, bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedDistrict = null;
        arrDistricts.clear();
      });
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('provinceCode', provinceCode, '=='));
//      arrSortedinput.add(SortedInput("createdTime", true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetDistricts(
          context, 0, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDistrict: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetDistricts: $jsonData');
          setState(() {
            isLoadingDataDistrict = false;
            arrDistricts = List<AddressData>.from(
                responseData.data.map((it) => AddressData.fromJsonMap(it)));
//            if (arrDistricts != null && arrDistricts.length > 0) {
//              selectedDistrict = arrDistricts[0];
//            }
          });
          if (isBindDataForEdit == true &&
              widget.userInfoData.district != null) {
            setState(() {
              for (final tmpItem in arrDistricts) {
                if (tmpItem.code == widget.userInfoData.district.code) {
                  AppUtil.showLog(
                      'From persion district: ${widget.userInfoData.district.toJson()}');
                  AppUtil.showLog('From   Array district: ${tmpItem.toJson()}');
                  selectedDistrict = tmpItem;
                }
              }
            });
          }
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
  }

  Future<void> requestGetWards(
      String districtCode, bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedWard = null;
        arrWards.clear();
      });
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('districtCode', districtCode, '=='));
//      arrSortedinput.add(SortedInput("createdTime", true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetWards(
          context, 0, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetWards: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetWards: $jsonData');
          setState(() {
            isLoadingDataWard = false;
            arrWards = List<AddressData>.from(
                responseData.data.map((it) => AddressData.fromJsonMap(it)));
//            if (arrWards != null && arrWards.length > 0) {
//              selectedWard = arrWards[0];
//            }
          });
          if (isBindDataForEdit == true && widget.userInfoData.ward != null) {
            setState(() {
              for (final tmpItem in arrWards) {
                if (tmpItem.code == widget.userInfoData.ward.code) {
                  AppUtil.showLog(
                      'From persion district: ${widget.userInfoData.ward.toJson()}');
                  AppUtil.showLog('From   ward district: ${tmpItem.toJson()}');
                  selectedWard = tmpItem;
                }
              }
            });
          }
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
  }
}
