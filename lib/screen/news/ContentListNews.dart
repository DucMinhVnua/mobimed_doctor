import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../controller/UserApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/ArticleNewsData.dart';
import '../../model/GraphQLModels.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'ScreenWebViewNewsDetail.dart';

class ContentListNews extends StatefulWidget {
  const ContentListNews({
    Key key,
  }) : super(key: key);

  @override
  _ContentListNewsState createState() => _ContentListNewsState();
}

class _ContentListNewsState extends State<ContentListNews> {
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 5;
  AppUtil appUtil = AppUtil();

//  List<int> items = List.generate(10, (i) => i);
  List<Map<String, dynamic>> items = [];
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _getMoreData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// from - inclusive, to - exclusive
  Future<List<int>> fakeRequest(int from, int to) async => Future.delayed(
      const Duration(seconds: 2),
      () => List.generate(to - from, (i) => i + from));

  Future<void> _getMoreData() async {
    setState(() => isPerformingRequest = true);
    try {
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
      // ignore: avoid_init_to_null
      String response = null;
      // ignore: avoid_init_to_null
      QueryResult result = null;
      final String inReview =
          await AppUtil.getFromSetting(Constants.PREF_INREVIEW);
      if (inReview == 'true') {
        arrFilterinput.add(FilteredInput('type', 'USER_NEWS', ''));
        arrSortedinput.add(SortedInput('createdTime', true));
        final UserApiGraphQLControllerQuery apiController =
            UserApiGraphQLControllerQuery();

        result = await apiController.requestGetNewsArticles(
            context, page, arrFilterinput, arrSortedinput);
        response = result.data.toString();
      } else {
        arrFilterinput.add(FilteredInput('type', 'INTERNAL_NEWS', ''));
        arrSortedinput.add(SortedInput('createdTime', true));
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        result = await apiController.requestGetNewsArticles(
            context, page, arrFilterinput, arrSortedinput);
        response = result.data.toString();
      }

      AppUtil.showPrint('Response requestGetNewsArticles: $response');
      if (response != null && result != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;
//    var json = jsonDecode(result.);

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          if (mounted) {
            setState(() {
              items = json.decode(jsonData).cast<Map<String, dynamic>>();
              isPerformingRequest = false;
            });
          }
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
    if (!mounted) {
      return;
    }
//
  }

  Widget _buildProgressIndicator() => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: const CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return _buildProgressIndicator();
            } else {
              final ArticleNewsData itemData =
                  ArticleNewsData.fromJsonMap(items[index]);
              if (itemData != null) {
                return GestureDetector(
                    onTap: () async {
                      //Chuyển trạng thái tin tức này thành đã đọc
                      try {
                        setState(() {
                          items[index]['is_read'] = true;
                        });
                      } catch (e) {}

                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ScreenWebViewNewsDetail(
                                    newsID: itemData.id,
                                    title: itemData.title,
                                  )));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 8,
                              ),
                              Card(
                                elevation: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: FadeInImage(
                                    image:
                                        NetworkImage(itemData.thumbUrl ?? ''),
                                    placeholder: const AssetImage(
                                        'assets/defaultimage.png'),
                                    fit: BoxFit.cover,
                                    width: 85,
                                    height: 70,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    (itemData?.title != null)
                                        ? Text(itemData.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Constants.colorText,
                                                fontSize: 13,
                                                fontFamily: Constants.fontName,
                                                fontWeight: FontWeight.w600))
                                        : const SizedBox(
                                            height: 1,
                                          ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text('Xem chi tiết',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
//                                  SizedBox(height: 5,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: HexColor.fromHex(Constants.Color_divider),
                          thickness: 1,
                          indent: 120,
                        )
                      ],
                    ));
              } else {
                AppUtil.showPrint('### appointmentData KHÔNG CÓ DỮ LIỆU ');
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                return const SizedBox(
                  height: 0,
                );
              }
            }
          },
        ),
      );
}
