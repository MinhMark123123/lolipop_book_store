import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/reviewModel.dart';
import 'package:lolipop_book_store/screens/book_detail/widgets/book_reviews/item_book_reviews.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBookReview.dart';

class BookReviews extends StatelessWidget {
  //CRUDBookReview crudBookReview = new CRUDBookReview(documentCategory, documentBook)
  String documentCategory, documentBook;
  BookReviews(
      {Key key, @required this.documentCategory, @required this.documentBook})
      : super(key: key);
  Review data;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('DanhMucCollection')
            .document(documentCategory)
            .collection("SachCollection")
            .document(documentBook)
            .collection("ReviewCollection")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.documents.length > 0) {
            return new ListView(
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data.documents.map((document) {
                return Container(
                    color: Colors.white,
                    child: ListView(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          new Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: new ListTile(
                              title: new ItemBookReview(
                                urlHinhDaiDien: document['urlHinhDaiDien'],
                                hoTenNguoiBinhLuan: document['hoTen'],
                                noiDungBinhLuan: document['noiDungBinhLuan'],
                                saoDanhGia: document['saoDanhGia'],
                              ),
                              onTap: () {
                                //getItemAndNavigate(document['idDM'], context);
                              },
                            ),
                          ),
                          Divider(color: Colors.amber[800])
                        ]));
              }).toList(),
            );
          } else {
            return new Container(
              child: new Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.chat,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  new Text(
                    'Không có bình luận về sách',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: 'RobotoSlab',
                        color: Colors.grey),
                  ),
                ],
              )),
            );
          }
        });
  }
}
