import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/models/bookModel.dart';

class CRUDBookFavorite extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api;
  final String document;
  List<BookModel> bookModels;
  CollectionReference reference;
  CRUDBookFavorite(this.document) {
    CollectionReference reference = _db
        .collection('UserCollection')
        .document(this.document)
        .collection('FavoriteBookCollection');
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

  Future<List<BookModel>> fetchBooks() async {
    var result = await _api.getDataCollection();
    bookModels =
        result.documents.map((doc) => BookModel.fromMap(doc.data)).toList();
    return bookModels;
  }

  Stream<QuerySnapshot> fetchBooksAsStream() {
    return _api.streamDataCollection();
  }

  Future updateBook(BookModel data, String idBook) async {
    await _api.updateDocument(data.toJson(), idBook);
    return;
  }

  Future deleteBook(String id) async {
    await _api.removeDocument(id);
    return;
  }
}
