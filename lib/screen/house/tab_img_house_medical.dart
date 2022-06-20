import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';
import '../../utils/DialogUtil.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_medical.dart';
import 'widget_button_house_medical.dart';

class TabImgHouseMedical extends StatefulWidget {
  String idTicket;
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  TabImgHouseMedical({Key key, this.idTicket, this.scaffoldKey, this.context})
      : super(key: key);
  @override
  TabImgHouseMedicalState createState() => TabImgHouseMedicalState();
}

class TabImgHouseMedicalState extends State<TabImgHouseMedical> {
  List<String> codeImage = [];
  List<String> codeImageOld = [];
  AppUtil appUtil = AppUtil();
  @override
  void initState() {
    super.initState();
    getTicketInfo();
  }

  Future<void> getTicketInfo() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final MedicalTicket respone =
        await request.requestTicketInfo(context, widget.idTicket);
    if (respone != null) {
      setState(() {
        codeImage = respone.fileIds ?? [];
        codeImageOld = respone.fileIds;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HÌNH ẢNH',
                style: TextStyle(
                    color: Constants.colorMain,
                    fontWeight: FontWeight.w600,
                    fontFamily: Constants.fontName,
                    fontSize: 15),
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
          const SizedBox(height: 5),
          codeImage != null && codeImage.isNotEmpty
              ? SizedBox(
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
                )
              : const SizedBox(),
          Align(
              child: WidgetButtonHouseMedical()
                ..name = 'CẬP NHẬT'
                ..onClick = onClickUpdate)
        ],
      );

  Future<void> onClickUpdate() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final int respone = await request.requestUpdateFileIdsTicket(
        context, widget.idTicket, codeImage);
    if (respone == 0) {
      await DialogUtil.showDialogCreateSuccess(
          widget.scaffoldKey, widget.context,
          messageSuccess: 'Cập nhật kết quả thành công', okBtnFunction: () {});
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
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              child: Image.asset(
                'assets/img_delete.png',
                width: 20,
                height: 20,
                fit: BoxFit.fill,
              ),
              onTap: () async {
                onClickDeleteImg(imgUrl);
              },
            ),
          )
        ],
      );

  double heightListImage() {
    final int heightH = (codeImage.length / 2).ceil();
    return double.parse((heightH * 150).toString());
  }

  void onCLickShowZoomImg(String idImage) {
    final String urlImg = dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] + idImage;
    AppUtil().showPopupAllScreen(context, urlImg);
  }

  void onClickCamera() {
    const ImageSource imageSource = ImageSource.camera;
    if (imageSource != null) {
      getImage(imageSource);
    }
  }

  void onClickSelectImg() {
    const ImageSource imageSource = ImageSource.gallery;
    if (imageSource != null) {
      getImage(imageSource);
    }
  }

  Future<void> getImage(ImageSource imageSource) async {
    final XFile image = await ImagePicker().pickImage(source: imageSource);
    if (image != null) {
      final img = File(image.path);
      final byteData = img.readAsBytesSync();

      final MultipartFile multipartFile = MultipartFile.fromBytes(
        'photo',
        byteData,
        filename: '${DateTime.now().second}.jpg',
        contentType: MediaType('image', 'jpg'),
      );

      final ApiGraphQLControllerMutation apiController =
          ApiGraphQLControllerMutation();

      final QueryResult result =
          await apiController.uploadFileImage(context, multipartFile);

      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetIndications: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;
        if (code == 0) {
          setState(() {
            codeImage.add(responseData.data);
          });
        } else {
          appUtil.showToastWithScaffoldState(widget.scaffoldKey, message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    }
  }

  void onClickDeleteImg(String img) {
    setState(() {
      codeImage.remove(img);
    });
  }

  Widget viewBtn(Function clickButton) => GestureDetector(
      onTap: clickButton, child: WidgetButtonHouseMedical()..name = 'CẬP NHẬT');

  TextStyle styleTextHint = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorTextHint,
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: 14);
  TextStyle styleText = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorText,
      fontWeight: FontWeight.w500,
      fontFamily: Constants.fontName,
      fontSize: 15);
}
