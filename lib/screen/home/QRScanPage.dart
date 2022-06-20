import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../utils/AppUtil.dart';
import '../house/request_house_appoinment.dart';
import '../house/screen_house_appoinment_detail.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  // Barcode result;
  // QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller.pauseCamera();
    // }
    // controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppUtil.customAppBar(context, 'QUÉT MÃ ĐẶT KHÁM'),
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
          ],
        ),
      );

  onClickDetail() async {
    // if (result != null) {
    //   final RequestHouseAppoinment request = RequestHouseAppoinment();
    //   final String respone =
    //       await request.requestGetValidateQR(context, result.code);
    //   if (respone != null) {
    //     if (mounted) {
    //       Navigator.pop(context);
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (_) =>
    //                   ScreenHouseAppoinmentDetail(idAppoinment: respone)));
    //     }
    //   }
    // }
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    final scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    // return QRView(
    //   key: qrKey,
    //   onQRViewCreated: _onQRViewCreated,
    //   overlay: QrScannerOverlayShape(
    //       borderRadius: 10,
    //       borderLength: 30,
    //       borderWidth: 10,
    //       cutOutSize: scanArea),
    //   onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    // );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //       onClickDetail();
  //     });
  //   });
  // }

  // void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
  //   log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  //   if (!p) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('no Permission')),
  //     );
  //   }
  // }

  @override
  void dispose() {
    //controller?.dispose();
    super.dispose();
  }
}
