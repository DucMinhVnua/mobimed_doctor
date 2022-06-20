import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../extension/HexColor.dart';
import '../../model/ConclusionData.dart';
import '../../model/MedicalSessionData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

// ignore: must_be_immutable
class ScreenQLKhamBenhResultConclusion extends StatefulWidget {
  MedicalSessionData medicalSessionData;
  ConclusionData conclusionData;
  ScreenQLKhamBenhResultConclusion(
      {Key key, this.medicalSessionData, this.conclusionData})
      : super(key: key);

  @override
  _ScreenQLKhamBenhResultConclusionState createState() =>
      _ScreenQLKhamBenhResultConclusionState();
}

class _ScreenQLKhamBenhResultConclusionState
    extends State<ScreenQLKhamBenhResultConclusion> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();

  TextEditingController textControllerResult = TextEditingController();

  final FocusNode focusNodeNote = FocusNode();
  final FocusNode focusNodeResult = FocusNode();

  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    if (widget.conclusionData != null) {
      textControllerResult.text = widget.conclusionData.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MedicalSessionData medcalSeesionItem = widget.medicalSessionData;
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppUtil.customAppBar(context, 'KẾT LUẬN KHÁM'),
          body: Stack(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                (medcalSeesionItem.patient != null &&
                                        medcalSeesionItem.patient.fullName !=
                                            null)
                                    ? 'BN: ' +
                                        medcalSeesionItem.patient.fullName
                                    : 'BN: ',
                                style: Constants.styleTextTitleBlueColor,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'Bệnh chính',
                                  style: Constants.styleTextNormalBlueColor,
                                ),
                                value: isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    isChecked = newValue;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text(
                                'Kết luận khám',
                                style: Constants.styleTextTitleBlueColor,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                minLines: 4,
                                maxLines: 6,
                                controller: textControllerResult,
                                focusNode: focusNodeResult,
                                style: Constants.styleTextNormalBlueColor,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: HexColor.fromHex(
                                        Constants.Color_divider),
                                    hintText: 'Kết luận khám',
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          )
//                      ),
                          ),
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
                                BorderRadius.all(Radius.circular(25))),
                        color: HexColor.fromHex(Constants.Color_primary),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Expanded(
                              child: const Text(
                                'CẬP NHẬT KẾT LUẬN KHÁM',
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
                      onClickCreate();
                    },
                  )),
            ],
          )),
    );
  }

  rowText(String text) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 10,
        ),
        Expanded(child: Text(text, style: Constants.styleTextNormalMainColor)),
      ],
    );
  }

  onClickCreate() async {
    if (textControllerResult.text.trim().length == 0) {
      appUtil.showToastWithScaffoldState(
          _scaffoldKey, 'Kết quả chỉ định không được bỏ trống');
      return;
    }

    final ApiGraphQLControllerMutation apiController =
        ApiGraphQLControllerMutation();
    final dataSend = {
      'sessionCode': widget.medicalSessionData.code,
      'name': textControllerResult.text,
      'note': '',
      'main': isChecked
    };
    final QueryResult result =
        await apiController.updateMedicalSessionConclusion(context, dataSend);

    final String response = result.data.toString();
    AppUtil.showPrint('Response requestGetIndications: ' + response);
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;
      final String message = responseData.message;
      if (code == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cập nhật kết luận khám thành công!'),
            duration: const Duration(seconds: 3),
            backgroundColor: HexColor.fromHex(Constants.Color_primary),
          ),
        );
      } else {
        appUtil.showToastWithScaffoldState(_scaffoldKey, message);
      }
    } else {
      AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }

  onCLickShowZoomImg(String idImage) {
    final String urlImg = dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] + idImage;
    AppUtil().showPopupAllScreen(context, urlImg);
  }

  textFormField(
      TextEditingController controller, FocusNode focusNode, String hintText) {
    TextFormField(
      textInputAction: TextInputAction.done,
      minLines: 4,
      maxLines: 6,
      controller: controller,
      focusNode: focusNode,
      style: Constants.styleTextNormalBlueColor,
      decoration: InputDecoration(
          filled: true,
          fillColor: HexColor.fromHex(Constants.Color_divider),
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          )),
    );
  }
}
