import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lolipop_book_store/models/reviewModel.dart';
import 'package:lolipop_book_store/screens/book_detail/widgets/info_book/info_book.dart';
import 'package:lolipop_book_store/screens/book_detail/widgets/book_introduction/book_introduction.dart';
import 'package:lolipop_book_store/screens/book_detail/widgets/book_reviews/book_reviews.dart';
import 'package:lolipop_book_store/screens/book_detail/screens/comment_and_rate.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBookReview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookDetails extends StatefulWidget {
  final BookModel bookModel;
  final String idBook;
  final String idDM;
  BookDetails({Key key, this.bookModel, this.idBook, this.idDM})
      : super(key: key);
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;
  List _bookList = [];
  List _bookSample = [];

  //TODO: Nhận giá trị từ MoreBook và chuyền sang các màn hình con
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  Future<BookModel> getBookInfo(String idBook, String idDM) async {
    CRUDBook crudBook = new CRUDBook(widget.idDM);
    BookModel book = await crudBook.getBookByTitleBook(widget.idBook);
    return book;
  }

  Future<List<Review>> getListReview(String idBook, String idDM) async {
    CRUDBookReview crudBookReview = new CRUDBookReview(idBook, idDM);
    List reviews = await crudBookReview.fetchPromoCodeModels();
    return reviews;
  }

  Widget _addBookToCartDialog(BuildContext context) {
    return AlertDialog(
        title: new Text('Thông báo'),
        content: new Text('Đã thêm vào giỏ hàng.'),
        actions: [
          FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ]);
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return _addBookToCartDialog(context);
        });
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  _saveBookIntoCart(bookModel) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _bookUpdate = null;
    var _bookAdd = null;
    int _tongSL = 0;
    double _tongTien = 0;
    var _slTongTien;
    var _slTongTienSamp;
    // _bookList.clear();
    // _prefs.remove('bookListCart');
    if (await _prefs.containsKey("bookListCart") == null ||
        await _prefs.get('bookListCart') == null) {
      _bookList.add(bookModel);
      _slTongTien = {
        "tongSL": bookModel['soLuongMua'],
        "tongTien": bookModel['giaTienDaGiam']
      };
      print('Add book.}');
      if (_slTongTien != null) {
        _bookList.add(_slTongTien);
      }
      await _prefs.setString("bookListCart", json.encode(_bookList));
      await _showDialog();
    } else {
      _bookList = await json.decode(_prefs.get('bookListCart'));
      for (int i = 0; i < _bookList.length; i++) {
        if (_bookList[i]['tenSach'] == bookModel['tenSach']) {
          _bookUpdate = _bookList[i];
        }
        if (i == _bookList.length - 1) {
          _bookAdd = bookModel;
          _slTongTienSamp = _bookList[_bookList.length - 1];
        }
      }
      if (_bookAdd != null) {
        print('add');
        _bookList.add(_bookAdd);
        _tongSL = _slTongTienSamp['tongSL'] + _bookAdd['soLuongMua'];
        _tongTien = (_slTongTienSamp['tongTien'] +
                _bookAdd['giaTienDaGiam'] * _bookAdd['soLuongMua'])
            .toDouble();
        _slTongTien = {"tongSL": _tongSL, "tongTien": _tongTien};
        _bookList.removeWhere((_bo) => _bo['tongTien'] != null);
      }
      if (_bookUpdate != null) {
        _bookList
            .removeWhere((_bo) => _bo['tenSach'] == _bookUpdate['tenSach']);
        _bookList.removeWhere((_bo) => _bo['tongTien'] != null);
        _tongSL = _slTongTienSamp['tongSL'] + _bookAdd['soLuongMua'];
        _tongTien = (_slTongTienSamp['tongTien'] +
                _bookAdd['giaTienDaGiam'] * _bookAdd['soLuongMua'])
            .toDouble();
        _slTongTien = {"tongSL": _tongSL, "tongTien": _tongTien};
        _bookUpdate['soLuongMua'] += 1;
        _bookList.add(_bookUpdate);
      }
      if (_slTongTien != null) {
        _bookList.add(_slTongTien);
      }
      await _prefs.setString("bookListCart", json.encode(_bookList));
      await _showDialog();
    }

    print('BookList Final: ${_bookList.toString()}');
  }

  //Lấy email userName khi đăng nhập đc lưu ở SharePreferences
  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString('userEmail');
    if (_userEmail != null) {
      print('User email: ' + _userEmail);
      return _userEmail;
    } else
      return 'null';
  }

  double calculateAverageRating(double sum, int length) {
    double average = sum / length;
    return average;
  }

  getData(String idDM, String tenSach) async {
    return await Firestore.instance
        .collection('DanhMucCollection')
        .document(idDM)
        .collection("SachCollection")
        .document(tenSach)
        .collection("ReviewCollection")
        .getDocuments();
  }

  // Lấy tạng thái  đăng nhập
  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool login = prefs.containsKey('LoginStatus');
    if (login == false)
      return login;
    else {
      String loginStatus = prefs.get('LoginStatus');
      if (loginStatus != '')
        login = true;
      else
        login = false;
    }
    return login;
  }

  String convertBookStatus(bool status) {
    if (status == true) {
      return "Còn hàng";
    } else {
      return "Hết hàng";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookModel != null) {
      return Scaffold(
        body: NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  title: new Text(''),
                  expandedHeight: 510,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              new Container(
                                height: 190.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(widget.bookModel.biaSach),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.0),
                                  ),
                                ),
                              ),
                              new Container(
                                margin: EdgeInsetsDirectional.only(top: 70.0),
                                child: Center(
                                  child: Image.network(
                                    widget.bookModel.biaSach,
                                    height: 170,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Appbar
                            ],
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                left: 15.0,
                                right: 15.0,
                                bottom: 8.0),
                            child: new Column(
                              children: <Widget>[
                                new Text(widget.bookModel.tenSach,
                                    style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.center),
                                new Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                ),
                                new Text(widget.bookModel.tacGia,
                                    style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.center),
                                FutureBuilder(
                                    future: getListReview(
                                        widget.bookModel.tenSach,
                                        widget.bookModel.idDM),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData &&
                                          snapshot.data.length == 0) {
                                        print('Vô đây r nè');
                                        print(
                                            'Length sai: ${snapshot.data.length}');
                                        return RatingBarIndicator(
                                          rating: 0.0,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 25.0,
                                          direction: Axis.horizontal,
                                        );
                                      } else {
                                        print('Có dữ liệu đánh giá');
                                        double sumRating = 0;
                                        int lengthStar = 0;
                                        //double average = 0;
                                        Firestore.instance
                                            .collection('DanhMucCollection')
                                            .document(widget.bookModel.idDM)
                                            .collection("SachCollection")
                                            .document(widget.bookModel.tenSach)
                                            .collection("ReviewCollection")
                                            .getDocuments()
                                            .then((value) {
                                          print(
                                              'Value length of Collection: ${value.documents.length.toDouble()}');
                                          lengthStar = value.documents.length;
                                          // print(
                                          //     'LENGTH = ${length.toString()}');
                                          getData(widget.bookModel.idDM,
                                                  widget.bookModel.tenSach)
                                              .then((val) {
                                            for (int i = 0;
                                                i < val.documents.length;
                                                i++) {
                                              sumRating += val.documents[i]
                                                  .data["saoDanhGia"];
                                              print(
                                                  'Sao đánh giá ${i}: ${val.documents[i].data["saoDanhGia"]}');
                                            }

                                            print(
                                                'SUMMMMMM = ${sumRating.toString()}');
                                            print(
                                                'LENGTH = ${lengthStar.toString()}');
                                            // print(
                                            //     'AVERAGEEEE = ${average.toString()}');
                                            CRUDBook crudBook = new CRUDBook(
                                                widget.bookModel.idDM);
                                            crudBook.updateBook(
                                              widget.bookModel.tenSach,
                                              data: BookModel(
                                                biaSach:
                                                    widget.bookModel.biaSach,
                                                dinhDang:
                                                    widget.bookModel.dinhDang,
                                                giaTien:
                                                    widget.bookModel.giaTien,
                                                giaTienDaGiam: widget
                                                    .bookModel.giaTienDaGiam,
                                                gioiThieuSach: widget
                                                    .bookModel.gioiThieuSach,
                                                idDM: widget.bookModel.idDM,
                                                khoiLuong:
                                                    widget.bookModel.khoiLuong,
                                                kichThuoc:
                                                    widget.bookModel.kichThuoc,
                                                luotDanhGia: lengthStar,
                                                maSP: widget.bookModel.maSP,
                                                ngayPhatHanh: widget
                                                    .bookModel.ngayPhatHanh,
                                                ngonNgu:
                                                    widget.bookModel.ngonNgu,
                                                nguoiDich:
                                                    widget.bookModel.nguoiDich,
                                                nhaPhatHanh: widget
                                                    .bookModel.nhaPhatHanh,
                                                nhaXuatBan:
                                                    widget.bookModel.nhaXuatBan,
                                                phanTramGiamGia: widget
                                                    .bookModel.phanTramGiamGia,
                                                soLuong:
                                                    widget.bookModel.soLuong,
                                                soTrang:
                                                    widget.bookModel.soTrang,
                                                tacGia: widget.bookModel.tacGia,
                                                tenSach:
                                                    widget.bookModel.tenSach,
                                                trangThai:
                                                    widget.bookModel.trangThai,
                                                danhGia: sumRating.toInt(),
                                              ),
                                            );
                                          });
                                        });
                                        if ((widget.bookModel.luotDanhGia ==
                                                    0 &&
                                                widget.bookModel.danhGia ==
                                                    0) ||
                                            widget.bookModel.luotDanhGia == 0 ||
                                            widget.bookModel.danhGia == 0) {
                                          return RatingBarIndicator(
                                            rating: 0,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 25.0,
                                            direction: Axis.horizontal,
                                          );
                                        } else {
                                          return RatingBarIndicator(
                                            rating: widget.bookModel.danhGia
                                                    .toDouble() /
                                                widget.bookModel.luotDanhGia,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 25.0,
                                            direction: Axis.horizontal,
                                          );
                                        }
                                      }
                                    }),
                                new Divider(
                                  height: 26.0,
                                  thickness: 1.0,
                                ),
                                new Align(
                                    alignment: Alignment.centerLeft,
                                    child: new RichText(
                                      text: TextSpan(
                                        text: 'Giá bìa: ',
                                        style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[800],
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${widget.bookModel.giaTien} đ ',
                                            style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 14.0,
                                                color: Colors.grey[800],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    )),
                                new Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                ),
                                new Align(
                                    alignment: Alignment.centerLeft,
                                    child: new RichText(
                                      text: TextSpan(
                                        text: 'Giá bán:',
                                        style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[800],
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  ' ${widget.bookModel.giaTienDaGiam} đ ',
                                              style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[500],
                                              )),
                                          TextSpan(
                                              text:
                                                  '   (Giảm giá ${widget.bookModel.phanTramGiamGia}%)',
                                              style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[800],
                                              ))
                                        ],
                                      ),
                                    )),
                                new Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                ),
                                new Align(
                                    alignment: Alignment.centerLeft,
                                    child: new RichText(
                                      text: TextSpan(
                                        text: 'Trạng thái: ',
                                        style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[800],
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: convertBookStatus(
                                                  widget.bookModel.trangThai),
                                              style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[800],
                                              )),
                                        ],
                                      ),
                                    )),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                ),
                                FlatButton(
                                    onPressed: () async {
                                      CRUDBook crudBook =
                                          new CRUDBook(widget.bookModel.idDM);
                                      BookModel book =
                                          await crudBook.getBookByTitleBook(
                                              widget.bookModel.tenSach);
                                      if (book.trangThai == true) {
                                        var _book = {
                                          'biaSach': widget.bookModel.biaSach,
                                          'giaTienDaGiam':
                                              widget.bookModel.giaTienDaGiam,
                                          'idDM': widget.bookModel.idDM,
                                          'maSP': widget.bookModel.maSP,
                                          'ngonNgu': widget.bookModel.ngonNgu,
                                          'nhaPhatHanh':
                                              widget.bookModel.nhaPhatHanh,
                                          'nhaXuatBan':
                                              widget.bookModel.nhaXuatBan,
                                          'phanTramGiamGia':
                                              widget.bookModel.phanTramGiamGia,
                                          'tacGia': widget.bookModel.tacGia,
                                          'tenSach': widget.bookModel.tenSach,
                                          'soLuongMua': 1,
                                          'soLuong': widget.bookModel.soLuong,
                                        };
                                        _saveBookIntoCart(_book);
                                      } else {
                                        showToast("Sách đã hết hàng.");
                                      }
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: 350.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.yellow[700]),
                                      child: Center(
                                        child: new Text('THÊM VÀO GIỎ HÀNG',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'RobotoSlab',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800])),
                                      ),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  pinned: true,
                  floating: true,
                  forceElevated: boxIsScrolled,
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: 30.0,
                      indicatorColor: Colors.amber[700],
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    unselectedLabelColor: Colors.amber[800],
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    tabs: [
                      Tab(
                          child: new Text('Thông Tin',
                              style: TextStyle(
                                  fontFamily: 'RobotoSlab', fontSize: 15.0))),
                      Tab(
                          child: new Text('Giới Thiệu',
                              style: TextStyle(
                                  fontFamily: 'RobotoSlab', fontSize: 15.0))),
                      Tab(
                          child: new Text('Bình Luận',
                              style: TextStyle(
                                  fontFamily: 'RobotoSlab', fontSize: 15.0))),
                    ],
                    controller: _tabController,
                  ),
                )
              ];
            },
            body: TabBarView(children: [
              InfoBook(
                  tacGia: widget.bookModel.tacGia,
                  nhaXuatBan: widget.bookModel.nhaXuatBan,
                  maSP: widget.bookModel.maSP,
                  nhaPhatHanh: widget.bookModel.nhaPhatHanh,
                  khoiLuong: widget.bookModel.khoiLuong,
                  kichThuoc: widget.bookModel.kichThuoc,
                  ngonNgu: widget.bookModel.ngonNgu,
                  nguoiDich: widget.bookModel.nguoiDich,
                  dinhDang: widget.bookModel.dinhDang,
                  soTrang: widget.bookModel.soTrang),
              BookIntroduction(
                gioiThieuSach: widget.bookModel.gioiThieuSach,
              ),
              BookReviews(
                documentCategory: widget.bookModel.idDM,
                documentBook: widget.bookModel.tenSach,
              )
            ], controller: _tabController)),
        //TODO: Floating Action Button
        floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          //child: Icon(Icons.add),
          //visible: _dialVisible,
          // If true user is forced to close dial manually
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('Mở FAB'),
          onClose: () => print('Đóng FAB'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.amber[700],
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            // SpeedDialChild(
            //     child: Icon(Icons.add_shopping_cart),
            //     backgroundColor: Colors.green,
            //     label: 'Thêm vào giỏ hàng',
            //     labelStyle: TextStyle(
            //         fontFamily: 'RobotoSlab',
            //         fontSize: 18.0,
            //         color: Colors.white),
            //     labelBackgroundColor: Colors.green,
            //     onTap: () => print('Đã Thêm vào giỏ hàng')),
            SpeedDialChild(
              child: Icon(Icons.favorite),
              backgroundColor: Colors.red,
              label: 'Thêm vào yêu thích',
              labelStyle: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18.0,
                  color: Colors.white),
              labelBackgroundColor: Colors.red,
              onTap: () async {
                print('Đã Thêm vào yêu thích');
                String userName = await _getUserEmail();
                // Firestore.instance
                //     .collection('UserCollection')
                //     .document(userName)
                //     .collection('FavoriteBookCollection')
                //     .document(widget.bookModel.tenSach)
                //     .setData(widget.bookModel.toJson());
                // showToast('Đã thêm sách vào yêu thích');

                if (userName == "") {
                  showToast("Bạn cần đăng nhập để thêm sách vào yêu thích");
                } else {
                  Firestore.instance
                      .collection('UserCollection')
                      .document(userName)
                      .collection('FavoriteBookCollection')
                      .document(widget.bookModel.tenSach)
                      .setData(widget.bookModel.toJson());
                  showToast('Đã thêm sách vào yêu thích');
                  print('Đã Thêm vào yêu thích');
                }
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.chat),
              backgroundColor: Colors.blue,
              label: 'Đánh giá sách',
              labelStyle: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18.0,
                  color: Colors.white),
              labelBackgroundColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentAndRate(
                      documentCategory: widget.bookModel.idDM,
                      documentBook: widget.bookModel.tenSach,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else if (widget.idBook != null && widget.idDM != null) {
      return FutureBuilder(
          future: getBookInfo(widget.idBook, widget.idDM),
          builder: (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
            return Scaffold(
              body: NestedScrollView(
                  controller: _scrollViewController,
                  headerSliverBuilder:
                      (BuildContext context, bool boxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        title: new Text(''),
                        expandedHeight: 510,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    new Container(
                                      height: 190.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data.biaSach),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.0),
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      margin:
                                          EdgeInsetsDirectional.only(top: 70.0),
                                      child: Center(
                                        child: Image.network(
                                          snapshot.data.biaSach,
                                          height: 170,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Appbar
                                  ],
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: 20.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 8.0),
                                  child: new Column(
                                    children: <Widget>[
                                      new Text(snapshot.data.tenSach,
                                          style: TextStyle(
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                          textAlign: TextAlign.center),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      new Text(snapshot.data.tacGia,
                                          style: TextStyle(
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[800],
                                          ),
                                          textAlign: TextAlign.center),
                                      new Divider(
                                        height: 30.0,
                                        thickness: 1.0,
                                      ),
                                      new Align(
                                          alignment: Alignment.centerLeft,
                                          child: new RichText(
                                            text: TextSpan(
                                              text: 'Giá bìa: ',
                                              style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[800],
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '${snapshot.data.giaTien} đ ',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 14.0,
                                                      color: Colors.grey[800],
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                              ],
                                            ),
                                          )),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      new Align(
                                          alignment: Alignment.centerLeft,
                                          child: new RichText(
                                            text: TextSpan(
                                              text: 'Giá bán:',
                                              style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[800],
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        ' ${snapshot.data.giaTienDaGiam} đ ',
                                                    style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red[500],
                                                    )),
                                                TextSpan(
                                                    text:
                                                        '   (Giảm giá ${snapshot.data.phanTramGiamGia}%)',
                                                    style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey[800],
                                                    ))
                                              ],
                                            ),
                                          )),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      new Align(
                                          alignment: Alignment.centerLeft,
                                          child: new RichText(
                                            text: TextSpan(
                                              text: 'Trạng thái:',
                                              style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[800],
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        ' ${snapshot.data.trangThai}',
                                                    style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.amber[800],
                                                    )),
                                              ],
                                            ),
                                          )),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                      ),
                                      FlatButton(
                                          onPressed: () {
                                            var _book = {
                                              'biaSach': snapshot.data.biaSach,
                                              'giaTienDaGiam': widget
                                                  .bookModel.giaTienDaGiam,
                                              'idDM': snapshot.data.idDM,
                                              'maSP': widget.bookModel.maSP,
                                              'ngonNgu': snapshot.data.ngonNgu,
                                              'nhaPhatHanh':
                                                  snapshot.data.nhaPhatHanh,
                                              'nhaXuatBan':
                                                  snapshot.data.nhaXuatBan,
                                              'phanTramGiamGia': widget
                                                  .bookModel.phanTramGiamGia,
                                              'tacGia': snapshot.data.tacGia,
                                              'tenSach': snapshot.data.tenSach,
                                              'soLuongMua': 1,
                                              'soLuong': snapshot.data.soLuong,
                                            };
                                            _saveBookIntoCart(_book);
                                          },
                                          child: Container(
                                            height: 40.0,
                                            width: 350.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.yellow[700]),
                                            child: Center(
                                              child: new Text(
                                                  'THÊM VÀO GIỎ HÀNG',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: 'RobotoSlab',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[800])),
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        pinned: true,
                        floating: true,
                        forceElevated: boxIsScrolled,
                        bottom: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: new BubbleTabIndicator(
                            indicatorHeight: 30.0,
                            indicatorColor: Colors.amber[700],
                            tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          ),
                          unselectedLabelColor: Colors.amber[800],
                          labelColor: Colors.white,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.normal),
                          tabs: [
                            Tab(
                                child: new Text('Thông Tin',
                                    style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        fontSize: 15.0))),
                            Tab(
                                child: new Text('Giới Thiệu',
                                    style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        fontSize: 15.0))),
                            Tab(
                                child: new Text('Bình Luận',
                                    style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        fontSize: 15.0))),
                          ],
                          controller: _tabController,
                        ),
                      )
                    ];
                  },
                  body: TabBarView(children: [
                    InfoBook(
                        tacGia: snapshot.data.tacGia,
                        nhaXuatBan: snapshot.data.nhaXuatBan,
                        maSP: snapshot.data.maSP,
                        nhaPhatHanh: snapshot.data.nhaPhatHanh,
                        khoiLuong: snapshot.data.khoiLuong,
                        kichThuoc: snapshot.data.kichThuoc,
                        ngonNgu: snapshot.data.ngonNgu,
                        nguoiDich: snapshot.data.nguoiDich,
                        dinhDang: snapshot.data.dinhDang,
                        soTrang: snapshot.data.soTrang),
                    BookIntroduction(
                      gioiThieuSach: snapshot.data.gioiThieuSach,
                    ),
                    BookReviews(
                      documentCategory: snapshot.data.idDM,
                      documentBook: snapshot.data.tenSach,
                    )
                  ], controller: _tabController)),
              //TODO: Floating Action Button
              floatingActionButton: SpeedDial(
                // both default to 16
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                // this is ignored if animatedIcon is non null
                //child: Icon(Icons.add),
                //visible: _dialVisible,
                // If true user is forced to close dial manually
                // by tapping main button and overlay is not rendered.
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                onOpen: () => print('Mở FAB'),
                onClose: () => print('Đóng FAB'),
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  // SpeedDialChild(
                  //     child: Icon(Icons.add_shopping_cart),
                  //     backgroundColor: Colors.green,
                  //     label: 'Thêm vào giỏ hàng',
                  //     labelStyle: TextStyle(
                  //         fontFamily: 'RobotoSlab',
                  //         fontSize: 18.0,
                  //         color: Colors.white),
                  //     labelBackgroundColor: Colors.green,
                  //     onTap: () => print('Đã Thêm vào giỏ hàng')),
                  SpeedDialChild(
                    child: Icon(Icons.favorite),
                    backgroundColor: Colors.red,
                    label: 'Thêm vào yêu thích',
                    labelStyle: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 18.0,
                        color: Colors.white),
                    labelBackgroundColor: Colors.red,
                    onTap: () async {
                      String userName = await _getUserEmail();
                      print("Username's value: ${userName}");
                      if (userName == "") {
                        showToast(
                            "Bạn cần đăng nhập để thêm sách vào yêu thích");
                      } else {
                        Firestore.instance
                            .collection('UserCollection')
                            .document(userName)
                            .collection('FavoriteBookCollection')
                            .document(snapshot.data.tenSach)
                            .setData(snapshot.data.toJson());
                        showToast('Đã thêm sách vào yêu thích');
                        print('Đã Thêm vào yêu thích');
                      }
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.chat),
                    backgroundColor: Colors.blue,
                    label: 'Đánh giá sách',
                    labelStyle: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 18.0,
                        color: Colors.white),
                    labelBackgroundColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentAndRate(
                            documentCategory: snapshot.data.idDM,
                            documentBook: snapshot.data.tenSach,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          });
    } else {
      return new Scaffold(
          body: Center(
        child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber[800])),
      ));
    }
  }
}
