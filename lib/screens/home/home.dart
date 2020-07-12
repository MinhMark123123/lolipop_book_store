import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/models/categoryModel.dart';
import 'package:lolipop_book_store/screens/book_detail/book_detail.dart';
import 'package:lolipop_book_store/screens/more_book/more_book.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lolipop_book_store/viewmodels/CRUDCategory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lolipop_book_store/viewmodels/CRUDAdvertisement.dart';

class Home extends StatelessWidget {
  Home();

  CRUDBook crudBook;
  CRUDCategory crudCategory = new CRUDCategory();
  //Todo: Fetch all documents in DanhMucCollection
  Future<List> _fetchAllCategoryDocs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List categories = await json.decode(_prefs.get('favoriteCategories'));
    print(categories);
    print('Fetch Docs in DanhMucCollection successfully.');
    return categories;
  }

  //Todo: Hiển thị một cuốn sách
  Widget _showOneBook(BuildContext context, BookModel _book) {
    return InkWell(
        child: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: new Container(
                width: 100.0,
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                        imageUrl: _book.biaSach,
                        height: 150.0,
                        fit: BoxFit.cover),
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        _book.tenSach,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 15.0,
                            color: Colors.grey[700]),
                      ),
                    ),
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(_book.giaTien.toString() + ' đ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 16.0,
                              color: Colors.grey[700],
                              decoration: TextDecoration.lineThrough)),
                    ),
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(_book.giaTienDaGiam.toString() + ' đ',
                          style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 16.0,
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ))),
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookDetails(bookModel: _book)));
        }));
  }

  static CRUDAdvertisement crudAdvertisement = new CRUDAdvertisement();
  //Todo: Xử lý phần chạy quảng cáo
  Widget images_carousel = StreamBuilder(
      stream: crudAdvertisement.fetchAdvertisementsAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 200.0,
            child: new Carousel(
              boxFit: BoxFit.cover,
              images: [
                NetworkImage(snapshot.data.documents[0]['imageURL']),
                NetworkImage(snapshot.data.documents[1]['imageURL']),
                NetworkImage(snapshot.data.documents[2]['imageURL']),
                NetworkImage(snapshot.data.documents[3]['imageURL']),
                NetworkImage(snapshot.data.documents[4]['imageURL']),
              ],
              autoplay: true,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 1000),
              dotSize: 4.0,
              indicatorBgPadding: 6.0,
              dotColor: Colors.white,
              dotBgColor: Colors.amber[300].withOpacity(0.5),
            ),
          );
        }
        return Container(height: 200);
      });
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    // TODO: implement build
    return new Column(
      ///crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        new Expanded(
          child: new ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            children: [
              images_carousel,
              new FutureBuilder(
                  future: _fetchAllCategoryDocs(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshots) {
                    if (snapshots.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 6,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            crudBook =
                                new CRUDBook(snapshots.data[index]['idDM']);
                            return new StreamBuilder(
                                stream: crudBook.fetchBooksAsStream(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return new Container(
                                        height: 0.0, width: 0.0);
                                  } else {
                                    return new ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        new Padding(
                                            child: new Row(children: <Widget>[
                                              new Expanded(
                                                flex: 7,
                                                child: new Text(
                                                  snapshots.data[index]
                                                      ['tenDM'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontFamily: 'RobotoSlab',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19.0),
                                                ),
                                              ),
                                              new Expanded(
                                                flex: 3,
                                                child: new InkWell(
                                                    child: new Text(
                                                        'Xem tất cả >',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'RobotoSlab',
                                                            fontSize: 16.0,
                                                            color: Colors.grey),
                                                        textAlign:
                                                            TextAlign.right),
                                                    onTap: (() {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => MoreBook(
                                                                  itemHolder: snapshots
                                                                              .data[
                                                                          index]
                                                                      [
                                                                      'idDM'])));
                                                    })),
                                              )
                                            ]),
                                            padding: EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 12.0,
                                                left: 12.0,
                                                right: 10.0)),
                                        new SizedBox(
                                            height: 250.0,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 10,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _showOneBook(
                                                    context,
                                                    BookModel.fromMap(snapshot
                                                        .data
                                                        .documents[index]
                                                        .data));
                                              },
                                            )),
                                        new Divider(
                                          color: Colors.grey,
                                        )
                                      ],
                                    );
                                  }
                                });
                          });
                    } else {
                      return new Center(child: new Text('Please waiting...'));
                    }
                  })
            ],
          ),
        )
      ],
    );
  }
}
