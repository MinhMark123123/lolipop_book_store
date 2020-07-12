import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/models/bookModel.dart';

class CRUDBook extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api;
  final String document;
  List<BookModel> bookModels;
  CollectionReference reference;
  CRUDBook(this.document) {
    CollectionReference reference = _db
        .collection('DanhMucCollection')
        .document(this.document)
        .collection('SachCollection');
    this.reference = reference;
    this._api = Api.subcollection(reference, '');
  }
  BookModel bookModel;

  Future<BookModel> getBookByTitleBook(String titleBook) async {
    var doc = await _api.getDocumentById(titleBook);
    if (doc.exists)
      return BookModel.fromMap(doc.data);
    else
      return null;
  }

  // Future<List<BookModel>> fetchBooks() async {
  //   var result = await _api.getDataCollection();
  //   bookModels =
  //       result.documents.map((doc) => BookModel.fromMap(doc.data)).toList();
  //   return bookModels;
  // }

  Stream<QuerySnapshot> fetchBooksAsStream() {
    return _api.streamDataCollection();
  }

  Future updateBook(String id, {BookModel data, fieldName, fieldValue}) async {
    if (fieldName == null && fieldValue == null) {
      await _api.updateDocument(data.toJson(), id);
    } else {
      await _api.updateOneField(id, fieldName, fieldValue);
    }
    return;
  }
}
