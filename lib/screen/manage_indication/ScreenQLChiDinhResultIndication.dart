import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../extension/HexColor.dart';
import '../../model/IndicationData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';

// ignore: must_be_immutable
class ScreenQLChiDinhResultIndication extends StatefulWidget {
  IndicationData indication;
  ScreenQLChiDinhResultIndication({Key key, this.indication}) : super(key: key);

  @override
  _ScreenQLChiDinhResultIndicationState createState() =>
      _ScreenQLChiDinhResultIndicationState();
}

class _ScreenQLChiDinhResultIndicationState
    extends State<ScreenQLChiDinhResultIndication> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();

  TextEditingController textControllerNote = TextEditingController();

  final FocusNode focusNodeNote = FocusNode();

  List<String> codeImage = [];

  @override
  void initState() {
    super.initState();
    AppUtil.showPrint(widget.indication);
    if (widget.indication.state == 'RESOLVE') {
      editInfo();
    }
  }

  editInfo() {
    setState(() {
      String parsedString =
          widget.indication.result.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
      textControllerNote.text = parsedString.replaceAll('\n', '');
      List<String> imgCode = [];
      for (var i = 0; i < widget.indication.files.length; i++) {
        imgCode.add(widget.indication.files[i].id);
      }
      codeImage = imgCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicationData indicationItem = widget.indication;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppUtil.customAppBar(
              context,
              (indicationItem.state == 'RESOLVE')
                  ? 'KẾT QUẢ CHỈ ĐỊNH'
                  : 'TẠO KẾT QUẢ CHỈ ĐỊNH'),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
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
                              (indicationItem.patient != null &&
                                      indicationItem.patient.fullName != null)
                                  ? 'BN: ${indicationItem.patient.fullName}'
                                  : 'BN: ',
                              style: Constants.styleTextTitleBlueColor,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            (indicationItem.code != null)
                                ? rowText('Mã: ${indicationItem.code}')
                                : rowText('Mã: '),
                            (indicationItem.service != null &&
                                    indicationItem.service.name != null)
                                ? rowText(
                                    'Chỉ định: ${indicationItem.service.name}')
                                : rowText('Chỉ định: '),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Kết quả chỉ định',
                              style: Constants.styleTextTitleBlueColor,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              minLines: 5,
                              maxLines: 7,
                              controller: textControllerNote,
                              focusNode: focusNodeNote,
                              style: Constants.styleTextNormalBlueColor,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      HexColor.fromHex(Constants.Color_divider),
                                  hintText: 'Nhập kết quả chỉ định',
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Hình ảnh kết quả',
                                  style: Constants.styleTextTitleBlueColor,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    DefaultSmallRowButtonUI(
                                        clickButton: () => {onClickSelectImg()},
                                        color: Constants.Color_primary,
                                        name: 'Chọn file ảnh'),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    DefaultSmallRowButtonUI(
                                        clickButton: () => {onClickCamera()},
                                        color: Constants.Color_green,
                                        name: 'Camera'),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: heightListImage(),
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemCount: codeImage.length,
                                  itemBuilder: (BuildContext ctx, index) =>
                                      itemRowImage(codeImage[index])),
                            ),
                          ],
                        )
//                      ),
                        ),
                  ],
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
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                'CẬP NHẬT KẾT QUẢ CHỈ ĐỊNH',
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

  double heightListImage() {
    int heightH = (codeImage.length / 2).ceil();
    return double.parse((heightH * 150).toString());
  }

  rowText(String text) => Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(text, style: Constants.styleTextNormalMainColor)),
        ],
      );

  onClickCreate() {
    if (textControllerNote.text.trim().length == 0) {
      appUtil.showToastWithScaffoldState(
          _scaffoldKey, 'Kết quả chỉ định không được bỏ trống');
      return;
    }
    requestAddResultIndication();
  }

  onCLickShowZoomImg(String idImage) {
    String urlImg = dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] + idImage;
    AppUtil().showPopupAllScreen(context, urlImg);
  }

  onClickCamera() {
    ImageSource imageSource = ImageSource.camera;
    if (imageSource != null) {
      getImage(imageSource);
    }
  }

  onClickSelectImg() {
    ImageSource imageSource = ImageSource.gallery;
    if (imageSource != null) {
      getImage(imageSource);
    }
  }

  getImage(ImageSource imageSource) async {
    XFile image = await ImagePicker().pickImage(source: imageSource);
    if (image != null) {
      var img = File(image.path);
      var byteData = img.readAsBytesSync();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'photo',
        byteData,
        filename: '${DateTime.now().second}.jpg',
        contentType: MediaType('image', 'jpg'),
      );

      ApiGraphQLControllerMutation apiController =
          ApiGraphQLControllerMutation();

      QueryResult result =
          await apiController.uploadFileImage(context, multipartFile);

      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetIndications: $response');
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;
        if (code == 0) {
          setState(() {
            codeImage.add(responseData.data);
          });
        } else {
          appUtil.showToastWithScaffoldState(_scaffoldKey, message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    }
  }

  onClickDeleteImg(String img) {
    setState(() {
      codeImage.remove(img);
    });
  }

  requestAddResultIndication() async {
    ApiGraphQLControllerMutation apiController = ApiGraphQLControllerMutation();

    QueryResult result = await apiController.updateIndicationResult(
        context, widget.indication.id, textControllerNote.text, codeImage);

    String response = result.data.toString();
    AppUtil.showPrint('Response requestGetIndications: $response');
    if (response != null) {
      var responseData = appUtil.processResponseWithPage(result);
      int code = responseData.code;
      String message = responseData.message;
      if (code == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cập nhật kết quả chỉ định thành công!'),
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

  Widget itemRowImage(String imgUrl) => Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
                elevation: 4,
                child: GestureDetector(
                  child: Image.network(
                      dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] + imgUrl,
                      width: 200,
                      height: 200),
                  onTap: () {
                    onCLickShowZoomImg(imgUrl);
                  },
                )),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/img_delete.png',
                width: 20,
                height: 20,
                fit: BoxFit.fill,
              ),
            ),
            onTap: () async {
              onClickDeleteImg(imgUrl);
            },
          )
        ],
      );
}
