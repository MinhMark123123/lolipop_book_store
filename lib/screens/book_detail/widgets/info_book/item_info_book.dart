import 'package:flutter/material.dart';

class ItemInfoBook extends StatelessWidget {
  final String title;
  final String value;

  const ItemInfoBook({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Expanded(
              child: Container(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new Text(
                        this.title + ":  ",
                        style: new TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 14.0,
                            color: Colors.black),
                      ),
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: new Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new Text(
                        this.value != null ? this.value : '',
                        style: new TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: Colors.black),
                      ),
                    ),
                    flex: 2,
                  )
                ],
              )),
            ),
          ],
        ),
        Divider(color: Colors.grey, height: 10)
      ],
    ));
  }
}
