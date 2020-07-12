import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/screens/web_view/web_view_container.dart';
import 'package:lolipop_book_store/viewmodels/CRUDNewsBook.dart';

class NewsBook extends StatefulWidget {
  @override
  NewsBookState createState() {
    // TODO: implement createState
    return NewsBookState();
  }
}

class NewsBookState extends State<NewsBook> {
  CRUDNewsBook crudNewsBook = new CRUDNewsBook();
  int _index = 0;
  Widget showCircularProgress() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber[800])));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: StreamBuilder(
            stream: crudNewsBook.fetchNewsBooksAsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.75, // card height
                    child: PageView.builder(
                      itemCount: snapshot.data.documents.length,
                      controller: PageController(viewportFraction: 0.78),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          child: Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: i == _index
                                      ? Colors.grey[200]
                                      : Colors.grey[400]),
                              child: Column(children: [
                                SizedBox(height: 6.0),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot.data
                                              .documents[i].data['urlBiaSach']),
                                          fit: BoxFit.cover)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  height: 250,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 15, left: 10, right: 10, bottom: 10),
                                  child: Text(
                                      snapshot.data.documents[i]['tenNoiDung'],
                                      style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 18,
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.justify,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 10, right: 10, bottom: 10),
                                  child: Text(
                                    snapshot.data.documents[i]['noiDung'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'RobotoSlab',
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 8,
                                  ),
                                )
                              ]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewContainer(
                                        snapshot.data.documents[i]
                                            ['urlNoiDung'])));
                          },
                        );
                      },
                    ),
                  ),
                );
              } else {
                return showCircularProgress();
              }
            }));
  }
}
