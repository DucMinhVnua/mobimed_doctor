import 'dart:async';
import 'dart:io';
import 'package:DoctorApp/controller/ApiGraphQLControllerMutation.dart';
import 'package:DoctorApp/model/ConclusionData.dart';
import 'package:DoctorApp/model/MedicalSessionData.dart';
import 'package:DoctorApp/utils/DefaultSmallRowButtonUI.dart';
import 'package:DoctorApp/utils/DialogUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:DoctorApp/controller/ApiGraphQLControllerQuery.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class ScreenQLKhamBenhListConclusion extends StatefulWidget {
  MedicalSessionData medicalSessionData;

  ScreenQLKhamBenhListConclusion({Key key, this.medicalSessionData})
      : super(key: key);

  @override
  _ScreenQLKhamBenhListConclusionState createState() =>
      _ScreenQLKhamBenhListConclusionState();
}

class _ScreenQLKhamBenhListConclusionState
    extends State<ScreenQLKhamBenhListConclusion> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ConclusionData> items = [];
  AppUtil appUtil = AppUtil();
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;
  List<String> codeImage = [];
  bool isActionImage = false;

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _getMoreData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Null> reloadData() async {
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
    setState(() => {isPerformingRequest = true, codeImage = []});
    final ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

    final QueryResult result = await apiController.requestGetConclusions(
        context, widget.medicalSessionData.id);
    final String response = result.data.toString();
    AppUtil.showPrint('Response getIndicationHistory: $response');
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;

      if (code == 0) {
        final dataConlusions = responseData.data['conclusions'];
        if (dataConlusions != null)
          setState(() {
            items = List<ConclusionData>.from(
                dataConlusions.map((it) => ConclusionData.fromJsonMap(it)));
          });
        final dataFiles = responseData.data['files'];
        if (dataFiles != null) {
          final List<ConclusionFiles> imgFiles = List<ConclusionFiles>.from(
              dataFiles.map((it) => ConclusionFiles.fromJsonMap(it)));

          if (imgFiles.length > 0) {
            final List<String> imgItems = [];
            for (ConclusionFiles item in imgFiles) {
              imgItems.add(item.id);
            }
            setState(() {
              codeImage = imgItems;
            });
          }
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    }
  }

  // ignore: unused_element
  Widget _buildProgressIndicator() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'KẾT LUẬN KHÁM'),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: reloadData,
        child: ListView.builder(
          shrinkWrap: true,
          // itemCount: items.length + 1,
          itemCount: items == null ? 2 : items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                                (widget.medicalSessionData != null &&
                                        widget.medicalSessionData.patient !=
                                            null &&
                                        widget.medicalSessionData.patient
                                                .fullName !=
                                            null)
                                    ? 'BN: ${widget.medicalSessionData.patient.fullName}'
                                    : 'Không có thông tin BN',
                                style: Constants.styleTextTitleSubColor)),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 3,
                              ),
                              Image.asset(
                                'assets/img_add.png',
                                width: 32,
                                height: 32,
                              )
                            ],
                          ),
                          onTap: () async {
                            clickAddKetLuan();
                          },
                        )
                      ],
                    ),
                  ),
                  Text('Phiếu khám: ${widget.medicalSessionData.code}',
                      style: Constants.styleTextTitleSubColor),
                  const SizedBox(
                    height: 18,
                  )
                ],
              );
            }

            index -= 1;
            // if (items.length <= 0 || index >= items.length) {
            if (index == items.length) {
              return viewImg(); //_buildProgressIndicator();
            } else {
              final ConclusionData itemData = items[index];
              if (itemData != null) {
                return GestureDetector(
                    onTap: () async {},
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    itemData.name != null
                                        ? Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: (itemData.name !=
                                                            null)
                                                        ? Text(itemData.name,
                                                            style: Constants
                                                                .styleTextNormalBlueColor)
                                                        : const SizedBox(),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      DefaultSmallRowButtonUI(
                                                          clickButton: () => {
                                                                onClickEdit(
                                                                    itemData)
                                                              },
                                                          color: Constants
                                                              .Color_primary,
                                                          name: 'Sửa'),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      DefaultSmallRowButtonUI(
                                                          clickButton: () => {
                                                                clickDelete(
                                                                    itemData)
                                                              },
                                                          color: Constants
                                                              .Color_red,
                                                          name: 'Xoá')
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: HexColor.fromHex(Constants.Color_divider),
                        )
                      ],
                    )
//                              )
                    );
              } else {
                AppUtil.showPrint('### appointmentData KHÔNG CÓ DỮ LIỆU ');
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                return const SizedBox(
                  height: 0,
                );
              }
            }
          },
          controller: _scrollController,
        ),
      ));

  clickAddKetLuan() async {
    final String dialogResult = await DialogUtil.showDialogConfirmWithInput(
      _scaffoldKey,
      context,
      title: 'TẠO KẾT LUẬN KHÁM',
      inputHint: 'Nhập kết luận khám',
      message: '',
      inputValidate: 'Kết luận khám để trống',
    );

    if (dialogResult != null) {
      AppUtil.showLog('Kết luận khám: $dialogResult');
      requestAddKetLuan(dialogResult);
    } else {
      AppUtil.showLog('Kết luận khám: NULL');
    }
  }

  requestAddKetLuan(String resultText) async {
    final ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    final QueryResult result = await apiController.createConclusion(context,
        widget.medicalSessionData.id, {'code': '', 'name': resultText});
    final String response = result.data.toString();
    AppUtil.showPrint('Response requestAddKetLuan: $response');
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;

      if (code == 0) {
        _getMoreData();
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Thêm kết luận khám thành công');
      }
    } else {
      await AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }

  onClickEdit(ConclusionData conclusion) async {
    final String dialogResult = await DialogUtil.showDialogConfirmWithInput(
      _scaffoldKey,
      context,
      title: 'TẠO KẾT LUẬN KHÁM',
      inputHint: 'Nhập kết luận khám',
      message: conclusion.name,
      inputValidate: 'Kết luận khám để trống',
    );

    if (dialogResult != null) {
      AppUtil.showLog('Kết luận khám: $dialogResult');
      requestUpdateConclusion(conclusion.code, dialogResult);
    } else {
      AppUtil.showLog('Kết luận khám: NULL');
    }
  }

  requestUpdateConclusion(String code, String name) async {
    final ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    final QueryResult result = await apiController.updateConclusion(
        context, widget.medicalSessionData.id, {'code': code, 'name': name});
    final String response = result.data.toString();
    AppUtil.showPrint('Response requestUpdateConclusion: $response');
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;

      if (code == 0) {
        _getMoreData();
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Cật nhật kết luận khám thành công');
      }
    } else {
      await AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }

  clickDelete(ConclusionData conclusion) async {
    await DialogUtil.showDialogConfirmYesNo(_scaffoldKey, context,
        title: 'XÁC NHẬN XOÁ KẾT LUẬN KHÁM',
        message: 'Kết luận: ${conclusion.name}',
        nameButton: 'Đồng ý', okBtnFunction: () async {
      requestDelete(conclusion);
    });
  }

  requestDelete(ConclusionData conclusion) async {
    final ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    final QueryResult result = await apiController.deleteConclusion(
        context, widget.medicalSessionData.id, conclusion.code);
    final String response = result.data.toString();
    AppUtil.showPrint('Response requestDelete: $response');
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;

      if (code == 0) {
        _getMoreData();
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Xoá kết luận khám thành công');
      }
    } else {
      await AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }

  Widget itemRowImage(String imgUrl) => Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
                elevation: 4,
                child: GestureDetector(
                  child: Image.network(
                      dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] + imgUrl,
                      width: 200.0,
                      height: 200.0),
                  onTap: () {
                    onCLickShowZoomImg(imgUrl);
                  },
                )),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
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

  onCLickShowZoomImg(String idImage) {
    final String urlImg = dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] + idImage;
    AppUtil().showPopupAllScreen(context, urlImg);
  }

  onClickDeleteImg(String img) {
    isActionImage = true;
    setState(() {
      codeImage.remove(img);
    });
  }

  onClickCamera() {
    final ImageSource imageSource = ImageSource.camera;
    if (imageSource != null) {
      getImage(imageSource);
    }
  }

  onClickSelectImg() {
    final ImageSource imageSource = ImageSource.gallery;
    if (imageSource != null) {
      getImage(imageSource);
    }
  }

  getImage(ImageSource imageSource) async {
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

      isActionImage = true;
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
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    }
  }

  Widget viewImg() => Column(
        children: [
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
          (codeImage != null && codeImage.length > 0)
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
                      itemBuilder: (BuildContext ctx, index) {
                        return itemRowImage(codeImage[index]);
                      }),
                )
              : const SizedBox(),
          buttonUpdateImage()
        ],
      );

  double heightListImage() {
    final int heightH = (codeImage.length / 2).ceil();
    return double.parse((heightH * 150).toString());
  }

  Widget buttonUpdateImage() => isActionImage
      ? Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              height: 50,
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                color: HexColor.fromHex(Constants.Color_primary),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'CẬP NHẬT HÌNH ẢNH',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () async {
              requestUpdateImage();
            },
          ))
      : const SizedBox();

  requestUpdateImage() async {
    setState(() {
      isActionImage = false;
    });

    final ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    final QueryResult result = await apiController.updateImageConclusion(
        context, widget.medicalSessionData.id, codeImage);
    final String response = result.data.toString();
    AppUtil.showPrint('Response requestAddKetLuan: $response');
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;

      if (code == 0) {
        _getMoreData();
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Thêm kết luận khám thành công');
      }
    } else {
      await AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }
}
