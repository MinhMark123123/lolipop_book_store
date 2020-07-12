import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lolipop_book_store/screens/login/login.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBookReview.dart';
import 'package:lolipop_book_store/models/reviewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class CommentAndRate extends StatefulWidget {
  String documentCategory, documentBook;
  CommentAndRate(
      {Key key, @required this.documentCategory, @required this.documentBook})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentAndRateState();
  }
}

class CommentAndRateState extends State<CommentAndRate> {
  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString('userEmail');

    if (_userEmail != null) {
      print('User email: ' + _userEmail);

      return _userEmail;
    } else
      return '';
  }

  //TODO:  Chuyển datetime sang timestamp
  String currentPhoneDate =
      DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    CRUDBookReview crudBookReview =
        new CRUDBookReview(widget.documentCategory, widget.documentBook);
    CRUDBook crudBook = new CRUDBook(widget.documentCategory);

    String content;
    double _rating = 4;
    String textRate = "Hay";
    var textRatingController = new TextEditingController();
    final TextEditingController _multilineTextController =
        new TextEditingController();

    addReview(idReview, urlHinhDaiDien, hoTen, noiDungBinhLuan, email, rating,
        thoiGianReview) async {
      await crudBookReview.getReviewBookById(widget.documentBook).catchError(
          await crudBookReview.addReview(
              Review(
                  urlHinhDaiDien: urlHinhDaiDien,
                  hoTen: hoTen,
                  idReview: idReview,
                  noiDungBinhLuan: noiDungBinhLuan,
                  email: email,
                  saoDanhGia: rating,
                  thoiGianReview: thoiGianReview),
              idReview.trim()));
    }

    updateReview(idReview, noiDungBinhLuan, rating) async {
      await crudBookReview
          .getReviewBookById(idReview)
          .then(await crudBookReview.updateBookReview(
              Review(
                noiDungBinhLuan: noiDungBinhLuan,
                saoDanhGia: rating,
              ),
              idReview.trim()));
    }

    // Future<void> updateBook(titleBook, soSao) async {
    //   BookModel book = crudBook.getBookByTitleBook(titleBook) as BookModel;
    //   await crudBook.getBookByTitleBook(titleBook).whenComplete(
    //       await crudBook.updateBook(
    //           BookModel(
    //               biaSach: book.biaSach,
    //               dinhDang: book.dinhDang,
    //               giaTien: book.giaTien,
    //               giaTienDaGiam: book.giaTienDaGiam,
    //               gioiThieuSach: book.gioiThieuSach,
    //               idDM: book.idDM,
    //               khoiLuong: book.khoiLuong,
    //               kichThuoc: book.kichThuoc,
    //               maSP: book.maSP,
    //               ngayPhatHanh: book.ngayPhatHanh,
    //               ngonNgu: book.ngonNgu,
    //               nguoiDich: book.nguoiDich,
    //               nhaPhatHanh: book.nhaPhatHanh,
    //               nhaXuatBan: book.nhaXuatBan,
    //               phanTramGiamGia: book.phanTramGiamGia,
    //               soLuong: book.soLuong,
    //               soTrang: book.soTrang,
    //               tacGia: book.tacGia,
    //               tenSach: book.tenSach,
    //               trangThai: book.trangThai,
    //               danhGia: book.danhGia + _rating.toInt(),
    //               luotDanhGia: book.luotDanhGia + 1),
    //           titleBook));
    // }

    getReviewbyID(titleBook) async {
      await crudBookReview.getReviewBookById(titleBook);
    }

    String returnValueRate(double rating) {
      if (rating == 1)
        return "Quá tệ";
      else if (rating == 2)
        return "Tệ";
      else if (rating == 3)
        return "Bình thường";
      else if (rating == 4)
        return "Hay";
      else if (rating == 5) return "Rất hay";
    }

    CRUDUser crudUser = new CRUDUser();
    // TODO: implement build
    return FutureBuilder(
        future: _getUserEmail(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
              stream: crudUser.fetchOneUserAsStream(snapshot.data),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshotStream) {
                if (snapshotStream.hasData) {
                  return new KeyboardDismisser(
                    child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.amber[700],
                          leading: new IconButton(
                            icon: new Icon(
                              Icons.arrow_back,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          title: new Text(widget.documentBook),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //TODO: Đăng tải đánh giá
                                // Nếu đánh giá đã được đăng tải trước đó
                                if (crudBookReview.getReviewBookById(
                                        widget.documentBook +
                                            snapshotStream.data['email']) ==
                                    null) {
                                  updateReview(
                                      widget.documentBook +
                                          snapshotStream.data['email'],
                                      content,
                                      _rating);
                                  print('VA: RATINGGGGGG: ${_rating}');
                                }
                                // Nếu người dùng chưa đánh giá sách này
                                else {
                                  print(
                                      '${crudBookReview.getReviewBookById(widget.documentBook + snapshotStream.data['userName'])}');
                                  addReview(
                                      widget.documentBook +
                                          snapshotStream.data['email'],
                                      snapshotStream.data['imageURL'],
                                      snapshotStream.data['userName'],
                                      content,
                                      snapshotStream.data['email'],
                                      _rating,
                                      currentPhoneDate);
                                  //updateBook(widget.documentBook, _rating);
                                }
                                print(crudBookReview.getReviewBookById(
                                    widget.documentBook +
                                        snapshotStream.data['userName']));
                                print('$_rating, ${widget.documentBook}');
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: new Container(
                              margin: EdgeInsets.only(top: 10.0),
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  new Center(
                                      child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Cảm nhận của bạn về cuốn sách này',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontFamily: 'RobotoSlab'),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      RatingBar(
                                        initialRating: 4,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return Icon(
                                                Icons
                                                    .sentiment_very_dissatisfied,
                                                color: Colors.red,
                                              );
                                            case 1:
                                              return Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.redAccent,
                                              );
                                            case 2:
                                              return Icon(
                                                Icons.sentiment_neutral,
                                                color: Colors.amber,
                                              );
                                            case 3:
                                              return Icon(
                                                Icons.sentiment_satisfied,
                                                color: Colors.lightGreen,
                                              );
                                            case 4:
                                              return Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.green,
                                              );
                                          }
                                        },
                                        onRatingUpdate: (rating) {
                                          _rating = rating;
                                          textRatingController.text =
                                              returnValueRate(rating);
                                          print(textRate);
                                        },
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Center(
                                            child: TextField(
                                              controller: textRatingController,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Hay",
                                                hintStyle: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.black,
                                                    fontFamily: 'RobotoSlab'),
                                                border: InputBorder.none,
                                              ),
                                              enabled: false,
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontFamily: 'RobotoSlab'),
                                            ),
                                          )),
                                          Text("*"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      )
                                    ],
                                  )),
                                  new Column(
                                    children: <Widget>[
                                      new Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: new Text(
                                              'Ý kiến cá nhân:',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoSlab',
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                TextField(
                                                  controller:
                                                      _multilineTextController,
                                                  maxLines: 15,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Ý kiến cá nhân',
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              'RobotoSlab'),
                                                      border:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none)),
                                                  onChanged: (str) =>
                                                      content = str,
                                                  //onSubmitted: (str) => widget.content = str,
                                                  onTap: () =>
                                                      print('Tap tap tap'),
                                                ),
                                                SizedBox(height: 10.0),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              )),
                        )),
                  );
                } else {
                  return new Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.amber[700],
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    body: Container(
                      child: new Center(
                          child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            'Cần đăng nhập để thực hiện thao tác này',
                            style: TextStyle(
                                fontSize: 17.0, fontFamily: 'RobotoSlab'),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          new FlatButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: new Text(
                              'Đăng nhập',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontFamily: 'RobotoSlab'),
                            ),
                            color: Colors.amber,
                          ),
                          // new InkWell(
                          //   child: new Text('Quay lại'),
                          //   onTap: () => Navigator.of(context).pop(),
                          // )
                        ],
                      )),
                    ),
                  );
                }
              },
            );
          } else {
            return Container(
              height: 0.0,
              width: 0.0,
            );
          }
        });
  }
}
