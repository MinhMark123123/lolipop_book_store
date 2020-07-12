import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoCodeItem extends StatelessWidget {
  final String titleCode;
  final String valueCode;
  final int amountDiscount;
  final String expirationDate;
  final bool codeStatus;

  const PromoCodeItem(
      {Key key,
      this.titleCode,
      this.valueCode,
      this.amountDiscount,
      this.expirationDate,
      this.codeStatus})
      : super(key: key);

  //final PromoCodeModel promocode;

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.amber[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/background/promocode.jpg',
            // height: 100,
            // width: 800,
          ),
          ExpansionTile(
            //key: PageStorageKey<PromoCodeModel>(promoCodeModel),
            title: Text(
              this.titleCode,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'RobotoSlab',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.local_activity,
                                  size: 16.0,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Mã giảm giá: ${this.valueCode}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'RobotoSlab',
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 16.0,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Hạn dùng: ${this.expirationDate}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'RobotoSlab',
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: valueCode));
                              showToast('Sao chép thành công');
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Container(
                              height: 40.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                              ),
                              child: Center(
                                child: Text('Sao Chép',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontFamily: 'RobotoSlab',
                                    )),
                              ),
                            ),
                            color: Colors.yellow[700],
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 15.0);
  }
}
