import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/notificationModel.dart';
import 'package:lolipop_book_store/screens/notifications/promotion.dart';

class ItemNotification extends StatelessWidget {
  final String notiID;
  final String imageURL;
  final String title;
  final String content;
  final String date;

  ItemNotification({
    Key key,
    this.notiID,
    this.imageURL,
    this.title,
    this.content,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationModel noti = NotificationModel(
        notiID: this.notiID,
        content: this.content,
        title: this.title,
        imageURL: this.imageURL,
        date: this.date);

    // TODO: implement build
    return InkWell(
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                height: 100,
                width: 100,
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 5, left: 10, right: 10),
                      margin: EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            content,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RobotoSlab',
                            ),
                          ),
                          Text(
                            '${date.toString()}',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'RobotoSlab',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )))
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Promotion(noti)));
        });
  }
}
