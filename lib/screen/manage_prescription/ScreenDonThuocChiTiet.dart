import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extension/HexColor.dart';
import '../../model/PrescriptionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../home/ScreenShowPhoto.dart';

// ignore: must_be_immutable
class ScreenDonThuocChiTiet extends StatefulWidget {
  PrescriptionData prescriptionData;

  ScreenDonThuocChiTiet({Key key, @required this.prescriptionData})
      : super(key: key);

  @override
  _ScreenDonThuocChiTietState createState() => _ScreenDonThuocChiTietState();
}

class _ScreenDonThuocChiTietState extends State<ScreenDonThuocChiTiet> {
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

//  List<int> items = List.generate(10, (i) => i);
  List<DrugData> items = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    setState(() {
      items = widget.prescriptionData.drugs;

      /*    //tesst
      if(widget.prescriptionData.images == null) widget.prescriptionData.images = [];
      widget.prescriptionData.images.add("https://www.researchgate.net/profile/Bhupinder_Kalra/publication/308022532/figure/fig2/AS:405552686485507@1473702703895/Description-of-the-parts-of-prescription-Adopted-from-Goodman-and-Gilmans-The.png");
      widget.prescriptionData.images.add("https://i.stack.imgur.com/33DPC.jpg");
      widget.prescriptionData.images.add("https://www.researchgate.net/profile/Bhupinder_Kalra/publication/308022532/figure/fig2/AS:405552686485507@1473702703895/Description-of-the-parts-of-prescription-Adopted-from-Goodman-and-Gilmans-The.png");
      widget.prescriptionData.images.add("https://i.stack.imgur.com/33DPC.jpg");*/
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() => const SizedBox();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'ĐƠN THUỐC CHI TIẾT'),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Container(
          padding: const EdgeInsets.only(top: 10),
//            child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 15,
                    ),
                    Text('THÀNH PHẦN',
                        style: TextStyle(
                            color: HexColor.fromHex(Constants.Color_maintext),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return _buildProgressIndicator();
                    } else {
                      DrugData itemData = items[index];
                      if (itemData != null) {
                        return GestureDetector(
                          onTap: () async {},
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  (itemData?.name != null)
                                      ? Text(itemData.name,
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  Constants.Color_maintext),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal))
                                      : const SizedBox(
                                          height: 1,
                                        ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  (itemData?.amount != null)
                                      ? Text('Số lượng: ${itemData.amount}',
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  Constants.Color_subtext),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal))
                                      : const SizedBox(
                                          height: 1,
                                        ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  (itemData?.instruction != null)
                                      ? Text(itemData.instruction,
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  Constants.Color_hinttext),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal))
                                      : const SizedBox(
                                          height: 1,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        AppUtil.showPrint(
                            '### appointmentData KHÔNG CÓ DỮ LIỆU ');
                        return const SizedBox(
                          height: 0,
                        );
                      }
                    }
                  },
                  controller: _scrollController,
                ),
                widget.prescriptionData.imageUrls != null
                    ? Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 15,
                              ),
                              Text('CHỤP ĐƠN THUỐC',
                                  style: TextStyle(
                                      color: HexColor.fromHex(
                                          Constants.Color_maintext),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          widget.prescriptionData.imageUrls == null
                              ? Container(
                                  height: 300.0,
                                  width: 400.0,
                                  child: Icon(
                                    Icons.image,
                                    size: 250.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : SizedBox(
                                  height: 90.0,
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    color: Colors.white,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                                color: Colors.white,
                                                elevation: 4,
                                                child: GestureDetector(
                                                  child: Hero(
                                                    tag: widget.prescriptionData
                                                            .imageUrls[index] +
                                                        index.toString(),
                                                    child: FadeInImage(
                                                        image: NetworkImage(widget
                                                            .prescriptionData
                                                            .imageUrls[index]),
                                                        placeholder:
                                                            const AssetImage(
                                                                'assets/defaultimage.png')),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ScreenShowPhoto(
                                                                  filePath: widget
                                                                      .prescriptionData
                                                                      .imageUrls[index],
                                                                )));
                                                  },
                                                )),
                                          ),
                                        ],
                                      ),
                                      itemCount: widget
                                          .prescriptionData.imageUrls.length,
                                    ),
                                  )),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          )));
}
