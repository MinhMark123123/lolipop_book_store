import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/screens/more_book/more_book.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: new CategoryList());
  }
}

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getItemAndNavigate(String item, BuildContext context) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MoreBook(itemHolder: item)));
    }

    return new StreamBuilder(
      stream: Firestore.instance.collection('DanhMucCollection').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return new Container(
            child: new Center(
              child: new Text('loading ....'),
            ),
          );
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return Container(
                color: Colors.amber[400],
                child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: new ListTile(
                          title: new Text(document['tenDM'],
                              style: TextStyle(fontFamily: 'RobotoSlab')),
                          onTap: () {
                            getItemAndNavigate(document['idDM'], context);
                          },
                        ),
                      ),
                    ]));
          }).toList(),
        );
      },
    );
  }
}
