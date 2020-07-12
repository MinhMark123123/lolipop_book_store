import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/screens/book_detail/book_detail.dart';
import 'package:lolipop_book_store/screens/checkout/address.dart';
import 'package:lolipop_book_store/screens/login/login.dart';
import 'package:lolipop_book_store/screens/more_book/more_book.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  Cart();

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List _bookList2;

  @override
  initState() {
    super.initState();

    _bookList2 = [];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double c_width = MediaQuery.of(context).size.width * 0.7;
    double c_height = MediaQuery.of(context).size.height * 0.62;
    Future<String> _getUserEmail() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String _userEmail = prefs.getString('userEmail');

      if (_userEmail != null) {
        print('User email: ' + _userEmail);

        return _userEmail;
      } else
        return '';
    }

    Future<List> _getBookInCart() async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      List _bookList = [];

      _bookList = await json.decode(_prefs.get('bookListCart'));
      //print(_bookList);

      if (_bookList.length <= 1) {
        return null;
      } else {
        _bookList2 = List.from(_bookList);
        return _bookList2;
      }
    }

    _removeAllBook(context, int index) async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _bookList2[_bookList2.length - 1]['tongSL'] -=
          _bookList2[index]['soLuongMua'];
      _bookList2[_bookList2.length - 1]['tongTien'] -=
          _bookList2[index]['giaTienDaGiam'];
      _bookList2.removeAt(index);
      await _prefs.setString("bookListCart", json.encode(_bookList2));

      await setState(() {});
      Navigator.of(context).pop();
    }

    Widget _removeBookDialog(BuildContext context, int index) {
      return AlertDialog(
          title: new Text('Thông báo'),
          content: new Text('Bạn muốn xóa sản phẩm này?'),
          actions: [
            FlatButton(
                child: new Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: new Text('Đồng ý'),
                onPressed: () {
                  _removeAllBook(context, index);
                })
          ]);
    }

    _showDialog(int index) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return _removeBookDialog(context, index);
          });
    }

    _deleteOneBook(int index) async {
      if (_bookList2[index]['soLuongMua'] >= 2) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        int soLuongMua = _bookList2[index]['soLuongMua'] - 1;
        await setState(() {
          _bookList2[index]['soLuongMua'] = soLuongMua;
          _bookList2[_bookList2.length - 1]['tongSL'] -= 1;
          _bookList2[_bookList2.length - 1]['tongTien'] -=
              _bookList2[index]['giaTienDaGiam'];
        });
        await _prefs.setString("bookListCart", json.encode(_bookList2));
      }
    }

    _addOneBook(int index) async {
      int soLuongMua = _bookList2[index]['soLuongMua'] + 1;
      if (soLuongMua <= _bookList2[index]['soLuong']) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        await setState(() {
          _bookList2[index]['soLuongMua'] += 1;
          _bookList2[_bookList2.length - 1]['tongSL'] += 1;
          _bookList2[_bookList2.length - 1]['tongTien'] +=
              _bookList2[index]['giaTienDaGiam'];
        });
        await _prefs.setString("bookListCart", json.encode(_bookList2));
      }
    }

    return SafeArea(
        //padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0, bottom: 0.0),
        child: FutureBuilder(
      future: _getBookInCart(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        //print(snapshot.data);
        if (snapshot.hasData) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                new Container(
                  height: c_height,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length - 1,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, right: 5.0),
                            child: Column(
                              children: <Widget>[
                                new Row(children: [
                                  CachedNetworkImage(
                                      imageUrl: snapshot.data[index]['biaSach'],
                                      height: 100,
                                      width: 70,
                                      fit: BoxFit.cover),
                                  new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, bottom: 5.0),
                                            width: c_width,
                                            child: new Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    snapshot.data[index]
                                                        ['tenSach'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 14.0,
                                                    )))),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, bottom: 5.0),
                                            width: c_width,
                                            child: new Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    '${snapshot.data[index]['giaTienDaGiam']} đ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontSize: 16.0,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                  right: 10.0,
                                                )),
                                                Ink(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.1),
                                                        color: Colors.red[500],
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0)),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _deleteOneBook(index);
                                                      },
                                                      child: Icon(Icons.remove),
                                                    )),
                                                Ink(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.1),
                                                        color: Colors.white,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0)),
                                                    child: InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                            width: 40.0,
                                                            height: 25.0,
                                                            child: Center(
                                                              child: Text(
                                                                  '${_bookList2[index]['soLuongMua']}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'RobotoSlab',
                                                                      fontSize:
                                                                          14.0)),
                                                            )))),
                                                Ink(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.1),
                                                        color:
                                                            Colors.green[500],
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0)),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _addOneBook(index);
                                                      },
                                                      child: Icon(Icons.add),
                                                    )),
                                                new Spacer(),
                                                Ink(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.1),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0)),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showDialog(index);
                                                      },
                                                      child: Icon(Icons.delete,
                                                          color: Colors.grey),
                                                    )),
                                              ],
                                            ))
                                      ])
                                ]),
                                new Divider(
                                  thickness: 1.0,
                                ),
                              ],
                            ));
                      }),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: new Column(
                      children: <Widget>[
                        Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              new Text('Số lượng:',
                                  style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 14.0)),
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    top: 5.0, bottom: 0.0, right: 15.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                      '${_bookList2[_bookList2.length - 1]['tongSL']}',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 16.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              new Text('Tổng tiền:',
                                  style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 14.0)),
                              Expanded(
                                  child: Container(
                                padding:
                                    EdgeInsets.only(bottom: 0.0, right: 15.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                      '${_bookList2[_bookList2.length - 1]['tongTien']} đ',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 16.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: FlatButton(
                              onPressed: () async {
                                String _userEmail = await _getUserEmail();
                                if (_userEmail != '') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Address()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                }
                              },
                              child: Container(
                                height: 40.0,
                                width: 350.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.yellow[700]),
                                child: Center(
                                  child: new Text('THANH TOÁN',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800])),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          CRUDBook crudBook;

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
                              child: new Text(
                                  _book.giaTienDaGiam.toString() + ' đ',
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

          return new Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Image(
                      image:
                          AssetImage('images/background/empty_cart_icon.png'),
                      height: 250,
                      width: 250,
                    ),
                    new Text('Giỏ hàng của bạn đang trống.',
                        style: TextStyle(
                            fontFamily: 'RobotoSlab', fontSize: 20.0)),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
              new Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      crudBook = new CRUDBook('dmSachMoiPhatHanh');
                      return new StreamBuilder(
                          stream: crudBook.fetchBooksAsStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return new Container(height: 0.0, width: 0.0);
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
                                            'Sách Mới Phát Hành',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontFamily: 'RobotoSlab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19.0),
                                          ),
                                        ),
                                        new Expanded(
                                          flex: 3,
                                          child: new InkWell(
                                              child: new Text('Xem tất cả >',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                  textAlign: TextAlign.right),
                                              onTap: (() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MoreBook(
                                                                itemHolder:
                                                                    'dmSachMoiPhatHanh')));
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
                                        itemCount: 7,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _showOneBook(
                                              context,
                                              BookModel.fromMap(snapshot
                                                  .data.documents[index].data));
                                        },
                                      )),
                                ],
                              );
                            }
                          });
                    }),
              )
            ],
          );
        }
      },
    ));
  }
}
