import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lolipop_book_store/screens/categories/fiveFavoriteCategories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('$assetName', width: 300.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontFamily: 'RobotoSlab', fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontFamily: 'RobotoSlab',
          fontSize: 28.0,
          fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Đa dạng thể loại sách",
          body: "Được cung cấp từ nhiều Nhà xuất bản với đủ thể loại.",
          image: _buildImage('images/introduce/introduce1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Mua sách nhanh chóng, tiện lợi",
          body:
              "Chỉ với một lần chạm ở bất cứ đâu bạn cũng có thể mua sách, nhanh chóng, an toàn và dễ dàng với nhiều ưu đãi hấp dẫn.",
          image: _buildImage('images/introduce/introduce2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Thanh toán dễ dàng",
          body:
              "Có thể thanh toán trực tiếp khi nhận được sách hoặc thanh toán online thông qua ví điện tử Momo.",
          image: _buildImage('images/introduce/introduce3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Welcome",
          body:
              "Hãy tham gia cùng chúng tôi. Chúc bạn có những trải nghiệm tuyệt vời.",
          image: _buildImage('images/introduce/introduce4.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FiveFavoriteCategories(),
          ),
        );
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Bỏ qua',
        style: TextStyle(
          fontFamily: 'RobotoSlab',
        ),
      ),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Hoàn tất',
          style:
              TextStyle(fontFamily: 'RobotoSlab', fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
