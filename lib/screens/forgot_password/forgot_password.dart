import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lolipop_book_store/widgets/button/customButton.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: new Text('Quên Mật Khẩu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber[700],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Quên Mật Khẩu',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                )),
            new SizedBox(
              height: 20.0,
            ),
            new Text(
                '''Nhập địa chỉ email của bạn. Bạn sẽ nhận được một liên kết trong mail của bạn để đổi mật khẩu.''',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'RobotoSlab')),
            new SizedBox(
              height: 10.0,
            ),
            new TextFormField(
              controller: emailController,
              style: new TextStyle(
                color: Colors.black,
                fontFamily: 'RobotoSlab',
              ),
              decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'abc@gmail.com',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontFamily: 'RobotoSlab',
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16.0,
                    fontFamily: 'RobotoSlab',
                  ),
                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
              obscureText: true,
            ),
            new SizedBox(
              height: 20.0,
            ),
            new CustomButton(
              label: "Khôi Phục Mật Khẩu",
              background: Colors.amber[700],
              fontColor: Colors.white,
              borderColor: Colors.amber[700],
              onTap: () {
                if (emailController.text == "") {
                  showToast('Vui lòng nhập email');
                } else {
                  sendPasswordResetEmail(emailController.text);
                  showToast('Kiểm tra email để đổi mật khẩu');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future sendPasswordResetEmail(String _email) async {
  return FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
}

void showToast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 15.0);
}
