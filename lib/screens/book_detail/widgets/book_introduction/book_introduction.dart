import 'package:flutter/material.dart';

class BookIntroduction extends StatelessWidget {
  final String gioiThieuSach;
  BookIntroduction({Key key, @required this.gioiThieuSach}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Container(
          child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsetsDirectional.only(top: 10.0, start: 10.0, end: 10.0),
          child: new Text(gioiThieuSach,
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 14.0,
              ),
              textAlign: TextAlign.justify),
        ),
      )),
    );
  }
}
