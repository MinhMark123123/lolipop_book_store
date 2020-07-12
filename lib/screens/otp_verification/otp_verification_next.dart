import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/main.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus { EmailPassword, Google, Facebook }

class OTPVerificationNext extends StatelessWidget {
  final String loginStatus;
  CRUDUser crudUser = new CRUDUser();
  final String phoneNumb;
  final FirebaseUser currentUser;
  String verificationIdNext;
  TextEditingController textEditingController = TextEditingController();
  OTPVerificationNext(
      {Key key,
      @required this.phoneNumb,
      @required this.currentUser,
      @required this.loginStatus})
      : super(key: key);
  void saveLoginStatus(status, userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('LoginStatus', status);
    await prefs.setString('userEmail', userEmail);
  }

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      print('Received phone auth credential: $phoneAuthCredential');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      verificationIdNext = verificationId;
      print("Code sent to " + phoneNumb);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      verificationIdNext = verificationId;
      print("Time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumb,
        timeout: const Duration(seconds: 100),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Widget _showOPTVerificationNextScreen(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("images/background/otp_verification.png",
                fit: BoxFit.cover)),
        SizedBox(height: 20.0),
        Text('OTP Verification',
            style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
        Container(
          padding:
              EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0, bottom: 30.0),
          child: Center(
            child: Text('Nhập OTP đã được gửi tới ',
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[500])),
          ),
        ),
        Container(
            width: 310,
            child: PinCodeTextField(
              length: 6,
              autoFocus: false,
              backgroundColor: Colors.transparent,
              inactiveColor: Colors.amber[800],
              obsecureText: false,
              animationType: AnimationType.fade,
              shape: PinCodeFieldShape.box,
              animationDuration: Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              textInputType: TextInputType.phone,
              controller: textEditingController,
            )),
        Container(
          padding: EdgeInsets.only(top: 30, bottom: 10.0),
          child: Text('Bạn chưa nhận được mã?',
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[500])),
        ),
        Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: InkWell(
                child: Text('Gửi lại OTP',
                    style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800])),
                onTap: () async {
                  await _sendCodeToPhoneNumber();
                })),
        SizedBox(height: 40),
        FlatButton(
            onPressed: () async {
              print(phoneNumb);
              print(textEditingController.text);
              final AuthCredential credential = PhoneAuthProvider.getCredential(
                verificationId: verificationIdNext,
                smsCode: textEditingController.text,
              );
              currentUser.linkWithCredential(credential).then((user) async {
                await crudUser.updateUser(currentUser.email,
                    fieldName: 'verification', fieldValue: 'true');
                await crudUser.updateUser(currentUser.email,
                    fieldName: 'soDienThoai', fieldValue: phoneNumb);
                saveLoginStatus(this.loginStatus, currentUser.email);

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              }).catchError((error) {
                print(error.toString());
              });
            },
            child: Container(
              height: 46.0,
              width: 350,
              child: Center(
                child: Text('XÁC NHẬN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoSlab')),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.amber[700]),
            ))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (verificationIdNext == null && phoneNumb != null) {
      _sendCodeToPhoneNumber();
    }

    // TODO: implement build
    return Scaffold(body: _showOPTVerificationNextScreen(context));
  }
}
