import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/BaseTypeData.dart';
import '../../model/CommonTypeData.dart';
import '../../model/GraphQLModels.dart';
import '../../model/PatientData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'ScreenDatKhamHoanThanh.dart';

// ignore: must_be_immutable
class ScreenDatKham extends StatefulWidget {
  PatientData patientInput;

  ScreenDatKham({Key key, this.patientInput}) : super(key: key);

  @override
  _ScreenDatKhamState createState() => _ScreenDatKhamState();
}

class _ScreenDatKhamState extends State<ScreenDatKham> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();
  Constants constants = Constants();

  ScrollController scrollController = ScrollController();

  // ignore: avoid_init_to_null
  DateTime selectedBirthDate = null;
  // ignore: avoid_init_to_null
  CommonTypeData selectedGender = null;
  List<CommonTypeData> arrGender = [];
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_NAM = CommonTypeData('1', '1', 'Nam');
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_NU = CommonTypeData('2', '2', 'Nữ');
  // ignore: non_constant_identifier_names
  CommonTypeData GENDER_KHAC = CommonTypeData('3', '3', 'Khác');
//  List<CommonTypeData> arrRelationship = [];

//  TextEditingController textControllerLastName = TextEditingController();
//  TextEditingController textControllerMiddleName = TextEditingController();
//  TextEditingController textControllerFirstName = TextEditingController();
  TextEditingController textControllerFullName = TextEditingController();
  TextEditingController textControllerPhoneNumber = TextEditingController();
  TextEditingController textControllerStreet = TextEditingController();
  TextEditingController textControllerInsuranceCode = TextEditingController();
  TextEditingController textControllerPatientCode = TextEditingController();

//  final FocusNode focusNodeLastName = FocusNode();
//  final FocusNode focusNodeMiddleName = FocusNode();
//  final FocusNode focusNodeFirstName = FocusNode();
  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodePhoneNumber = FocusNode();
  final FocusNode focusNodeStreet = FocusNode();
  final FocusNode focusNodeInsuranceCode = FocusNode();
  final FocusNode focusNodePatientCode = FocusNode();

  bool _validateFullName = false, _validatePhoneNumber = false;
//  bool _validateLastName = false, _validateFirstName = false, _validatePhoneNumber = false;
//  List<PatientInput> arrRelationShips = [];
  // ignore: avoid_init_to_null
  PatientData selectedRelationship = null;

  @override
  void initState() {
    super.initState();
    selectedRelationship = widget.patientInput;
    setState(() {
      arrGender.clear();
      // 1 là nam, 2 là nữ
      arrGender.add(GENDER_NU);
      arrGender.add(GENDER_NAM);
      arrGender.add(GENDER_KHAC);

//      arrRelationship.clear();
//      arrRelationship.add(CommonTypeData("me","", "Tôi"));
//      arrRelationship.add(CommonTypeData("wife","", "Vợ"));
    });

    bindSelectedPatientData(selectedRelationship);
  }

  Widget inputWidget(
          String title,
          String hintText,
          bool validateField,
          String errorText,
          TextEditingController textEditingController,
          TextInputAction textInputAction,
          FocusNode currentNode,
          FocusNode nextNode,
          TextCapitalization textCapitalization,
          TextInputType textInputType) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(
                width: 13,
              ),
              Text(
                title,
                style: Constants.styleTextSuperSmallSubColor,
              ),
            ],
          ),
          TextFormField(
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              keyboardType: textInputType,
              focusNode: currentNode,
              style: Constants.styleTextNormalBlueColor,
              onFieldSubmitted: (value) {
                appUtil.textFieldFocusChange(context, currentNode, nextNode);
              },
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(13),
//                errorText:
//                validateField != null ?? validateField ? errorText : null,
                hintText: hintText,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                      color: HexColor.fromHex(Constants.Color_divider)),
                ),
              ))
        ],
      );

  Widget inputWidgetWithoutEdit(
          String title,
          String hintText,
          bool validateField,
          String errorText,
          TextEditingController textEditingController,
          TextInputAction textInputAction,
          FocusNode currentNode,
          FocusNode nextNode,
          TextCapitalization textCapitalization,
          TextInputType textInputType) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(
                width: 13,
              ),
              Text(
                title,
                style: Constants.styleTextSuperSmallSubColor,
              ),
            ],
          ),
          TextFormField(
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              keyboardType: textInputType,
              focusNode: currentNode,
              enabled: false,
              style: Constants.styleTextNormalBlueColor,
              onFieldSubmitted: (value) {
                appUtil.textFieldFocusChange(context, currentNode, nextNode);
              },
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(13),
//                errorText:
//                validateField != null ?? validateField ? errorText : null,
                hintText: hintText,
                enabledBorder: UnderlineInputBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(5)),
                  borderSide: BorderSide(
                      color: HexColor.fromHex(Constants.Color_divider)),
                ),
              ))
        ],
      );

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppUtil.customAppBar(context, 'ĐẶT LỊCH KHÁM'),
            body: Stack(
              children: <Widget>[
                Container(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
//                      child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(
                                  height: 14,
                                ),
                                /*      inputWidget("Họ tên", "Nhập họ", _validateLastName, "Vui lòng nhập họ", textControllerLastName, TextInputAction.next, focusNodeLastName, focusNodeMiddleName,
                                  TextCapitalization.words, TextInputType.text),
//                    inputFullname,
                              SizedBox(
                                height: 12,
                              ),
                              inputWidget("Họ tên", "Nhập tên đệm", null, "Vui lòng nhập tên đệm", textControllerMiddleName, TextInputAction.next, focusNodeMiddleName, focusNodeFirstName,
                                  TextCapitalization.words, TextInputType.text),
//                    inputFullname,
                              SizedBox(
                                height: 12,
                              ),
                              inputWidget("Họ tên", "Nhập tên", _validateFirstName, "Vui lòng tên", textControllerFirstName, TextInputAction.next, focusNodeFirstName, focusNodePhoneNumber,
                                  TextCapitalization.words, TextInputType.text),
//                    inputFullname,*/
                                inputWidget(
                                    'Họ họ tên',
                                    'Nhập họ tên',
                                    _validateFullName,
                                    'Vui lòng họ tên',
                                    textControllerFullName,
                                    TextInputAction.next,
                                    focusNodeFullName,
                                    focusNodePhoneNumber,
                                    TextCapitalization.words,
                                    TextInputType.text),
//                    inputFullname,
                                const SizedBox(
                                  height: 12,
                                ),
                                inputWidget(
                                    'Số điện thoại',
                                    'Nhập số điện thoại',
                                    _validatePhoneNumber,
                                    'Vui lòng nhập số điện thoại',
                                    textControllerPhoneNumber,
                                    TextInputAction.next,
                                    focusNodePhoneNumber,
                                    focusNodeInsuranceCode,
                                    TextCapitalization.words,
                                    TextInputType.phone),
//                    inputPhoneNumber,
//                    inputPhoneNumber,
                                const SizedBox(
                                  height: 12,
                                ),
                                inputWidget(
                                    'BHYT',
                                    'Nhập mã BHYT',
                                    null,
                                    'Vui lòng nhập mã BHYT',
                                    textControllerInsuranceCode,
                                    TextInputAction.next,
                                    focusNodeInsuranceCode,
                                    focusNodePatientCode,
                                    TextCapitalization.words,
                                    TextInputType.text),
//                    inputInsuranceCode,
                                const SizedBox(
                                  height: 12,
                                ),
                                inputWidgetWithoutEdit(
                                    'Mã bệnh nhân (nếu có)',
                                    'Nhập mã bệnh nhân',
                                    null,
                                    'Vui lòng nhập mã bệnh nhân',
                                    textControllerPatientCode,
                                    TextInputAction.next,
                                    focusNodePatientCode,
                                    focusNodeStreet,
                                    TextCapitalization.words,
                                    TextInputType.text),
                                const SizedBox(
                                  height: 12,
                                ),
                                viewSelectDay(),
                                const SizedBox(
                                  height: 12,
                                ),
                                DropdownButton<CommonTypeData>(
                                  isExpanded: true,
                                  hint: Row(
                                    children: const <Widget>[
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                        'Giới tính',
                                        style:
                                            Constants.styleTextNormalHintColor,
                                      ),
                                    ],
                                  ),
                                  value: selectedGender != null
                                      ? selectedGender
                                      : null,
                                  onChanged: (CommonTypeData value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedGender = value;
                                        selectedRelationship.gender = value.id;
                                      });
                                    }
                                  },
                                  items: arrGender
                                      .map((CommonTypeData user) =>
                                          DropdownMenuItem<CommonTypeData>(
                                            value: user,
                                            child: Row(
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 13,
                                                ),
                                                Text(
                                                  user.name,
                                                  style: Constants
                                                      .styleTextNormalBlueColor,
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),

                                //Công việc
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: DropdownButton<BaseTypeData>(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const <Widget>[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Chọn công việc hiện tại',
                                              style: Constants
                                                  .styleTextNormalHintColor,
                                            ),
                                          ],
                                        ),
                                        value: selectedWork != null
                                            ? selectedWork
                                            : null,
                                        onChanged: (BaseTypeData value) {
                                          setState(() {
                                            selectedWork = value;
                                            selectedRelationship.work = value;
                                          });
                                        },
                                        items: arrWorks
                                            .map((BaseTypeData user) =>
                                                DropdownMenuItem<BaseTypeData>(
                                                  value: user,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        user.name,
                                                        style: Constants
                                                            .styleTextNormalBlueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
//                              SizedBox(width: 5,),
                                    isLoadingDataWorks
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child:
                                                const CircularProgressIndicator(
                                              backgroundColor: Colors.black26,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                //Dân tộc
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: DropdownButton<BaseTypeData>(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const <Widget>[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Chọn dân tộc',
                                              style: Constants
                                                  .styleTextNormalHintColor,
                                            ),
                                          ],
                                        ),
                                        value: selectedNation != null
                                            ? selectedNation
                                            : null,
                                        onChanged: (BaseTypeData value) {
                                          setState(() {
                                            selectedNation = value;
                                            selectedRelationship.nation = value;
                                          });
                                        },
                                        items: arrNations
                                            .map((BaseTypeData user) =>
                                                DropdownMenuItem<BaseTypeData>(
                                                  value: user,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        user.name,
                                                        style: Constants
                                                            .styleTextNormalBlueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
//                              SizedBox(width: 5,),
                                    isLoadingDataNations
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child:
                                                const CircularProgressIndicator(
                                              backgroundColor: Colors.black26,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                //Quốc gia
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: DropdownButton<BaseTypeData>(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const <Widget>[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Chọn quốc gia',
                                              style: Constants
                                                  .styleTextNormalHintColor,
                                            ),
                                          ],
                                        ),
                                        value: selectedNationality != null
                                            ? selectedNationality
                                            : null,
                                        onChanged: (BaseTypeData value) {
                                          setState(() {
                                            selectedNationality = value;
                                            selectedRelationship.nationality =
                                                value;
                                          });
                                        },
                                        items: arrNationalities
                                            .map((BaseTypeData user) =>
                                                DropdownMenuItem<BaseTypeData>(
                                                  value: user,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        user.name,
                                                        style: Constants
                                                            .styleTextNormalBlueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
//                              SizedBox(width: 5,),
                                    isLoadingDataNationalities
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
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

                                arrProvinces != null && arrProvinces.length > 0
                                    ? Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: DropdownButton<BaseTypeData>(
                                              isExpanded: true,
                                              hint: Row(
                                                children: const <Widget>[
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    'Chọn tỉnh/ thành phố',
                                                    style: Constants
                                                        .styleTextNormalHintColor,
                                                  ),
                                                ],
                                              ),
//                              value: selectedProvince,
                                              value: selectedProvince != null
                                                  ? selectedProvince
                                                  : null,
                                              onChanged: (BaseTypeData value) {
                                                if (value != null) {
                                                  setState(() {
                                                    selectedRelationship
                                                        .province = value;
                                                    selectedProvince = value;
                                                    isLoadingDataDistrict =
                                                        true;
                                                    requestGetDistrict(
                                                        value.code, false);
                                                  });
                                                }
                                              },
                                              items: arrProvinces
                                                  .map((BaseTypeData user) =>
                                                      DropdownMenuItem<
                                                              BaseTypeData>(
                                                          value: user,
                                                          child: Row(
                                                            children: <Widget>[
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Text(
                                                                user.name,
                                                                style: Constants
                                                                    .styleTextNormalBlueColor,
                                                              ),
                                                            ],
                                                          )))
                                                  .toList(),
                                            ),
                                          ),
//                              SizedBox(width: 5,),
                                          isLoadingDataProvince
                                              ? const SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.black26,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: DropdownButton<BaseTypeData>(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const <Widget>[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Chọn quận/huyện',
                                              style: Constants
                                                  .styleTextNormalHintColor,
                                            ),
                                          ],
                                        ),
                                        value: selectedDistrict != null
                                            ? selectedDistrict
                                            : null,
                                        onChanged: (BaseTypeData value) {
                                          setState(() {
                                            selectedRelationship.district =
                                                value;
                                            selectedDistrict = value;
                                            isLoadingDataWard = true;
                                            requestGetWards(
                                                selectedProvince.code,
                                                value.code,
                                                false);
                                          });
                                        },
                                        items: arrDistricts
                                            .map((BaseTypeData user) =>
                                                DropdownMenuItem<BaseTypeData>(
                                                  value: user,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        user.name,
                                                        style: Constants
                                                            .styleTextNormalBlueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
//                              SizedBox(width: 5,),
                                    isLoadingDataDistrict
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child:
                                                const CircularProgressIndicator(
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
                                      child: DropdownButton<BaseTypeData>(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const <Widget>[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Chọn phường/xã',
                                              style: Constants
                                                  .styleTextNormalHintColor,
                                            ),
                                          ],
                                        ),
                                        value: selectedWard != null
                                            ? selectedWard
                                            : null,
                                        onChanged: (BaseTypeData value) {
                                          setState(() {
                                            selectedRelationship.ward = value;
                                            selectedWard = value;
                                          });
                                        },
                                        items: arrWards
                                            .map((BaseTypeData user) =>
                                                DropdownMenuItem<BaseTypeData>(
                                                  value: user,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        user.name,
                                                        style: Constants
                                                            .styleTextNormalBlueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
//                              SizedBox(width: 5,),
                                    isLoadingDataWard
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child:
                                                const CircularProgressIndicator(
                                              backgroundColor: Colors.black26,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                inputWidget(
                                    'Địa chỉ',
                                    'Nhập số nhà/tên đường/khu',
                                    null,
                                    'Vui lòng nhập số nhà/tên đường/khu',
                                    textControllerStreet,
                                    TextInputAction.done,
                                    focusNodeStreet,
                                    focusNodeStreet,
                                    TextCapitalization.sentences,
                                    TextInputType.text),
                                const SizedBox(
                                  height: 75,
                                ),
                              ],
                            )
//                      ),
                            )
                      ],
                    ),
                  ),
                ),
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
                                  const BorderRadius.all(Radius.circular(25))),
                          color: HexColor.fromHex(Constants.Color_primary),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'TIẾP TỤC',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
            )),
      );

  TextEditingController _controllerTime =
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
                        width: 1.0),
                  ),
                ),
              ),
            )
          ],
        ),
      );

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

  bindSelectedPatientData(PatientData patientInput) async {
    //Reset data trước
    setState(() {
//      textControllerLastName.text = "";
//      textControllerMiddleName.text = "";
//      textControllerFirstName.text = "";
      textControllerFullName.text = '';
      textControllerPhoneNumber.text = '';
      textControllerPatientCode.text = '';
      textControllerInsuranceCode.text = '';
      textControllerStreet.text = '';
      selectedBirthDate = null;
      selectedGender = GENDER_NU;
      selectedProvince = null;
      selectedDistrict = null;
      selectedWard = null;
    });
    if (patientInput != null) {
      setState(() {
//        textControllerLastName.text = patientInput.lastName;
//        textControllerMiddleName.text = patientInput.middleName;
//        textControllerFirstName.text = patientInput.firstName;
        textControllerFullName.text = patientInput.fullName;
        textControllerPhoneNumber.text = patientInput.phoneNumber;
        textControllerPatientCode.text = patientInput.patientCode;
        textControllerInsuranceCode.text = patientInput.insuranceCode;
        textControllerStreet.text = patientInput.street;
        if (patientInput.birthDay != null) {
          selectedBirthDate = patientInput.birthDay;
          _controllerTime.text = patientInput.birthDay.toString();
        }
        if (patientInput.gender == 'female' || patientInput.gender == '2') {
          selectedGender = GENDER_NU;
        } else if (patientInput.gender == 'male' ||
            patientInput.gender == '1') {
          selectedGender = GENDER_NAM;
        } else {
          selectedGender = GENDER_KHAC;
        }
      });

      if (patientInput.province != null) {
        await requestGetProvinces(true);
      } else {
        setState(() {
          selectedProvince = null;
        });
        //luôn phải load dữ liệu province
        await requestGetProvinces(false);
      }
      if (patientInput.district != null) {
        await requestGetDistrict(patientInput.province.code, true);
      } else {
        selectedDistrict = null;
      }
      if (patientInput.ward != null) {
        await requestGetWards(
            patientInput.province.code, patientInput.district.code, true);
      } else {
        selectedWard = null;
      }

      if (selectedRelationship.nationality != null) {
        requestGetNationalities(true);
      } else {
        //luôn phải load dữ liệu nationality
        requestGetNationalities(false);
      }
      if (selectedRelationship.nation != null) {
        requestGetNations(true);
      } else {
        requestGetNations(false);
      }
      if (selectedRelationship.work != null) {
        requestGetWorks(true);
      } else {
        requestGetWorks(false);
      }

//      AppUtil.showLog("Scroll to top NOW");
//      setState(() {
//        scrollController.animateTo(0.0,
//            duration: Duration(milliseconds: 500), curve: Curves.ease);
//      });
    } else {
      requestGetNationalities(false);
      requestGetNations(false);
      requestGetProvinces(false);
      requestGetWorks(false);
    }
  }

  onClickSavePatient() async {
    try {
      String result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScreenDatKhamHoanThanh(
                    patientInput: selectedRelationship,
                  )));

      AppUtil.showLog(result != null
          ? 'Back from creean add => result: ' + result
          : 'Back from creean add => result: NULL');
      if (result != null && result == Constants.SignalSuccess) {
        Navigator.pop(context, Constants.SignalSuccess);
      }
      /* if(textControllerFullName.text.trim().length == 0){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng nhập họ tên bệnh nhân");
        return;
      }
      if(textControllerPhoneNumber.text.trim().length == 0){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng nhập số điện thoại bệnh nhân");
        return;
      }
      if(selectedBirthDate == null){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn ngày sinh");
        return;
      }
      if(selectedGender == null){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn giới tính");
        return;
      }
      if(selectedNationality == null){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn quốc gia");
        return;
      }
      if(selectedProvince == null || selectedDistrict == null || selectedWard == null || textControllerStreet.text.trim().length == 0){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng nhập địa chỉ");
        return;
      }
      if(selectedNation == null){
        appUtil.showToastWithScaffoldState(_scaffoldKey, "Vui lòng chọn dân tộc");
        return;
      }

      PatientInputData patientInputData = PatientInputData();
      patientInputData.fullName = textControllerFullName.text;
      patientInputData.phoneNumber = textControllerPhoneNumber.text;
      patientInputData.birthDay = selectedBirthDate;
      patientInputData.gender = selectedGender.id;
      patientInputData.nationality = selectedNationality;
      patientInputData.province = selectedProvince;
      patientInputData.district = BaseTypeData(selectedDistrict.name, selectedDistrict.code);
      patientInputData.ward = BaseTypeData(selectedWard.name, selectedWard.code);
      patientInputData.street = textControllerStreet.text;
      patientInputData.nation = selectedNation;
      patientInputData.insuranceCode = textControllerInsuranceCode.text;

      requestSavePatient(context, patientInputData);*/
    } catch (e) {
      AppUtil.showPrint(e);
    }
  }

  bool isLoadingDataProvince = false,
      isLoadingDataDistrict = false,
      isLoadingDataWard = false,
      isLoadingDataNationalities = false,
      isLoadingDataNations = false,
      isLoadingDataWorks = false;
  List<BaseTypeData> arrProvinces = [];
  List<BaseTypeData> arrDistricts = [];
  List<BaseTypeData> arrWards = [];
  List<BaseTypeData> arrNationalities = [];
  List<BaseTypeData> arrNations = [];
  List<BaseTypeData> arrWorks = [];

  // ignore: avoid_init_to_null
  BaseTypeData selectedProvince = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedDistrict = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedWard = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedNationality = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedNation = null;
  // ignore: avoid_init_to_null
  BaseTypeData selectedWork = null;

  requestGetProvinces(bool isBindDataForEdit) async {
    try {
      setState(() {
        isLoadingDataProvince = true;
        selectedProvince = null;
        arrProvinces.clear();
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
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
              selectedRelationship != null &&
              selectedRelationship.province != null) {
            setState(() {
              for (var tmpItem in arrProvinces) {
                if (tmpItem.code == selectedRelationship.province.code) {
                  AppUtil.showLog('From persion province: ' +
                      selectedRelationship.province.toJson().toString());
                  AppUtil.showLog(
                      'From   ward  province: ' + tmpItem.toJson().toString());
                  selectedProvince = tmpItem;
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

  requestGetDistrict(String provinceCode, bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedDistrict = null;
        arrDistricts.clear();
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('provinceCode', provinceCode, '=='));
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
            arrDistricts = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if (arrDistricts != null && arrDistricts.length > 0) {
//              selectedDistrict = arrDistricts[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedRelationship != null &&
              selectedRelationship.district != null) {
            setState(() {
              for (var tmpItem in arrDistricts) {
                if (tmpItem.code == selectedRelationship.district.code) {
                  AppUtil.showLog('From persion district: ' +
                      selectedRelationship.district.toJson().toString());
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

  requestGetWards(
      String provinceCode, String districtCode, bool isBindDataForEdit) async {
    try {
      setState(() {
        selectedWard = null;
        arrWards.clear();
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('districtCode', districtCode, '=='));
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
            arrWards = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if (arrWards != null && arrWards.length > 0) {
//              selectedWard = arrWards[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedRelationship != null &&
              selectedRelationship.ward != null) {
            setState(() {
              for (var tmpItem in arrWards) {
                if (tmpItem.code == selectedRelationship.ward.code) {
                  AppUtil.showLog('From persion district: ' +
                      selectedRelationship.ward.toJson().toString());
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

  requestGetNationalities(bool isBindDataForEdit) async {
    try {
      setState(() {
        isLoadingDataNationalities = true;
        selectedNationality = null;
        arrNationalities.clear();
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      QueryResult result = await apiController.requestGetNationalities(
          context, 0, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNationalities: ' + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull(
              '### jsonData requestGetNationalities: ' + jsonData);
          setState(() {
            isLoadingDataNationalities = false;
            arrNationalities = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedRelationship.nationality != null) {
            setState(() {
              for (var tmpItem in arrNationalities) {
                if (tmpItem.code == selectedRelationship.nationality.code) {
                  AppUtil.showLog('From persion nationality: ' +
                      selectedRelationship.nationality.toJson().toString());
                  AppUtil.showLog('From   ward  nationality: ' +
                      tmpItem.toJson().toString());
                  selectedNationality = tmpItem;
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

  requestGetNations(bool isBindDataForEdit) async {
    try {
      setState(() {
        isLoadingDataNations = true;
        selectedNation = null;
        arrNations.clear();
      });
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
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
            isLoadingDataNations = false;
            arrNations = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true &&
              selectedRelationship.nation != null) {
            setState(() {
              for (var tmpItem in arrNations) {
                if (tmpItem.code == selectedRelationship.nation.code) {
                  AppUtil.showLog('From persion nation: ' +
                      selectedRelationship.nation.toJson().toString());
                  AppUtil.showLog(
                      'From   ward  nation: ' + tmpItem.toJson().toString());
                  selectedNation = tmpItem;
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
      AppUtil.showPrint('requestGetNations Error: ' + e.toString());
    }
  }

  requestGetWorks(bool isBindDataForEdit) async {
    try {
      setState(() {
        isLoadingDataWorks = true;
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
            isLoadingDataWorks = false;
            arrWorks = List<BaseTypeData>.from(
                responseData.data.map((it) => BaseTypeData.fromJsonMap(it)));
//            if(arrProvinces != null  && arrProvinces.length > 0){
//              selectedProvince = arrProvinces[0];
//            }
          });
          if (isBindDataForEdit == true && selectedRelationship.work != null) {
            setState(() {
              for (var tmpItem in arrWorks) {
                if (tmpItem.code == selectedRelationship.work.code) {
                  AppUtil.showLog('From persion work: ' +
                      selectedRelationship.work.toJson().toString());
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
}
