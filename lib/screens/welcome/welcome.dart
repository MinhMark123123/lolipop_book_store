import 'package:flutter/material.dart';
import 'package:lolipop_book_store/animation/fadeAnimation.dart';
import 'package:lolipop_book_store/screens/register/register.dart';
import 'package:lolipop_book_store/widgets/button/customButton.dart';
import 'package:lolipop_book_store/widgets/button/customButtonAnimation.dart';
import 'package:lolipop_book_store/screens/login/login.dart';
import 'package:lolipop_book_store/main.dart';
import 'package:lolipop_book_store/screens/forgot_password/forgot_password.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WelcomeState();
  }
}

class WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset("images/background/welcome.jpg", fit: BoxFit.cover),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF001117).withOpacity(0.7),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            margin: EdgeInsets.only(top: 90, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        2.4,
                        Text("Lollipop Book",
                            style: TextStyle(
                                color: Colors.amber[700],
                                fontFamily: 'AlfaSlabOne-Regular',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2))),
                    FadeAnimation(
                        2.6,
                        Text("Store",
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 30,
                              fontFamily: 'AlfaSlabOne-Regular',
                            ))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                        2.8,
                        CustomButton(
                          label: "Đăng Ký",
                          background: Colors.transparent,
                          fontColor: Colors.amber[700],
                          borderColor: Colors.amber[700],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                        )),
                    SizedBox(height: 20),
                    FadeAnimation(
                        3.2,
                        CustomButtonAnimation(
                          label: "Đăng Nhập",
                          backbround: Colors.amber[700],
                          borderColor: Colors.amber[700],
                          fontColor: Color(0xFFFFFFFF),
                          child: LoginPage(),
                        )),
                    SizedBox(height: 30),
                    FadeAnimation(
                        3.4,
                        InkWell(
                          child: Text("Quên mật khẩu?",
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontSize: 17,
                                fontFamily: 'RobotoSlab',
                              )),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                        )),
                    SizedBox(
                      height: 15.0,
                    ),
                    FadeAnimation(
                        3.6,
                        InkWell(
                          child: Text("Bỏ Qua",
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontSize: 17,
                                fontFamily: 'RobotoSlab',
                              )),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            );
                          },
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
