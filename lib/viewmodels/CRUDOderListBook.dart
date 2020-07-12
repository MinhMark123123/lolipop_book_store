import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/services/api.dart';

class CRUDOderListBook extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api;
  final String documentUser, documentOrderDetail;
  List<BookModel> bookModels;
  CollectionReference reference;
  CRUDOderListBook(this.documentUser, this.documentOrderDetail) {
    CollectionReference reference = _db
        .collection('UserCollection')
        .document(this.documentUser)
        .collection('OrderCollection')
        .document(this.documentOrderDetail)
        .collection('BoughtBooksCollection');
    this.reference = reference;
    this._api = Api.subcollection(reference, '');
  }
  BookModel bookModel;

  Future<List<BookModel>> fetchBooks() async {
    var result = await _api.getDataCollection();
    bookModels =
        result.documents.map((doc) => BookModel.fromMap(doc.data)).toList();
    return bookModels;
  }
}
