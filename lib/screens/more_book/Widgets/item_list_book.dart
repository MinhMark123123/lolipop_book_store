import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemListBook extends StatelessWidget {
  final String titleBook;
  final String urlImage;
  final String author;
  final String nhaXB;

  const ItemListBook(
      {Key key, this.titleBook, this.urlImage, this.author, this.nhaXB})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.all(10.0),
            child: new CachedNetworkImage(
              imageUrl: this.urlImage,
              width: 80.0,
              height: 115.0,
              fit: BoxFit.cover,
            ),
          ),
          new Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new Text(
                        this.titleBook,
                        style: new TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new Text(
                        'Tác giả: ${this.author}',
                        style: new TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.normal,
                            fontSize: 13.0,
                            color: Colors.black),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new Text(
                        '${this.nhaXB}',
                        style: new TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.normal,
                            fontSize: 13.0,
                            color: Colors.black),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    ]));
  }
}
