import 'package:DoctorApp/controller/ApiGraphQLControllerQuery.dart';
import 'package:DoctorApp/model/PatientData.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const Color kPrimaryColor = Color(0xFFFF7643);
const Color kBackgoundColor = Color(0xFF091C40);
const Color kSecondaryColor = Color(0xFF606060);
const Color kRedColor = Color(0xFFFF1E46);

// ignore: must_be_immutable
class ScreenCallPatient extends StatefulWidget {
  PatientData patientData;

  ScreenCallPatient({Key key, @required this.patientData}) : super(key: key);

  @override
  _ScreenCallPatientState createState() => _ScreenCallPatientState();
}

class _ScreenCallPatientState extends State<ScreenCallPatient> {
  String uuid;
  var subscription;
  @override
  void initState() {
    callServer();
    super.initState();
  }

  @override
  dispose() {
    // subscription.cancel();
    super.dispose();
  }

  Constants constants = Constants();
  AppUtil appUtil = AppUtil();

  callServer() async {
    ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    String fcmID = await AppUtil.getFromSetting(Constants.PREF_FCM_ID);
    QueryResult result = await apiController.requestCallVideoPatient(
        context, widget.patientData.id, fcmID, true);
    String response = result.data.toString();
    AppUtil.showLogFull("Response requestGetUserActions: " + response);
    if (response != null) {
      var responseData = appUtil.processResponseWithPage(result);
      int code = responseData.code;
      String message = responseData.message;

      if (code == 0) {
        uuid = responseData.data['uuid'];
        // subscription = Future.delayed(const Duration(minutes: 5), () {
        //   // setState(() {
        //   //   name = 'okie con bê ' + DateTime.now().toString();
        //   // });
        //   onClickStopCallVideo();
        // });
      } else {
        AppUtil.showPopup(context, "Thông báo", message);
      }
    } else {
      AppUtil.showPopup(context, "Thông báo",
          "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
    }
  }

  onClickStopCallVideo() async {
    ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    String fcmID = await AppUtil.getFromSetting(Constants.PREF_FCM_ID);
    QueryResult result =
        await apiController.requestAnswerCallVideo(context, uuid, fcmID, false);
    String response = result.data.toString();
    if (response != null) {
      var responseData = appUtil.processResponseWithPage(result);
      int code = responseData.code;
      String message = responseData.message;

      if (code == 0) {
        Navigator.pop(context);
      } else {
        AppUtil.showPopup(context, "Thông báo", message);
      }
    } else {
      AppUtil.showPopup(context, "Thông báo",
          "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
    }
  }

  onClickBack() {
    onClickStopCallVideo();
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBarView(),
      backgroundColor: kBackgoundColor,
      body: bodyView(),
    );
  }

  Widget appBarView() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/Icon Back.svg"),
        onPressed: () => {onClickBack()},
      ),
    );
  }

  Widget bodyView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
            child: Column(
          children: [
            Text(
              widget.patientData.fullName,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.white),
            ),
            const Text(
              "Đang gọi ...",
              style: TextStyle(color: Colors.white60),
            ),
            const VerticalSpacing(),
            widget.patientData.avatar != null
                ? const DialUserPic(image: "assets/logo.png")
                : const DialUserPic(image: "assets/logo.png"),
            const Spacer(),
            const VerticalSpacing(),
            RoundedButton(
              iconSrc: "assets/icons/call_end.svg",
              color: kRedColor,
              iconColor: Colors.white,
              press: () {
                onClickBack();
              },
            ),
          ],
        )),
      ),
    );
  }
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // Our designer use iPhone 11, that's why we use 896.0
  return (inputHeight / 896.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 414 is the layout width that designer use or you can say iPhone 11  width
  return (inputWidth / 414.0) * screenWidth;
}

// For add free space vertically
class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({
    Key key,
    this.of = 20,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(of),
    );
  }
}

// For add free space horizontally
class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({
    Key key,
    this.of = 20,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(of),
    );
  }
}

class DialUserPic extends StatelessWidget {
  const DialUserPic({
    Key key,
    this.size = 192,
    this.image,
  }) : super(key: key);

  final double size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30 / 192 * size), // Padding depends on size
      width: getProportionateScreenWidth(size),
      height: getProportionateScreenWidth(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.5, 1],
        ),
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
      ),
    );
  }
}

class DialButton extends StatelessWidget {
  const DialButton({
    Key key,
    this.iconSrc,
    this.text,
    this.press,
  }) : super(key: key);

  final String iconSrc, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(120),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20),
          ),
        ),
        onPressed: press,
        child: Column(
          children: [
            SvgPicture.asset(
              iconSrc,
              color: Colors.white,
              height: 36,
            ),
            const VerticalSpacing(of: 5),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.size = 64,
    this.iconSrc,
    this.color,
    this.iconColor,
    this.press,
  }) : super(key: key);

  final double size;
  final String iconSrc;
  final Color color, iconColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(size),
      height: getProportionateScreenWidth(size),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(
              15 / 64 * size), // Padding depending on size of the button
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: press,
        child: SvgPicture.asset(
          iconSrc,
          color: iconColor,
        ),
      ),
    );
  }
}
