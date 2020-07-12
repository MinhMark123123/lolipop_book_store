import 'package:flutter/material.dart';
import 'package:lolipop_book_store/widgets/button/customButton.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordState();
  }
}

class ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title:
              new Text('Đổi Mật Khẩu', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.amber[700],
        ),
        body: new Container(
            padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Đổi Mật Khẩu',
                            style: TextStyle(
                              fontSize: 38.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[700],
                              fontFamily: 'RobotoSlab',
                            ),
                          ),
                        ],
                      )),
                  new TextFormField(
                    style: new TextStyle(
                      color: Colors.amber[700],
                      fontFamily: 'RobotoSlab',
                    ),
                    decoration: InputDecoration(
                        labelText: 'Mật khẩu cũ',
                        hintText: 'Nhập mật khẩu cũ',
                        labelStyle: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 20.0,
                          fontFamily: 'RobotoSlab',
                        ),
                        hintStyle: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 20.0,
                          fontFamily: 'RobotoSlab',
                        ),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    obscureText: true,
                  ),
                  new Divider(color: Colors.amber[700]),
                  new TextFormField(
                    style: new TextStyle(
                      color: Colors.amber[700],
                      fontFamily: 'RobotoSlab',
                    ),
                    decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
                        hintText: 'Nhập mật khẩu mới',
                        labelStyle: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 20.0,
                          fontFamily: 'RobotoSlab',
                        ),
                        hintStyle: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 20.0,
                          fontFamily: 'RobotoSlab',
                        ),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    obscureText: true,
                  ),
                  new Divider(color: Colors.amber[700]),
                  new TextFormField(
                    style: new TextStyle(
                      color: Colors.amber[700],
                      fontFamily: 'RobotoSlab',
                    ),
                    decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu mới',
                        hintText: 'Nhập lại mật khẩu mới',
                        labelStyle: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 20.0,
                          fontFamily: 'RobotoSlab',
                        ),
                        hintStyle: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 20.0,
                          fontFamily: 'RobotoSlab',
                        ),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    obscureText: true,
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new CustomButton(
                    label: "Đổi Mật Khẩu",
                    background: Colors.amber[700],
                    fontColor: Colors.white,
                    borderColor: Colors.amber[700],
                    onTap: () {},
                  ),
                ])));
  }
}
