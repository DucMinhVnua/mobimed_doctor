import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/AddressData.dart';
import '../../model/AppointmentData.dart';
import '../../model/AppointmentInput.dart';
import '../../model/BaseTypeData.dart';
import '../../model/CommonTypeData.dart';
import '../../model/GraphQLModels.dart';
import '../../model/PatientData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
//import 'package:qrscan/qrscan.dart' as scanner;

//Giao diện này sinh ra để hoàn thiện thông tin các user chưa có patientCode, thêm patient và xác nhận đặt khám cho patient này luôn
// ignore: must_be_immutable
class ScreenConfirmPatient extends StatefulWidget {
  AppointmentData appoinmentData;

  ScreenConfirmPatient({Key key, this.appoinmentData}) : super(key: key);

  @override
  _ScreenConfirmPatientState createState() => _ScreenConfirmPatientState();
}

class _ScreenConfirmPatientState extends State<ScreenConfirmPatient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();
  Constants constants = Constants();
  String title = 'THÊM BỆNH NHÂN';

  PatientData selectedPatientData;

  List<PatientData> arrPatientData = [];

//  TextEditingController textControllerLastName = TextEditingController();
//  TextEditingController textControllerMiddleName = TextEditingController();
//  TextEditingController textControllerFirstName = TextEditingController();
  TextEditingController textControllerPatientCode = TextEditingController();
  TextEditingController textControllerFullName = TextEditingController();
  TextEditingController textControllerPhoneNumber = TextEditingController();
  TextEditingController textControllerStreet = TextEditingController();
  TextEditingController textControllerInsuranceCode = TextEditingController();

//  final FocusNode focusNodeLastName = FocusNode();
//  final FocusNode focusNodeMiddleName = FocusNode();
//  final FocusNode focusNodeFirstName = FocusNode();
  final FocusNode focusNodePatientCode = FocusNode();
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
  bool isSearchingPatient = false;

  @override
  void initState() {
    super.initState();

    if (widget.appoinmentData != null &&
        widget.appoinmentData.patient != null) {
      selectedPatientData = widget.appoinmentData.patient;
    } else if (widget.appoinmentData != null &&
        widget.appoinmentData.inputPatient != null) {
      selectedPatientData = widget.appoinmentData.inputPatient;
    }

    setState(() {
      arrGender.clear();
      // 1 là nam, 2 là nữ
      arrGender.add(GENDER_NU);
      arrGender.add(GENDER_NAM);
      arrGender.add(GENDER_KHAC);

      selectedGender = GENDER_NU;
    });

    bindDataIfEdit();

    searchHisPatientByInput();
  }

  bindDataIfEdit() {
    if (selectedPatientData != null) {
      setState(() {
        title = 'TẠO MÃ BỆNH NHÂN';
//        textControllerFirstName.text = widget.userInfoData.firstName;
//        textControllerMiddleName.text = widget.userInfoData.middleName;
//        textControllerLastName.text = widget.userInfoData.lastName;
        textControllerPatientCode.text = selectedPatientData.patientCode;
        textControllerFullName.text = selectedPatientData.fullName;
        textControllerPhoneNumber.text = selectedPatientData.phoneNumber;
//        textControllerCMND.text = widget.userInfoData.nationIdentification;
        textControllerStreet.text = selectedPatientData.street;

        if (selectedPatientData.gender != null &&
            selectedPatientData.gender == '1') {
          selectedGender = GENDER_NAM;
        } else {
          selectedGender = GENDER_NU;
        }

        if (selectedPatientData.birthDay != null) {
          selectedBirthDate = selectedPatientData.birthDay;
          _controllerTime.text = selectedPatientData.birthDay.toString();
        }
      });

//      AppUtil.showPrint("arrProvinces size: " + arrProvinces.length.toString());
//      AppUtil.showPrint("arrDistricts size: " + arrDistricts.length.toString());
//      AppUtil.showPrint("arrWards size: " + arrWards.length.toString());
      if (selectedPatientData.nationality != null) {
        requestGetNationalities(true);
      } else {
        //luôn phải load dữ liệu nationality
        requestGetNationalities(false);
      }
      if (selectedPatientData.nation != null) {
        requestGetNations(true);
      } else {
        requestGetNations(false);
      }
      if (selectedPatientData.work != null) {
        requestGetWorks(true);
      } else {
        requestGetWorks(false);
      }

      if (selectedPatientData.province != null) {
        requestGetProvinces(true);
      } else {
        //luôn phải load dữ liệu province
        requestGetProvinces(false);
      }
      if (selectedPatientData.district != null) {
        requestGetDistrict(selectedPatientData.province.code, true);
      }
      if (selectedPatientData.ward != null) {
        requestGetWards(selectedPatientData.district.code, true);
      }
    } else {
//      requestGetProvinces(false);
      requestGetNationalities(false);
      requestGetNations(false);
      requestGetProvinces(false);
      requestGetWorks(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputPatientCode = TextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        focusNode: focusNodePatientCode,
        style: Constants.styleTextNormalBlueColor,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, focusNodePatientCode, focusNodeFullName);
        },
        onChanged: _onChangeHandlerPatientCode,
        controller: textControllerPatientCode,
        decoration: InputDecoration(
//            errorText: _validatePatientCode ? 'Mã bệnh nhân không được để trống' : null,
          hintText: 'Gõ để tìm kiếm mã bệnh nhân',
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: HexColor.fromHex(Constants.Color_divider))),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(top: 15), // add padding to adjust icon
            child: Icon(Icons.search),
          ),
        ));
    final inputFullName = TextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        focusNode: focusNodeFullName,
        style: Constants.styleTextNormalBlueColor,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, focusNodeFullName, focusNodePhoneNumber);
        },
        onChanged: (value) {
          selectedPatientData.fullName = value;
          searchPatientByOtherField();
        },
        controller: textControllerFullName,
        decoration: InputDecoration(
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
        onChanged: (value) {
          selectedPatientData.phoneNumber = value;
          searchPatientByOtherField();
        },
        controller: textControllerPhoneNumber,
        style: Constants.styleTextNormalBlueColor,
        decoration: InputDecoration(
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
          appUtil.dismissKeyboard(context);
        },
        onChanged: (value) {
          selectedPatientData.insuranceCode = value;
          searchPatientByOtherField();
        },
        controller: textControllerInsuranceCode,
        decoration: InputDecoration(
            hintText: 'Nhập mã BHYT',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: HexColor.fromHex(Constants.Color_divider)))));

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
//            appBar: appUtil.getAppBar(new Text("THÊM BỆNH NHÂN")),
            appBar: AppUtil.customAppBar(context, title),
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Container(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: Colors.blue)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                              height: 33,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  color: HexColor.fromHex(
                                      Constants.Color_divider)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Bệnh nhân phù hợp: ',
                                      style: Constants.styleTextNormalSubColor,
                                    ),
                                    Text(
                                      (arrPatientData != null &&
                                              arrPatientData.isNotEmpty)
                                          ? arrPatientData.length.toString()
                                          : '0',
                                      style: Constants
                                          .styleTextNormalBlueColorBold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            arrPatientData != null && arrPatientData.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: arrPatientData.length,
                                    itemBuilder: (context, index) {
                                      PatientData patientData =
                                          arrPatientData[index];
                                      if (patientData != null) {
                                        return GestureDetector(
                                            onTap: () async {
                                              selectedPatientData = patientData;
                                              bindDataIfEdit();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: (patientData
                                                                    .fullName !=
                                                                null)
                                                            ? Text(
                                                                patientData
                                                                    .fullName,
                                                                style: Constants
                                                                    .styleTextNormalBlueColorBold)
                                                            : const SizedBox(
                                                                height: 1,
                                                              ),
                                                      ),
                                                      (patientData.patientCode !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/qrcode_16.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    patientData
                                                                        .patientCode,
                                                                    style: Constants
                                                                        .styleTextNormalBlueColor),
                                                              ],
                                                            )
                                                          : const SizedBox(
                                                              height: 0,
                                                            ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: (patientData
                                                                    .phoneNumber !=
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
                                                                        patientData
                                                                            .phoneNumber,
                                                                        style: Constants
                                                                            .styleTextNormalSubColor),
                                                                  ),
                                                                ],
                                                              )
                                                            : const SizedBox(
                                                                height: 0,
                                                              ),
                                                      ),
                                                      (patientData.birthDay !=
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
                                                                Text(
                                                                    DateFormat(Constants
                                                                            .FORMAT_DATEONLY)
                                                                        .format(patientData
                                                                            .birthDay),
                                                                    style: Constants
                                                                        .styleTextNormalSubColor),
                                                              ],
                                                            )
                                                          : const SizedBox(
                                                              height: 0,
                                                            ),
                                                    ],
                                                  ),
                                                  /*SizedBox(
                                                    height: 6,
                                                  ),
                                                  (patientData.address != null)
                                                      ? Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/location_16.png",
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(patientData.address, style: Constants.styleTextNormalSubColor),
                                                      ),
                                                    ],
                                                  )
                                                      : SizedBox(
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  (patientData.gender != null)
                                                      ? Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/gender_16.png",
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(patientData.gender != null && patientData.gender == "2" ? "Nữ" : "Nam", style: Constants.styleTextNormalSubColor),
                                                      ),
                                                    ],
                                                  )
                                                      : SizedBox(
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),*/
                                                  const Divider(
                                                    color: Colors.black26,
                                                  )
                                                ],
                                              ),
                                            ));
                                      } else {
                                        AppUtil.showPrint(
                                            '### appointmentData KHÔNG CÓ DỮ LIỆU ');
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                                        return const SizedBox(
                                          height: 0,
                                        );
                                      }
                                    },
//                                    controller: _scrollController,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            isSearchingPatient == true
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            'Đang tìm kiếm bệnh nhân',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.normal,
                                                fontSize:
                                                    Constants.Size_text_normal),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            inputPatientCode,
                            const SizedBox(
                              height: 4,
                            ),
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
                            viewSelectDay(),
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
//                                selectedPatientData.gender = selectedGender.name;
//                                searchPatientByOtherField();
                              },
                              items: arrGender
                                  .map((CommonTypeData user) =>
                                      DropdownMenuItem<CommonTypeData>(
                                        value: user,
                                        child: Text(
                                          user.name,
                                          style: Constants
                                              .styleTextNormalBlueColor,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownButton<BaseTypeData>(
                              isExpanded: true,
                              hint: const Text(
                                'Chọn quốc gia',
                                style: Constants.styleTextNormalHintColor,
                              ),
                              value: selectedNationality,
                              onChanged: (BaseTypeData value) {
                                setState(() {
                                  selectedNationality = value;
                                });
                                selectedPatientData.nationality = value;
                                searchPatientByOtherField();
                              },
                              items: arrNationalitys
                                  .map((BaseTypeData user) =>
                                      DropdownMenuItem<BaseTypeData>(
                                        value: user,
                                        child: Text(
                                          user.name,
                                          style: Constants
                                              .styleTextNormalBlueColor,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButton<BaseTypeData>(
                                    isExpanded: true,
                                    hint: const Text(
                                      'Chọn tỉnh/ thành phố',
                                      style: Constants.styleTextNormalHintColor,
                                    ),
                                    value: selectedProvince,
                                    onChanged: (BaseTypeData value) {
                                      setState(() {
                                        selectedProvince = value;
                                        isLoadingDataDistrict = true;
                                        requestGetDistrict(value.code, false);

                                        selectedPatientData.province = value;
                                        searchPatientByOtherField();
                                      });
                                    },
                                    items: arrProvinces
                                        .map((BaseTypeData user) =>
                                            DropdownMenuItem<BaseTypeData>(
                                              value: user,
                                              child: Text(
                                                user.name,
                                                style: Constants
                                                    .styleTextNormalBlueColor,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
//                              SizedBox(width: 5,),
                                isLoadingDataProvince
                                    ? const SizedBox(
                                        height: 18.0,
                                        width: 18.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.black26,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButton<AddressData>(
                                    isExpanded: true,
                                    hint: const Text(
                                      'Chọn quận/huyện',
                                      style: Constants.styleTextNormalHintColor,
                                    ),
                                    value: selectedDistrict,
                                    onChanged: (AddressData value) {
                                      setState(() {
                                        selectedDistrict = value;
                                        isLoadingDataWard = true;
                                        requestGetWards(value.code, false);
                                      });
                                    },
                                    items: arrDistricts
                                        .map((AddressData user) =>
                                            DropdownMenuItem<AddressData>(
                                              value: user,
                                              child: Text(
                                                user.name,
                                                style: Constants
                                                    .styleTextNormalBlueColor,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
//                              SizedBox(width: 5,),
                                isLoadingDataDistrict
                                    ? const SizedBox(
                                        height: 18.0,
                                        width: 18.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.black26,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButton<AddressData>(
                                    isExpanded: true,
                                    hint: const Text(
                                      'Chọn phường/xã',
                                      style: Constants.styleTextNormalHintColor,
                                    ),
                                    value: selectedWard,
                                    onChanged: (AddressData value) {
                                      setState(() {
                                        selectedWard = value;
                                      });
                                    },
                                    items: arrWards
                                        .map((AddressData user) =>
                                            DropdownMenuItem<AddressData>(
                                              value: user,
                                              child: Text(
                                                user.name,
                                                style: Constants
                                                    .styleTextNormalBlueColor,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
//                              SizedBox(width: 5,),
                                isLoadingDataWard
                                    ? const SizedBox(
                                        height: 18.0,
                                        width: 18.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.black26,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            inputAddress,
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownButton<BaseTypeData>(
                              isExpanded: true,
                              hint: const Text(
                                'Chọn dân tộc',
                                style: Constants.styleTextNormalHintColor,
                              ),
                              value: selectedNation,
                              onChanged: (BaseTypeData value) {
                                setState(() {
                                  selectedNation = value;
                                });
                                selectedPatientData.nation = value;
                                searchPatientByOtherField();
                              },
                              items: arrNations
                                  .map((BaseTypeData user) =>
                                      DropdownMenuItem<BaseTypeData>(
                                        value: user,
                                        child: Text(
                                          user.name,
                                          style: Constants
                                              .styleTextNormalBlueColor,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownButton<BaseTypeData>(
                              isExpanded: true,
                              hint: const Text(
                                'Chọn ngành nghề',
                                style: Constants.styleTextNormalHintColor,
                              ),
                              value: selectedWork,
                              onChanged: (BaseTypeData value) {
                                setState(() {
                                  selectedWork = value;
                                });
                                selectedPatientData.work = value;
                                searchPatientByOtherField();
                              },
                              items: arrWorks
                                  .map((BaseTypeData user) =>
                                      DropdownMenuItem<BaseTypeData>(
                                        value: user,
                                        child: Text(
                                          user.name,
                                          style: Constants
                                              .styleTextNormalBlueColor,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const SizedBox(
                              height: 90,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  color:
                                      HexColor.fromHex(Constants.Color_primary),
                                  child: Container(
                                      height: 45,
                                      child: Center(
                                        child: Text(
                                          selectedPatientData == null ||
                                                  selectedPatientData
                                                          .patientCode ==
                                                      null ||
                                                  selectedPatientData
                                                      .patientCode.isEmpty
                                              ? 'Tạo bệnh nhân'
                                              : 'Cập nhật BN',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))),
                              onTap: () {
                                onClickSavePatient();
                              },
                            )),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: GestureDetector(
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  color:
                                      HexColor.fromHex(Constants.Color_primary),
                                  child: Container(
                                      height: 45,
                                      child: const Center(
                                        child: Text(
                                          'Xác nhận đặt khám',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))),
                              onTap: () {
                                if (selectedPatientData != null &&
                                    selectedPatientData.patientCode != null) {
                                  onConfirmAppointment();
                                } else {
                                  appUtil.showToastWithScaffoldState(
                                      _scaffoldKey,
                                      'Bệnh nhân chưa có mã. Cập nhật thông tin bệnh nhân trước');
                                }
                              },
                            )),
                          ],
                        ),
                      ),
                      onTap: () async {
                        onClickSavePatient();
                      },
                    )),
              ],
            )));
  }

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

  onClickSavePatient() {
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

      PatientData patientInputData = PatientData();
      if (widget.appoinmentData != null) {
        //Trường hợp chỉ cập nhật thông tin người dùng
        patientInputData.id = selectedPatientData.id;
//        patientInputData.patientCode = selectedPatientData.patientCode;
      }
//      patientInputData.lastName = textControllerLastName.text;
//      patientInputData.middleName = textControllerMiddleName.text;
//      patientInputData.firstName = textControllerFirstName.text;
      patientInputData.patientCode = textControllerPatientCode.text;
      patientInputData.fullName = textControllerFullName.text;
      patientInputData.phoneNumber = textControllerPhoneNumber.text;
      patientInputData.birthDay = selectedBirthDate;
      patientInputData.gender = selectedGender.id;
      patientInputData.nationality = selectedNationality;
      patientInputData.province = selectedProvince;
      patientInputData.district =
          BaseTypeData(selectedDistrict.name, selectedDistrict.code);
      patientInputData.ward =
          BaseTypeData(selectedWard.name, selectedWard.code);
      patientInputData.street = textControllerStreet.text;
      patientInputData.nation = selectedNation;
      patientInputData.work = selectedWork;
      patientInputData.insuranceCode = textControllerInsuranceCode.text;

      requestSavePatient(context, patientInputData);
    } catch (e) {
      AppUtil.showPrint(e);
    }
  }

  requestSavePatient(BuildContext context, PatientData patientInputData) async {
    try {
      AppUtil.showLoadingDialog(context);
      ApiGraphQLControllerMutation apiController =
          ApiGraphQLControllerMutation();

      QueryResult result =
          await apiController.requestUpdatePatient(context, patientInputData);
      String response = result.data.toString();
      AppUtil.showLogFull('Response requestSavePatient: ' + response);
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        var responseData = appUtil.processResponse(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showPrint('### jsonData: ' + jsonData);
//          setState(() async {
          selectedPatientData = PatientData.fromJsonMap(jsonDecode(jsonData));
          AppUtil.showPrint(
              '### PatientData: ' + jsonEncode(selectedPatientData));

          if (widget.appoinmentData != null) {
            //Trường hợp chỉ cập nhật thông tin người dùng ==> back lại trang trước
            appUtil.showToastWithScaffoldState(_scaffoldKey,
                'Cập nhật thông tin thành công. Bạn có thể xác nhận đặt khám bây giờ');
          } else {
//            final ConfirmAction action = await appUtil.asyncConfirmDialog(context, "Thông báo", "Bạn có muốn đặt khám cho bệnh nhân này?");
//            if (action == ConfirmAction.ACCEPT) {
//              String result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
//                return ScreenDatKham(
//                  patientInput: itemData,
//                );
//              }));
//
//              AppUtil.showLog(result != null ? "Back from creean add => result: " + result : "Back from creean add => result: NULL");
//              if (result != null && result == Constants.SignalSuccess) {
//                Navigator.pop(context, Constants.SignalSuccess);
//              }
//            } else {
//              Navigator.pop(context, Constants.SignalSuccess);
//            }
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
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestSavePatient Error: ' + e.toString());
    }
  }

  onConfirmAppointment() async {
    try {
//      if (selectedDeparment == null) {
//        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn phòng khám");
//        return;
//      }
//      if (selectedAppointmentDate == null) {
//        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn ngày khám");
//        return;
//      }
//      if (selectedWorkTime == null) {
//        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn khung giờ khám");
//        return;
//      }
//
//      if (textControllerNote.text.trim().length == 0) {
//        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng nhập lý do khám");
//        return;
//      }

      AppointmentInput appointmentInput = AppointmentInput();
      appointmentInput.id = widget.appoinmentData.id;
      appointmentInput.inputPatient = widget.appoinmentData.inputPatient;
      appointmentInput.appointmentDate = widget.appoinmentData.appointmentDate;
      appointmentInput.appointmentTime = widget.appoinmentData.appointmentTime;
      appointmentInput.patientCode = selectedPatientData.patientCode;
      appointmentInput.departmentId = widget.appoinmentData.department.id;
      appointmentInput.channel = 'APP';
      appointmentInput.note = widget.appoinmentData.note;

      AppUtil.showLogFull(
          'userInputData: ' + appointmentInput.toJson().toString());
      try {
        AppUtil.showLoadingDialog(context);
        ApiGraphQLControllerMutation apiController =
            ApiGraphQLControllerMutation();

        QueryResult result = await apiController.requestCreateAppointment(
            context, appointmentInput);
        String response = result.data.toString();
        AppUtil.showPrint('Response requestCreateAppointment: ' + response);
        AppUtil.hideLoadingDialog(context);
        if (response != null) {
          var responseData = appUtil.processResponse(result);
          int code = responseData.code;
          String message = responseData.message;

          if (code == 0) {
            String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull(
                '### jsonData requestCreateAppointment: ' + jsonData);
            widget.appoinmentData =
                AppointmentData.fromJsonMap(jsonDecode(jsonData));

            String messageSuccess =
                'Xác nhận đặt khám thành công cho bệnh nhân này!';
            await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
                messageSuccess: messageSuccess, okBtnFunction: () {});

            Navigator.pop(context, widget.appoinmentData);
//          Navigator.push(context, MaterialPageRoute(builder: (_) {
//            return ScreenRegisterPassword(phoneNumber: widget.phoneNumber, regID: regID,);
//          }));
//          setState(() {
//            patientData = PatientData.fromJsonMap(jsonDecode(jsonData));
//            AppUtil.showPrint("### requestGetDetailPatient: " +
//                jsonEncode(patientData.toString()));
//          });
          } else {
            await AppUtil.showPopup(context, 'Thông báo', message);
            AppUtil.hideLoadingDialog(context);
          }
        } else {
          await AppUtil.showPopup(context, 'Thông báo',
              'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
          AppUtil.hideLoadingDialog(context);
        }
        AppUtil.hideLoadingDialog(context);
      } on Exception catch (e) {
        AppUtil.hideLoadingDialog(context);
        AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
      }
    } catch (e) {
      AppUtil.showPrint(e);
    }
  }
  /*//Tạo phiên khám
  requestCreateAppointmentOffline(BuildContext context, String patientCode, String reason, String patientID) async {
    try {
      AppUtil.showLoadingDialog(context);
      ApiGraphQLControllerMutation apiController = ApiGraphQLControllerMutation();

      QueryResult result = await apiController.requestCreateAppointmentOffline(context, patientCode, reason);
      String response = result.data.toString();
      AppUtil.showLogFull("Response requestCreateMedicalSession: " + response);
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        var responseData = appUtil.processResponse(result);
        int code = -1;
        String message = "";
        if (responseData != null) {
          code = responseData != null ? responseData.code : -1;
          message = responseData.message;
        } else {
          appUtil.showToastWithScaffoldState(_scaffoldKey, "Không thành công. Vui lòng thử lại sau");
          return;
        }

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showPrint("### jsonData: " + jsonData);
//          setState(() {
//            PatientData itemDate = PatientData.fromJsonMap(jsonDecode(jsonData));
//            AppUtil.showPrint("### PatientData: " + jsonEncode(itemDate.toString()));
//          });
          await AppUtil.showPopup(context, "Thông báo", message);

          bool dialogResult = await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context, messageSuccess: "Đăng ký khám thành công", okBtnFunction: () {});
          if (dialogResult != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) {
                return ScreenPatientDetail(
                  patientCode: patientCode,
                );
              }),
            );
          } else {
            Navigator.pop(context);
          }

          */ /*  Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ScreenPatientDetail(itemID: patientID,);
          }));*/ /*
        } else {
          AppUtil.showPopup(context, "Thông báo", message);
        }
      } else {
        AppUtil.showPopup(context, "Thông báo", "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestSavePatient Error: ' + e.toString());
    }
  }*/

  Timer searchOnStoppedTyping;
  _onChangeHandlerPatientCode(value) {
    const duration = Duration(
        milliseconds:
            2000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  searchPatientByOtherField() {
    const duration = Duration(
        milliseconds:
            2000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping =
        Timer(duration, () => searchHisPatientByInput()));
  }

  search(value) async {
    AppUtil.showPrint('Search key: $value');

    loadPatientDetail(context, value);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  searchHisPatientByInput() async {
    try {
      setState(() {
        arrPatientData.clear();
        isSearchingPatient = true;
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestSearchHisPatients(
          context, selectedPatientData);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestSearchHisPatients: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          log('### jsonData requestGetPatients: ' + jsonData);
          if (jsonData == null || jsonData.isEmpty) {
          } else {
            AppUtil.showPrint('### pages: ' + responseData.pages.toString());
          }
          var tmpItems = List<PatientData>.from(
              responseData.data.map((item) => PatientData.fromJsonMap(item)));
          setState(() {
            arrPatientData.addAll(tmpItems);
          });
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
    setState(() {
      isSearchingPatient = false;
    });
  }

  loadPatientDetail(BuildContext context, String patientCode) async {
    try {
      setState(() {
        isSearchingPatient = true;
      });
//      AppUtil.showLoadingDialog(context);
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result =
          await apiController.requestGetDetailPatient(context, patientCode);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDetailPatient: ' + response);
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        var responseData = appUtil.processResponse(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0 && responseData.data != null) {
          String jsonData = json.encode(responseData.data);
          log('### jsonData: ' + jsonData);
          setState(() {
            arrPatientData.clear();
            selectedPatientData = PatientData.fromJsonMap(jsonDecode(jsonData));
            arrPatientData.add(selectedPatientData);
          });
          AppUtil.showPrint('### requestGetDetailPatient data: ' +
              jsonEncode(selectedPatientData));
          bindDataIfEdit();
        } else {
          appUtil.showToastWithScaffoldState(_scaffoldKey, message);
        }
      } else {
//        appUtil.showToast(context, "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
    setState(() {
      isSearchingPatient = false;
    });
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
  requestGetNations(bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedNation = null;
        arrNations.clear();
      });
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
//      arrFilterinput.add(FilteredInput("fullName", keySearch, ""));
//      arrSortedinput.add(SortedInput("createdTime", true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetNations(
          context, 0, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNations: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetNations: ' + jsonData);
          setState(() {
            arrNations = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
          });
          if (isBindDataForEdit == true && selectedPatientData.nation != null) {
            setState(() {
              for (var tmpItem in arrNations) {
                if (tmpItem.code == selectedPatientData.nation.code) {
                  AppUtil.showLog('From persion nation: ' +
                      selectedPatientData.nation.toJson().toString());
                  AppUtil.showLog(
                      'From   ward  nation: ' + tmpItem.toJson().toString());
                  selectedNation = tmpItem;
                }
              }
            });
          } else if (arrNations != null && arrNations.isNotEmpty) {
            for (var tmpItem in arrNations) {
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
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  requestGetNationalities(bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedNationality = null;
        arrNationalitys.clear();
      });
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetNationalities(
          context, 0, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNationalitys: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull(
              '### jsonData requestGetNationalitys: ' + jsonData);
          setState(() {
            arrNationalitys = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if (arrNationalitys != null && arrNationalitys.length > 0) {
//              selectedNationality = arrNationalitys[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedPatientData.nationality != null) {
            setState(() {
              for (var tmpItem in arrNationalitys) {
                if (tmpItem.code == selectedPatientData.nationality.code) {
                  AppUtil.showLog('From persion nationality: ' +
                      selectedPatientData.nationality.toJson().toString());
                  AppUtil.showLog('From   ward  nationality: ' +
                      tmpItem.toJson().toString());
                  selectedNationality = tmpItem;
                }
              }
            });
          } else if (arrNationalitys != null && arrNationalitys.isNotEmpty) {
            for (var tmpItem in arrNationalitys) {
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
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  requestGetWorks(bool isBindDataForEdit) async {
    try {
      setState(() {
//        isLoadingDataWorks = true;
        selectedWork = null;
        arrWorks.clear();
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetWorks(context);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetWorks: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetWorks: ' + jsonData);
          setState(() {
//            isLoadingDataWorks = false;
            arrWorks = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true && selectedPatientData.work != null) {
            setState(() {
              for (var tmpItem in arrWorks) {
                if (tmpItem.code == selectedPatientData.work.code) {
                  AppUtil.showLog('From persion work: ' +
                      selectedPatientData.work.toJson().toString());
                  AppUtil.showLog(
                      'From   ward  work: ' + tmpItem.toJson().toString());
                  selectedWork = tmpItem;
                }
              }
            });
          }
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetWorks Error: ' + e.toString());
    }
  }

  requestGetProvinces(bool isBindDataForEdit) async {
    try {
      setState(() {
        isLoadingDataProvince = true;
        selectedProvince = null;
        arrProvinces.clear();
      });
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
//      arrFilterinput.add(FilteredInput("fullName", keySearch, ""));
//      arrSortedinput.add(SortedInput("createdTime", true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetProvinces(
          context, 0, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetProvinces: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetProvinces: ' + jsonData);
          setState(() {
            isLoadingDataProvince = false;
            arrProvinces = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedPatientData.province != null) {
            setState(() {
              for (var tmpItem in arrProvinces) {
                if (tmpItem.code == selectedPatientData.province.code) {
                  AppUtil.showLog('From persion province: ' +
                      selectedPatientData.province.toJson().toString());
                  AppUtil.showLog(
                      'From   ward  province: ' + tmpItem.toJson().toString());
                  selectedProvince = tmpItem;
                }
              }
            });
          } else if (arrProvinces != null && arrProvinces.isNotEmpty) {
            for (var tmpItem in arrProvinces) {
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
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  requestGetDistrict(String provinceCode, bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedDistrict = null;
        arrDistricts.clear();
      });
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('provinceCode', provinceCode, '=='));
//      arrSortedinput.add(SortedInput("createdTime", true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetDistricts(
          context, 0, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDistrict: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetDistricts: ' + jsonData);
          setState(() {
            isLoadingDataDistrict = false;
            arrDistricts = List<AddressData>.from(
                responseData.data.map((it) => AddressData.fromJsonMap(it)));
//            if (arrDistricts != null && arrDistricts.length > 0) {
//              selectedDistrict = arrDistricts[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedPatientData.district != null) {
            setState(() {
              for (var tmpItem in arrDistricts) {
                if (tmpItem.code == selectedPatientData.district.code) {
                  AppUtil.showLog('From persion district: ' +
                      selectedPatientData.district.toJson().toString());
                  AppUtil.showLog(
                      'From   Array district: ' + tmpItem.toJson().toString());
                  selectedDistrict = tmpItem;
                }
              }
            });
          }
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  requestGetWards(String districtCode, bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedWard = null;
        arrWards.clear();
      });
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('districtCode', districtCode, '=='));
//      arrSortedinput.add(SortedInput("createdTime", true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetWards(
          context, 0, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetWards: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData requestGetWards: ' + jsonData);
          setState(() {
            isLoadingDataWard = false;
            arrWards = List<AddressData>.from(
                responseData.data.map((it) => AddressData.fromJsonMap(it)));
//            if (arrWards != null && arrWards.length > 0) {
//              selectedWard = arrWards[0];
//            }
          });
          if (isBindDataForEdit == true && selectedPatientData.ward != null) {
            setState(() {
              for (var tmpItem in arrWards) {
                if (tmpItem.code == selectedPatientData.ward.code) {
                  AppUtil.showLog('From persion district: ' +
                      selectedPatientData.ward.toJson().toString());
                  AppUtil.showLog(
                      'From   ward district: ' + tmpItem.toJson().toString());
                  selectedWard = tmpItem;
                }
              }
            });
          }
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }
}
