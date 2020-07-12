import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/screens/more_book/Widgets/item_list_book.dart';
import 'package:lolipop_book_store/screens/more_book/Widgets/loading_skeleton.dart';
import 'package:lolipop_book_store/screens/book_detail/book_detail.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';

class MoreBook extends StatelessWidget {
  // Declare a field that holds the Todo.
  final String itemHolder;
  MoreBook({Key key, @required this.itemHolder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CRUDBook crudBook = new CRUDBook(this.itemHolder);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: new StreamBuilder(
            stream: Firestore.instance
                .collection('DanhMucCollection')
                .document(itemHolder)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Text("Loading");
              }
              var nameDocument = snapshot.data;
              return new Text(nameDocument["tenDM"],
                  style: TextStyle(fontFamily: 'RobotoSlab'));
            }),
        backgroundColor: Colors.amber[700],
      ),
      body: new StreamBuilder(
        stream: crudBook.fetchBooksAsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return new Container(
              child: new LoadingSkeleton(),
            );
          return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  title: new ItemListBook(
                      titleBook: snapshot.data.documents[index]['tenSach'],
                      urlImage: snapshot.data.documents[index]['biaSach'],
                      author: snapshot.data.documents[index]['tacGia'],
                      nhaXB: snapshot.data.documents[index]['nhaXuatBan']),
                  onTap: () {
                    print('Document: ${snapshot.data.documents[index].data}');
                    BookModel _book =
                        BookModel.fromMap(snapshot.data.documents[index].data);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetails(
                          //Gửi dữ liệu
                          bookModel: _book,
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
