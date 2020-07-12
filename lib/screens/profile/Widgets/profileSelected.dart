import 'package:flutter/material.dart';

class ProfileSelected extends StatelessWidget {
  final String label;
  final Function onTap;

  const ProfileSelected({Key key, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 00.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: new Text(
                      label,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'RobotoSlab',
                          color: Colors.black),
                    ),
                  )),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_right,
                        color: Colors.amber[700],
                        size: 40.0,
                      )
                    ],
                  )
                ],
              ),
              new Divider(color: Colors.grey[500]),
            ],
          )),
    );
  }
}
