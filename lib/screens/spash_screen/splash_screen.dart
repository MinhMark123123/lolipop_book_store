import 'package:flutter/material.dart';
import 'package:lolipop_book_store/main.dart';
import 'package:lolipop_book_store/screens/onboarding/onboarding.dart';
import 'package:lolipop_book_store/screens/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  getFlagSkipOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool skipOnboard = prefs.containsKey('favoriteCategories');
    print('1' + skipOnboard.toString());
    return skipOnboard;
  }

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool login = prefs.containsKey('LoginStatus');
    if (login == false)
      return login;
    else {
      String loginStatus = prefs.get('LoginStatus');
      if (loginStatus != '')
        login = true;
      else
        login = false;
    }
    return login;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(seconds: 10), () async {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () async {
      bool isSkipBoarding = await getFlagSkipOnboarding();
      bool isLogin = await getLoginStatus();
      if (isSkipBoarding != true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Onboarding(),
          ),
        );
      }

      if (isLogin != true) {
        if (isSkipBoarding == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
      }
    });
    // TODO: implement build
    return new Scaffold(
        body: new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image(
            image: AssetImage('images/logo/logo.png'),
            fit: BoxFit.cover,
            height: 200.0,
            width: 200.0,
          ),
          new Container(
            margin: EdgeInsets.only(top: 10.0),
            child: new Text(
              'Lolipop Book Store',
              style: TextStyle(
                  color: Colors.amber[700],
                  fontFamily: 'RobotoSlab',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
    ));
  }
}
