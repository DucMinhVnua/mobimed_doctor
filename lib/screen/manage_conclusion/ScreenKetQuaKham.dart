import 'package:flutter/material.dart';
import '../../extension/HexColor.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

// ignore: must_be_immutable
class ScreenKetQuaKham extends StatefulWidget {
  String itemID = '';

  ScreenKetQuaKham({Key key, @required this.itemID}) : super(key: key);

  @override
  _ScreenKetQuaKhamState createState() => _ScreenKetQuaKhamState();
}

class _ScreenKetQuaKhamState extends State<ScreenKetQuaKham> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();

  String strResult =
      'Mặc dù có nhiều mặt hạn chế, nhưng chụp X-quang phổi thông thường vẫn là '
      'phương pháp đầu tiên giúp bác sĩ có thể chẩn đoán bệnh. So với các kỹ thuật thăm khám sức khỏe và '
      'chẩn đoán bệnh lý khác chụp X - quang phổi được áp dụng trong khá nhiều trường hợp khác nhau:';

  String testUrlImage =
      'https://image.vovworld.vn/w500/Uploaded/vovworld/vjryqdxwp/2017_06_29/xetnghiem_WNDE.jpg';

  @override
  void initState() {
    super.initState();

    loadPatientDetail(context);
  }

  loadPatientDetail(BuildContext context) async {
    try {} on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppUtil.customAppBar(context, 'KẾT QUẢ'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                    color: HexColor.fromHex(Constants.Color_divider),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(5))),
                child: Text(
                  strResult,
                  style: Constants.styleTextNormalBlueColor,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'KẾT QUẢ HÌNH ẢNH',
                style: Constants.styleTextNormalMainColor,
              ),
              const SizedBox(
                height: 12,
              ),
              for (var i = 0; i < 5; ++i)
                Column(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/defaultimage.png',
//                      image: "https://i.picsum.photos/id/9/250/250.jpg",
                      image: testUrlImage,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
            ],
          ),
        ),
      ));
}
