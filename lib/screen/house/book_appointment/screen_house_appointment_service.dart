// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'house_appointment_book_data.dart';
// import 'widget_home_pack.dart';

// class ScreenHomeAppointment extends StatefulWidget {
//   const ScreenHomeAppointment({Key key}) : super(key: key);

//   @override
//   _ScreenHomeAppointmentState createState() => _ScreenHomeAppointmentState();
// }

// class _ScreenHomeAppointmentState extends State<ScreenHomeAppointment> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   ScrollController scrollController = ScrollController();

//   List<PatientInput> arrRelationShips = [];
//   List<HomeMedicalPackData> arrPacks = [];
//   List<HomeMedicalPackData> arrHotPacks = [];
//   List<HomeMedicalServiceData> arrServices = [];
//   // PatientInput selectedRelationship;
//   int indexSelect = 0;

//   @override
//   void initState() {
//     super.initState();
//     getPacks();
//     getServices();
//   }

//   Future<void> getPacks() async {
//     final RequesstHouseMedical request = RequesstHouseMedical();
//     final List<HomeMedicalPackData> result =
//         await request.requestGetPackSearch(context, '');
//     if (result != null) {
//       setState(() {
//         arrPacks = result;
//       });
//     }
//   }

//   Future<void> getServices() async {
//     final RequesstHouseMedical request = RequesstHouseMedical();
//     final List<HomeMedicalServiceData> result =
//         await request.requestGetServicesSearch(context, '');
//     if (result != null) {
//       setState(() {
//         arrServices = result;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Constants.background,
//       appBar: AppUtil.customAppBarCart(context, 'ĐẶT KHÁM TẠI NHÀ'),
//       body: SingleChildScrollView(
//           child: Column(
//         children: [
//           viewPacks(),
//           viewServices(),
//         ],
//       )));
//   void onClickMoreService() {
//     Navigator.push(
//       context,
//       CupertinoPageRoute(builder: (context) => const ScreenHomeServices()),
//     );
//   }

//   Widget viewServices() => Container(
//       margin: const EdgeInsets.only(top: 15),
//       // decoration: BoxDecoration(
//       //     color: Constants.white,
//       //     border: Border.all(color: Constants.colorTextHint)),

//       decoration: decoration,
//       child: Column(
//         children: [
//           const SizedBox(height: 8),
//           viewTitle('  Danh mục dịch vụ', onClickMoreService),
//           const SizedBox(height: 8),
//           SizedBox(
//               height:
//                   arrServices.length > 9 ? 9 * 70.0 : arrServices.length * 70.0,
//               child: ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: arrServices.length > 9 ? 9 : arrServices.length,
//                 itemBuilder: (BuildContext context, int index) =>
//                     viewRowService(index),
//               )),
//           const SizedBox(height: 15),
//         ],
//       ));
//   Widget viewRowService(int index) {
//     final HomeMedicalServiceData item = arrServices[index];
//     return Container(
//         height: 70,
//         padding: const EdgeInsets.only(left: 10, right: 10),
//         child: Column(children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Text(
//               item.name,
//               style: const TextStyle(
//                   color: Constants.colorText,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: Constants.fontName,
//                   fontSize: 13),
//             ),
//             SizedBox(
//                 width: 25,
//                 height: 25,
//                 child: IconButton(
//                   padding: const EdgeInsets.all(1),
//                   iconSize: 20,
//                   color: Colors.amber,
//                   onPressed: () {
//                     onClickAddCart(item);
//                   },
//                   icon: Image.asset('assets/more/icn_add.png'),
//                 ))
//           ]),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             ButtonText(
//                 press: () {
//                   serviceDetail(item);
//                 },
//                 text: 'Mô tả dịch vụ'),
//             Text(
//               'Giá: ${AppUtil.convertMoney(item.price)}',
//               style: const TextStyle(
//                   color: Constants.colorMain,
//                   fontWeight: FontWeight.w200,
//                   fontFamily: Constants.fontName,
//                   fontSize: 13),
//             )
//           ]),
//           const Divider(
//             color: Constants.colorTextHint,
//           ),
//         ]));
//   }

//   void onClickAddCart(HomeMedicalServiceData item) {
//     setState(() {
//       AppUtil.arrCartServices.add(item);
//     });
//     // AppUtil.showToast(
//     //     context, 'Thêm dịch vụ ${item.name} vào giỏ hàng thành công!');
//   }

//   Future<void> serviceDetail(HomeMedicalServiceData item) async {
//     await Navigator.push(
//       context,
//       CupertinoPageRoute(
//           builder: (context) => ScreenHomeServiceDetail(idService: item.id)),
//     );
//   }

//   BoxDecoration decoration = const BoxDecoration(
//     color: Constants.white,
//     // borderRadius: BorderRadius.only(
//     //     bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
//     // boxShadow: <BoxShadow>[
//     //   BoxShadow(
//     //       color: Constants.colorText, offset: Offset(1.1, 1.1), blurRadius: 1),
//     // ],
//   );

//   void onClickMorePack() {
//     Navigator.push(
//       context,
//       CupertinoPageRoute(builder: (context) => const ScreenHomePacks()),
//     );
//   }

//   Widget viewTitle(String name, Function onClick) => Row(
//         children: <Widget>[
//           Expanded(
//             child: Text(
//               name,
//               textAlign: TextAlign.left,
//               style: const TextStyle(
//                 fontFamily: Constants.fontName,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15,
//                 letterSpacing: 0,
//                 color: Constants.colorText,
//               ),
//             ),
//           ),
//           // InkWell(
//           //   onTap: onClick,
//           //   child: const Padding(
//           //     padding: EdgeInsets.only(left: 8),
//           //     child: Text(
//           //       'Xem thêm   ',
//           //       textAlign: TextAlign.left,
//           //       style: TextStyle(
//           //         fontFamily: Constants.fontName,
//           //         fontWeight: FontWeight.w400,
//           //         fontStyle: FontStyle.italic,
//           //         fontSize: 13,
//           //         letterSpacing: 0,
//           //         color: Constants.colorMain, // Color(0xFF152358),
//           //       ),
//           //     ),
//           //   ),
//           // )
//           InkWell(
//             highlightColor: Colors.transparent,
//             borderRadius: const BorderRadius.all(Radius.circular(4)),
//             onTap: onClick,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Row(
//                 children: const <Widget>[
//                   Text(
//                     'Xem thêm',
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                       fontFamily: Constants.fontName,
//                       fontStyle: FontStyle.italic,
//                       fontWeight: FontWeight.normal,
//                       fontSize: 13,
//                       letterSpacing: 0,
//                       color: Constants.colorMain,
//                     ),
//                   ),
//                   Icon(Icons.navigate_next,
//                       size: 16, color: Constants.colorMain)
//                 ],
//               ),
//             ),
//           )
//         ],
//       );
//   Widget viewPacks() => Container(
//       margin: const EdgeInsets.only(top: 15),
//       padding: const EdgeInsets.fromLTRB(3, 8, 3, 0),
//       // decoration: BoxDecoration(
//       //     color: Constants.white,
//       //     border: Border.all(color: Constants.colorTextHint)),

//       decoration: decoration,
//       child: Column(
//         children: [
//           viewTitle('Danh mục gói khám', () {
//             onClickMorePack();
//           }),
//           const SizedBox(height: 8),
//           SizedBox(
//               height: (arrPacks.length / 2).ceil() > 3
//                   ? 3 * 125.0
//                   : (arrPacks.length / 2).ceil() * 125.0,
//               child: ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: (arrPacks.length / 2).ceil() > 3
//                     ? 3
//                     : (arrPacks.length / 2).ceil(),
//                 itemBuilder: (BuildContext context, int index) =>
//                     viewRowPack(index),
//               ))
//         ],
//       ));

//   Widget viewRowPack(int index) {
//     final HomeMedicalPackData data0 =
//         arrPacks.length > index * 2 ? arrPacks[index * 2] : null;
//     final HomeMedicalPackData data1 =
//         arrPacks.length > index * 2 + 1 ? arrPacks[index * 2 + 1] : null;
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//       data0 != null ? viewItemPack(data0, false) : containerDefault(),
//       data1 != null ? viewItemPack(data1, false) : containerDefault(),
//     ]);
//   }

//   Widget containerDefault() => Container(
//       margin: const EdgeInsets.only(top: 5, bottom: 5),
//       height: 110,
//       width: 172);

//   Widget viewItemPack(HomeMedicalPackData item, bool isTop) => GestureDetector(
//       onTap: () {
//         onClickDetail(item);
//       },
//       child: Container(
//           margin: isTop
//               ? const EdgeInsets.only(top: 5, bottom: 5, right: 10)
//               : const EdgeInsets.only(top: 5, bottom: 5),
//           decoration: const BoxDecoration(
//             color: Constants.white,
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                   color: Constants.colorText,
//                   offset: Offset(1.1, 1.1),
//                   blurRadius: 1),
//             ],
//           ),
//           height: 110,
//           width: 172,
//           child: WidgetHomePack()
//             ..imageId = item.imageId
//             ..name = item.name
//             ..price = item.price));

//   void onClickDetail(HomeMedicalPackData item) {
//     Navigator.push(
//       context,
//       CupertinoPageRoute(
//           builder: (context) => ScreenHomePackDetail(homeMedicalPacks: item)),
//     );
//   }
// }
