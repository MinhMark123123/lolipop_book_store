import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/notificationModel.dart';

class Promotion extends StatefulWidget {
  Promotion(this.noti);
  final NotificationModel noti;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PromotionState();
  }
}

class PromotionState extends State<Promotion> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: Text(
            widget.noti.title,
            style: TextStyle(fontFamily: 'RobotoSlab'),
          ),
        ),
        body: Column(children: [
          Container(
            color: Colors.white,
            child: CachedNetworkImage(
                imageUrl: widget.noti.imageURL,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.white,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(widget.noti.title,
                      style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      textAlign: TextAlign.center))),
          SizedBox(height: 10),
          Expanded(
              child: Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                  color: Colors.white,
                  child: SingleChildScrollView(
                      child: Text(
                    widget.noti.content,
                    style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 14,
                        color: Colors.grey),
                    textAlign: TextAlign.justify,
                  ))))
        ]));
  }
}
