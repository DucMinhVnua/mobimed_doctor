import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenPolicy extends StatefulWidget {
  const ScreenPolicy({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenPolicyState();
}

class _ScreenPolicyState extends State<ScreenPolicy> {
  _ScreenPolicyState();
  @override
  void initState() {
    super.initState();
  }

  double heightSpace = 3;
  double heightTitle = 5;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'CHÍNH SÁCH DỊCH VỤ'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Ứng dụng này thuộc quyền sở hữu và quản lý của Bệnh viện đa khoa tỉnh Phú Thọ (Phu Tho General Hospital). Khi truy cập, sử dụng ứng dụng này. Quý khách đã mặc nhiên đồng ý với các điều khoản và điều kiện đề ra ở đây. Do vậy đề nghị Quý khách đọc và nghiên cứu kỹ trước khi sử dụng tiếp.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('1. CÁC ĐIỀU KHOẢN CỦA THỎA THUẬN DỊCH VỤ',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Thỏa thuận dịch vụ này (“Thỏa thuận”) cấu thành thỏa thuận pháp lý giữa Bạn (Người sử dụng dịch vụ ) và Bệnh viện đa khoa tỉnh Phú Thọ (sau đây gọi tắt là “Bệnh viện" hoặc "chúng tôi"), Một đơn vị chuyên cung cấp các dịch vụ chăm sóc sức khỏe trong lĩnh vực y tế tại Việt Nam, có địa chỉ tại:',
                  style: styleText),
              SizedBox(height: heightSpace),
              Text(
                  'Đường Nguyễn Tất Thành – Phường Tân Dân – TP. Việt Trì – Tỉnh Phú Thọ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  '- Bạn muốn tham gia vào thỏa thuận này bằng các sử dụng Nền tảng công nghệ của Bệnh viện đa khoa tỉnh Phú Thọ được định nghĩa dưới đây. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              Text(
                  '- Bạn muốn tham gia Thỏa thuận này nhằm mục đích truy cập và sử dụng dịch vụ chăm sóc sức khỏe tại Bệnh viện đa khoa tỉnh Phú Thọ. Bạn nhận thức đầy đủ và đồng ý rằng Bệnh viện đa khoa tỉnh Phú Thọ là một Đơn vị cung cấp dịch vụ chăm sóc sức khỏe.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Để sử dụng Nền tảng công nghệ Bệnh viện đa khoa tỉnh Phú Thọ, bạn phải đồng ý với các Điều khoản sử dụng dịch vụ (sau đây gọi là “Điều khoản”) dưới đây.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Các Điều khoản này do Bệnh viện đưa ra để điều chỉnh và áp dụng cho việc bạn truy cập và sử dụng các dịch vụ của Bệnh viện có trên trang Web của Bệnh viện đa khoa tỉnh Phú Thọ https://benhviendakhoatinhphutho.vn  và các ứng dụng của Bệnh viện trên điện thoại di động (sau đây gọi chung là Nền tảng công nghệ Bệnh viện đa khoa tỉnh Phú Thọ ). Qua việc truy cập và sử dụng Nền tảng công nghệ của chúng tôi, bạn đồng ý chịu sự ràng buộc bởi tất cả các Điều khoản được quy định tại đây. Nếu bạn không đồng ý với tất cả các Điều khoản này, đề nghị không sử dụng nền công nghệ của chúng tôi.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Việc sử dụng nền tảng công nghệ đồng nghĩa với việc bạn đã chấp thuận tất cả các Điều khoản của Thỏa thuận và các Điều khoản của Thỏa thuận có thể được Bệnh viện sửa đổi tại bất kỳ thời điểm nào. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Phiên bản Thỏa thuận mới nhất sẽ được cập nhật trên ứng dụng Bệnh viện đa khoa tỉnh Phú Thọ phiên bản mới nhất. Việc tiếp tục sử dụng Nền tảng công nghệ sau khi các thay đổi hoặc sửa đổi được đăng trên Internet sẽ được xem là chấp thuận toàn bộ các thay đổi hoặc sửa đổi đó.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Nền tảng công nghệ Bệnh viện đa khoa tỉnh Phú Thọ là nơi cung cấp dịch vụ chăm sóc sức khỏe không giới hạn ở: chẩn đoán, kê đơn, tư vấn, điều trị từ xa (gọi chung là “Dịch vụ chăm sóc sức khỏe”) có thể kết nối với các bệnh nhân có nhu cầu về chăm sóc sức khỏe (“Bệnh nhân") với các bác sĩ tại bệnh viện. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Ngoài ra, Nền tảng công nghệ cũng được sử dụng như một công cụ hỗ trợ bạn trong việc quản lý các thông tin liên quan đến chăm sóc sức khỏe của mình.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text('2. SỬ DỤNG NỀN TẢNG CÔNG NGHỆ',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bệnh viện đa khoa tỉnh Phú Thọ cho phép bạn truy cập Nền tảng công nghệ để lựa chọn dịch vụ khám chữa bệnh ngay trên điện thoại di động và trang web của chúng tôi  ( sau đây gọi chung là “Ứng dụng”) . Thông qua nền tảng công nghệ này, chúng tôi đề xuất các dịch vụ kết nối giữa bệnh viện và bạn – người cần dịch vụ chăm sóc sức khỏe của chúng tôi. Nền tảng công nghệ này chỉ dành cho người ít nhất từ 18 tuổi trở lên.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('3. TẠO MỘT TÀI KHOẢN TRÊN BỆNH VIỆN ĐA KHOA TỈNH PHÚ THỌ',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn cần đăng ký và tạo một tài khoản (“Tài khoản" của bạn) để sử dụng Nền tảng công nghệ Bệnh viện đa khoa tỉnh Phú Thọ (vui lòng xem Chính sách bảo mật của chúng tôi để biết thêm chi tiết).',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn cần đảm bảo rằng bạn đủ độ tuổi hợp pháp để hình thành một hợp đồng ràng buộc và không phải là người bị pháp luật hạn chế việc sử dụng các dịch vụ theo luật pháp Việt Nam hoặc theo các hệ thống pháp luật hiện hành khác. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn đảm bảo rằng tất cả các thông tin cá nhân mà bạn cung cấp cho chúng tôi (ví dụ, thông qua việc đăng ký hoặc quá trình tạo tài khoản ứng dụng) là chính xác, và bạn sẽ không tạo bất kỳ tài khoản nào cho bất cứ ai khác ngoài bản thân mình mà không có sự cho phép của người đó.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Chúng tôi bảo lưu quyền chặn hoặc khóa tài khoản của bạn nếu bất kỳ thông tin nào được cung cấp trong quá trình đăng ký hoặc sau đó chứng tỏ là không chính xác, sai sự thật, vi phạm các Điều khoản của chúng tôi, hoặc trong trường hợp bạn đã tạo ra nhiều hơn một tài khoản.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn chịu trách nhiệm cho việc duy trì tính bảo mật của mật khẩu và tài khoản của bạn, và đồng ý thông báo ngay cho chúng tôi nếu mật khẩu của bạn bị mất, bị đánh cắp, hoặc bị lộ cho một bên thứ ba trái phép nhằm tránh bị xâm nhập bất hợp pháp. Bạn hoàn toàn chịu trách nhiệm về các hoạt động diễn ra từ tài khoản của ban.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('4. THANH TOÁN',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Ứng dụng Bệnh viện đa khoa tỉnh Phú Thọ cho phép bạn thanh toán toàn bộ chi phí khám chữa bệnh của mình sau khi sử dụng dịch vụ. Bệnh viện đa khoa tỉnh Phú Thọ có quyền giữ lại toàn bộ hoặc một phần của Phí dịch vụ chăm sóc sức khỏe nếu tin rằng bạn đã cố gắng lừa gạt hoặc lạm dụng Bệnh viện đa khoa tỉnh Phú Thọ hoặc các hệ thống thanh toán của Bệnh viện.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('5. SỞ HỮU TRÍ TUỆ',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn nhận thức rõ rằng không có bất kỳ quyền đối với các bằng sáng chế, bản quyền, nhãn hiệu trong hoặc liên quan tới Nền tảng công nghệ (gọi chung là Tài sản trí tuệ của Bệnh viện đa khoa tỉnh Phú Thọ") được chuyển giao cho bạn.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn cũng nhận thức rõ ràng quyền chiếm hữu và quyền sở hữu  toàn diện đối với nền tảng công nghệ sẽ vẫn là tài sản độc quyền của Bệnh viện đa khoa tỉnh Phú Thọ và bạn sẽ không đòi hỏi bất kỳ quyền hạn nào đối với Nền tảng công nghệ này, trừ khi được đề cập rõ ràng ở trên.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Tất cả bản quyền và tài sản trí tuệ của Bệnh viện đa khoa tỉnh Phú Thọ trong và tài sản trí tuệ của Bệnh viện đa khoa tỉnh Phú Thọ trong và đối với Nền tảng công nghệ này (bao gồm nhưng không giới hạn ở: mọi logo, tên gọi, hình ảnh, tranh ảnh, hoạt ảnh, video, âm thanh, âm nhạc, văn bản và “giao diện” được tích hợp vào Nền tảng công nghệ), các chất liệu in ấn kèm theo và các bản sao của ứng dụng, được sở hữu bởi Bệnh viện đa khoa tỉnh Phú Thọ hoặc các nhà cung cấp thứ ba liên quan, ngoại trừ trường hợp cha mẹ hoặc người giám hộ hợp pháp của trẻ em dưới độ tuổi pháp lý để có thể tự mình tham gia giao dịch tạo tài khoản.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Ứng dụng và Nền tảng công nghệ này được bảo vệ bởi luật bản quyền, điều ước quốc tế về bản quyền, các luật và điều ước về sở hữu trí tuệ khác.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('6. THAY ĐỔI VÀ QUẢNG CÁO',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Nền tảng công nghệ của chúng tôi có thể thay đổi theo thời gian và / hoặc chúng tôi có thể ngừng (vĩnh viễn hoặc tạm thời) cung cấp Nền tảng công nghệ (hay các tính năng trong Nền tảng công nghệ này) mà không cần thông báo trước cho bạn. Nền tảng công nghệ của chúng tôi có thể bao gồm những quảng cáo mà có thể nhắm đến nội dung hoặc thông tin trên Nền tảng công nghệ, các truy vấn được thực hiện thông qua Nền tảng công nghệ này hoặc từ các thông tin khác. Loại hình và phạm vi quảng cáo trên Nền tảng công nghệ cũng có thể thay đổi theo thời gian. Khi cân nhắc về việc cung cấp cho bạn Nền tảng công nghệ, bạn nhất trí rằng chúng tôi và các nhà cung cấp thứ ba và các đối tác khác của chúng tôi có thể đặt quảng cáo trên Nền tảng công nghệ hoặc kết nối tới hiển thị nội dung | hoặc thông tin trên Nền tảng công nghệ, và theo đó chúng tôi có thể nhận được thù lao từ việc đặt quảng cáo như vậy.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('7. ĐĂNG TẢI NỘI DUNG',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Nền tảng công nghệ của chúng tôi cho phép bạn đăng tải, liên kết, lưu trữ, chia sẻ và các cách thức khác để tạo ra những thông tin, hình ảnh, videos, văn bản và/hoặc những nội dung khác (sau đây gọi là “Nội dung"). Bạn phải chịu trách nhiệm cho | những nội dung mà bạn đăng lên Nền tảng công nghệ của chúng tôi, bao gồm cả tính hợp pháp, độ tin cậy và sự phù hợp của nó. Bằng việc đưa nội dung lên Nền tảng công nghệ, bạn cho phép chúng tôi được quyền và cấp phép cho sử dụng, sửa đổi, trình diễn, hiển thị công khai, tái sản xuất, bán lại và phân phối các nội dung này trên và thông qua Nền tảng công nghệ. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn đồng ý rằng việc cấp phép này bao gồm cả trao cho chúng tôi quyền được làm cho nội dung của bạn hiển thị phục vụ những người dùng khác của Nền tảng công nghệ, những người này có thể sử dụng nội dung của bạn trong phạm vi tuân thủ các Điều khoản này bạn có thể giữ lại bất kỳ và toàn bộ các quyền hạn đối với cho phép bạn và những người dùng khác đăng tải, liên kết, lưu trữ, chia sẻ và các cách thức khác để tạo ra những thông tin, hình ảnh, videos, văn bản và/hoặc những nội dung khác (sau đây gọi là “Nội dung").',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn phải chịu trách nhiệm cho  những nội dung mà bạn đăng lên Nền tảng công nghệ của chúng tôi, bao gồm cả tính hợp pháp, độ tin cậy và sự phù hợp của nó.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bằng việc đưa nội dung lên Nền tảng công nghệ, bạn cho phép chúng tôi được quyền và cấp phép cho sử dụng, sửa đổi, trình diễn, hiển thị công khai, tái sản xuất, bán lại và phân phối các nội dung này trên và thông qua Nền tảng công nghệ.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn đồng ý rằng việc cấp phép này bao gồm cả trao cho chúng tôi quyền được làm cho nội dung của bạn hiển thị phục vụ những người dùng khác của Nền tảng công nghệ, những người này có thể sử dụng nội dung của bạn trong phạm vi tuân thủ các Điều khoản này.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn có thể giữ lại bất kỳ và toàn bộ các quyền hạn đối với những nội dung bạn gửi, đăng tải, hiển thị trên hoặc thông qua Nền tảng công nghệ và bạn có trách nhiệm bảo vệ các quyền đó. Bạn có thể gỡ bỏ các nội dung mà bạn đã đăng tải bằng cách xóa chúng đi  một cách cụ thể.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Tuy nhiên, trong những trường hợp nhất định, một số Nội dung (như bài viết hoặc ý kiến của bạn) có thể không được xóa bỏ hoàn toàn và bản sao của những Nội dung của bạn có thể vẫn tiếp tục tồn tại trên Nền tảng công nghệ của chúng tôi và/hoặc ở nơi khác.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Chúng tôi không chịu trách nhiệm cho việc gỡ bỏ hoặc xóa (hoặc việc gỡ bỏ hoặc xóa không thành công) bất kỳ nội dung nào trên Nền tảng công nghệ.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Bạn cam đoan và bảo đảm rằng: (i) Nội dung là của bạn (bạn sở  hữu nó), hoặc bạn có quyền sử dụng nó và trao cho chúng tôi các quyền và giấy phép như quy định tại các Điều khoản này, và (ii) Nội dung mà bạn đã đăng tải trên hoặc thông qua nền tảng của chúng tôi không vi phạm quyền riêng tư quyền công phạm quyền riêng tư, quyền công khai, quyền tác giả, quyền hợp đồng hoặc bất kỳ quyền nào của bất cứ người nào khác. Chúng tôi yêu cầu bạn tôn trọng Nền tảng công nghệ của chúng tôi và các bên thứ ba khi đăng tải Nội dung và sử dụng Nền tảng công nghệ. Khi đưa Nội dung  lên hoặc sử dụng Nền tảng công nghệ, bạn đồng ý sẽ không: ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  '• Đưa lên các tài liệu vi phạm quyền sở hữu của bên thứ ba, bao gồm cả các quyền riêng tư, quyền công khai hoặc vi phạm bất kỳ luật hiện hành nào khác; ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  '• Gửi các tài liệu trái pháp luật, tục tĩu, nói xấu, bôi nhọ, đe dọa, khiêu dâm, quấy rối, ghen ghét, phân biệt chủng tộc, chống đối chính quyền hoặc cổ động các hành  vi được coi là vi phạm pháp luật hình sự, làm phát sinh trách nhiệm dân sự, vi phạm hoặc không phù hợp với pháp luật nói chung;',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  '• Mạo danh người khác hoặc tự nhận là đại diện của chúng tôi, nhân viên của chúng tôi hoặc các chuyên gia khác trong ngành;',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text('• Thu lượm tên đăng ngành;',
                  style: styleText, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  '• Thu lượm tên đăng nhập, địa chỉ hoặc địa chỉ email của người dùng cho các mục đích khác.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Danh sách trên chỉ là một vài ví dụ và không được chỉ định là đã bao gồm đầy đủ các trường hợp và là duy nhất. Chúng tôi không có nghĩa vụ giám sát việc bạn truy cập hoặc sử dụng Nền tảng công nghệ hoặc kiểm tra hay chỉnh sửa Nội dung bất kỳ mà bạn đăng tải, nhưng chúng tôi có quyền làm như vậy vì mục đích vận hành Nền tảng công nghệ, hoặc để đảm bảo việc bạn tuân thủ các Điều khoản, tuân thủ pháp luật hiện hành hoặc theo yêu cầu của toà án, cơ quan hành chính, hoặc các cơ quan chính phủ khác. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Chúng tôi bảo lưu quyền đình chỉ hoặc chấm dứt Tài khoản, bất cứ lúc nào và không cần báo trước, loại bỏ hoặc vô hiệu hóa quyền truy cập vào bất kỳ Nội dung nào mà chúng tôi, tùy theo quyết định riêng của mình, xét thấy có sự vi phạm các Điều khoản này hoặc gây nguy hại tới Nền tảng công nghệ. ',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Chúng tôi cũng bảo lưu quyền đình chỉ hoặc chấm dứt Tài khoản của bạn và việc bạn sử dụng Nền tảng công nghệ của chúng tôi bất kỳ lúc nào trong trường hợp ban vi phạm các Điều khoản hoặc trong trường hợp Bệnh viện đa khoa tỉnh Phú Thọ ngừng cungcấp dịch vụ Nền tảng công nghệ | này vì bất kỳ lý do gì.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('9. NỘI DUNG BÊN THỨ 3',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('10. CÁC HÀNH VI KHÔNG ĐƯỢC PHÉP',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Nền tảng công nghệ của chúng tôi chỉ có thể được sử dụng và truy cập cho các mục đích hợp pháp. Bạn đồng ý rằng bạn sẽ không làm bất cứ điều nào sau đây khi sử dụng hoặc truy cập vào Nền tảng công nghệ: (i) cố gắng để truy cập hoặc tìm kiếm Nền tảng hoặc tải nội dung từ các dịch vụ thông qua việc sử dụng bất kỳ công cụ, phần mềm, công cụ, đại lý thiết bị hoặc cơ chế công cụ, đại lý, thiết bị hoặc cơ chế (bao gồm nhện, robot, trình thu thập, công cụ khai thác dữ liệu hoặc tương tự) nằm ngoài khác với các phần mềm và/hoặc tìm kiếm các đại lý cung cấp bởi chúng tôi hay nói chung là có sẵn trình duyệt web của bên thứ ba khác; (ii) tiếp cận, làm xáo trộn, hoặc sử dụng các khu vực ngoài công lập của Nền tảng, hệ thống máy tính của chúng tôi, hoặc hệ thống cung cấp kỹ thuật của các nhà cung cấp của chúng tôi; (iii) thu thập và sử dụng thông tin có sẵn thông qua Nền tảng, chẳng hạn như tên của người dùng khác, tên thật, địa chỉ email hoặc truyền đi bất cứ quảng cáo không mong muốn, thư rác, thư rác hoặc các hình thức chào mời; (iv) sử dụng Nền tảng cho bất kỳ mục đích thương mại hoặc vì lợi ích của bất kỳ bên thứ ba hoặc băng bất cứ cách không phải bởi những Điều khoản này; (v) vi phạm bất kỳ luật hoặc quy định hiện hành; hoặc (vi) khuyến khích hoặc cho phép bất kỳ cá nhân nào khác làm bất cứ việc nào nói trên. Chúng tôi bảo lưu quyền để điều tra và truy tố các hành vi vi phạm của bất kỳ hành vi nào ở trên và/hoặc liên quan đến và  hợp tác với các cơ quan thực thi pháp luật trong việc truy tố những người dùng vi phạm các Điều khoản này.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              SizedBox(height: heightTitle),
              Text('11. CHẤM DỨT THỎA THUẬN',
                  style: styleTextTitle, textAlign: TextAlign.justify),
              SizedBox(height: heightSpace),
              Text(
                  'Thỏa thuận này có hiệu lực cho tới thời điểm bị chấm dứt bởi Ban hoặc Bệnh viện đa khoa tỉnh Phú Thọ. Nếu bạn vi phạm bất kỳ quy định nào của các Điều khoản  này, chúng tôi có quyền đình chỉ hoặc vô hiệu hóa sự truy cập hoặc sử dụng của bạn đối với Ứng dụng và/hoặc Nền tảng công nghệ. Bạn có thể liên hệ với chúng tôi để hủy bỏ việc sử dụng Ứng dụng hoặc Nền tảng công nghệ Các quyền của bạn theo thỏa thuận này sẽ tự động chấm dứt mà không cần thông báo từ Bệnh viện đa khoa tỉnh Phú Thọ. Nếu bạn không tuân thủ bất kỳ Điều khoản nào của Thỏa thuận này. Khi chấm dứt Thỏa thuận này, bạn sẽ chấm dứt tất cả việc sử dụng Nền tảng công nghệ, và gỡ bỏ, tất cả hoặc một phần, các bản cài đặt/tải về của Nền tảng công nghệ.',
                  style: styleText,
                  textAlign: TextAlign.justify),
              const SizedBox(height: 15),
            ],
          ))));

  TextStyle styleTextTitle = const TextStyle(
      color: Constants.colorMain,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.fontName,
      fontSize: 16);

  TextStyle styleText = const TextStyle(
      color: Constants.colorText,
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: 14);
}
