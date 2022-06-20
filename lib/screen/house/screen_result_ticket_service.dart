import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../utils/AppUtil.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';
import '../../utils/DialogUtil.dart';
import '../../utils/constant.dart';
import 'request_house_medical.dart';
import 'widget_button_house_medical.dart';

class ScreenResultTicketService extends StatefulWidget {
  String name, result, id;
  List<String> fileIds;
  ScreenResultTicketService({Key key}) : super(key: key);

  @override
  _ScreenResultTicketServiceState createState() =>
      _ScreenResultTicketServiceState();
}

class _ScreenResultTicketServiceState extends State<ScreenResultTicketService>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();
  TextEditingController textControllerNote = TextEditingController();
  List<String> codeImage = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      codeImage = widget.fileIds ?? [];
      if (widget.result != null) {
        textControllerNote.text = widget.result;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'KẾT QUẢ ${widget.name}'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            const Text('Kết quả', style: Constants.styleTextTitleBlueColor),
            const SizedBox(height: 8),
            TextFormField(
              textInputAction: TextInputAction.done,
              minLines: 3,
              maxLines: 5,
              controller: textControllerNote,
              style: Constants.styleTextNormalBlueColor,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Constants.colorTextHint.withOpacity(0.3),
                  hintText: 'Nhập kết quả',
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
        ),
      ));

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
              ))
        ],
      );

  double heightListImage() {
    final int heightH = (codeImage.length / 2).ceil();
    return double.parse((heightH * 150).toString());
  }

  Future<void> onClickUpdate() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final int result = await request.requestUpdateServiceTicket(
        context, widget.id, textControllerNote.text.trim(), codeImage);
    if (result == 0) {
      await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
          messageSuccess: 'Cập nhật kết quả thành công', okBtnFunction: () {});
      Navigator.of(context).pop();
    }
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
          appUtil.showToastWithScaffoldState(_scaffoldKey, message);
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

  TextStyle styleText = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorText,
      fontWeight: FontWeight.w400,
      fontFamily: Constants.fontName,
      fontSize: 14);
}
