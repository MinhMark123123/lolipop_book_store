import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/userModel.dart';
import 'package:lolipop_book_store/screens/otp_verification/otp_verification_next.dart';
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';

class OTPVerification extends StatefulWidget {
  final String loginStatus;
  final User user;
  final FirebaseUser currentUser;
  OTPVerification(
      {Key key,
      @required this.currentUser,
      @required this.user,
      @required this.loginStatus})
      : super(key: key);

  @override
  OTPState createState() => OTPState();
}

class OTPState extends State<OTPVerification> {
  TextEditingController _phoneNumberController = TextEditingController();
  @override
  initState() {
    super.initState();
    if (_phoneNumberController.text != '') {
      _phoneNumberController.text =
          widget.user.soDienThoai.replaceRange(0, 3, '');
    }
  }

  Widget _showOPTVerificationScreen(BuildContext context) {
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
            child: Text(
                'Chúng tôi sẽ gởi một mã OTP dùng một lần đến số điện thoại này',
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[500])),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Text('Nhập số điện thoại của bạn',
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[500])),
        ),
        Container(
          width: 310,
          child: TextFormField(
            controller: _phoneNumberController,
            inputFormatters: [
              // Use with digits and separator parameters.
              SeparatedNumberInputFormatter(3, separator: ' '),
            ],
            style: TextStyle(fontSize: 22.0, fontFamily: 'RobotoSlab'),
            decoration: InputDecoration(
                hintText: '123 456 789',
                hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 22,
                    fontFamily: 'RobotoSlab'),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(
                    top: 4.0,
                    bottom: 4.0,
                    left: 20,
                    right: 20), //here your padding
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            keyboardType: TextInputType.phone,
          ),
        ),
        SizedBox(height: 40),
        FlatButton(
            onPressed: () async {
              print('OTP: ${widget.currentUser}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OTPVerificationNext(
                          phoneNumb: '+84' +
                              _phoneNumberController.text
                                  .replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                          currentUser: widget.currentUser,
                          loginStatus: widget.loginStatus)));
            },
            child: Container(
              height: 46.0,
              width: 350,
              child: Center(
                child: Text('TẠO MÃ OTP',
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
    // TODO: implement build
    return Scaffold(body: _showOPTVerificationScreen(context));
  }
}
