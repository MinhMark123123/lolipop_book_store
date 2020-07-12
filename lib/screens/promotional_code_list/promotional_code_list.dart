import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/promocodeModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/viewmodels/CRUDPromoCode.dart';
import 'package:lolipop_book_store/screens/promotional_code_list/Widgets/promo_code_item.dart';
import 'package:intl/intl.dart';

class PromotionalCodeList extends StatelessWidget {
  final String idUser;
  PromotionalCodeList({Key key, @required this.idUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CRUDPromoCode crudPromoCode = new CRUDPromoCode(idUser);

    Future<void> updatePromo(String idPromo) async {
      await crudPromoCode
          .getPromoCodeModelById(idPromo)
          .whenComplete(await crudPromoCode.updatePromoCodeModel(
            idPromo,
            fieldName: 'codeStatus',
            fieldValue: false,
          ));
    }

    DateTime convertDateTimefromString(String time) {
      DateTime dateTime;
      dateTime = new DateFormat('yyyy-MM-dd hh:mm:ss').parse(time);
      return dateTime;
    }

    final f = new DateFormat('dd-MM-yyyy');

    // TODO: implement build
    return StreamBuilder(
        stream: crudPromoCode.fetchPromoCodeModelsAsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.documents.length > 0) {
            print('Length Promo:  ${snapshot.data.documents.length}');
            for (var num = 0; num < snapshot.data.documents.length; num++) {
              if (convertDateTimefromString(
                          snapshot.data.documents[num]['expirationDate'])
                      .isBefore(DateTime.now()) &&
                  snapshot.data.documents[num]['codeStatus'] == true) {
                print(
                    'Promo thứ: ${num} - ${snapshot.data.documents[num]['valueCode']}');
                // updatePromo(snapshot.data.documents[num]['valueCode']);
                crudPromoCode.updatePromoCodeModel(
                    snapshot.data.documents[num]['valueCode'],
                    data: PromoCodeModel(
                      valueCode: snapshot.data.documents[num]['valueCode'],
                      amountDiscount: snapshot.data.documents[num]
                          ['amountDiscount'],
                      codeStatus: false,
                      expirationDate: snapshot.data.documents[num]
                          ['expirationDate'],
                      titleCode: snapshot.data.documents[num]['titleCode'],
                    ));
                print('Biến đổi Promo');
              }
            }
            return Scaffold(
              appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: new Text('Ưu đãi của tôi',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.amber[700],
              ),
              body: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data.documents[index]['codeStatus'] != false) {
                    return PromoCodeItem(
                      titleCode: snapshot.data.documents[index]['titleCode'],
                      valueCode: snapshot.data.documents[index]['valueCode'],
                      amountDiscount: snapshot.data.documents[index]
                          ['amountDiscount'],
                      expirationDate: f.format(convertDateTimefromString(
                          snapshot.data.documents[index]['expirationDate'])),
                      codeStatus: snapshot.data.documents[index]['codeStatus'],
                    );
                  }
                },
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: new Text('Ưu đãi của tôi',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.amber[700],
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/icon/promo_code.png',
                      height: 48, width: 48),
                  Text(
                    'Bạn không có mã khuyến mãi nào',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'RobotoSlab',
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
            );
          }
        });
  }
}
