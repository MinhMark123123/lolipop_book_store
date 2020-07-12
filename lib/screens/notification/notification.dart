import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/viewmodels/CRUDNotification.dart';
import 'package:lolipop_book_store/screens/notification/Widgets/item_notification.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationScreenState();
  }
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final CRUDNotification crudPromoCode = new CRUDNotification();
    // TODO: implement build
    return StreamBuilder(
        stream: crudPromoCode.fetchNotificationModelsAsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.documents.length > 0) {
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
                    return ItemNotification(
                      notiID: snapshot.data.documents[index]['notiID'],
                      content: snapshot.data.documents[index]['content'],
                      date: snapshot.data.documents[index]['date'],
                      imageURL: snapshot.data.documents[index]['imageURL'],
                      title: snapshot.data.documents[index]['title'],
                    );
                  }),
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
                title: new Text('Thông báo',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.amber[700],
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    size: 48,
                    color: Colors.grey,
                  ),
                  Text(
                    'Bạn không có thông báo nào',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'RobotoSlab',
                      color: Colors.grey,
                    ),
                  ),
                ],
              )),
            );
          }
        });
  }
}
