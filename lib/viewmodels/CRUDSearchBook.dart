import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/searchBookModel.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDSearchBook extends ChangeNotifier {
  Api _api = Api('SearchCollection');

  List<SearchBook> searchBooks;

  Future<List<SearchBook>> fetchsearchBooks() async {
    var result = await _api.getDataCollection();
    searchBooks =
        result.documents.map((doc) => SearchBook.fromMap(doc.data)).toList();
    return searchBooks;
  }

  Stream<QuerySnapshot> fetchsearchBooksAsStream() {
    return _api.streamDataCollection();
  }

  Stream<DocumentSnapshot> fetchOneSearchBookAsStream(String id) {
    return _api.streamDataDocumnet(id);
  }

  Future<SearchBook> getSearchBookById(String id) async {
    var doc = await _api.getDocumentById(id);
    if (doc.exists) {
      return SearchBook.fromMap(doc.data);
    }
    return null;
  }

  Future removeSearchBook(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateSearchBook(String id,
      {SearchBook data, fieldName, fieldValue}) async {
    if (fieldName == null && fieldValue == null) {
      await _api.updateDocument(data.toJson(), id);
    } else {
      await _api.updateOneField(id, fieldName, fieldValue);
    }
    return;
  }

  Future addSearchBook(SearchBook data, String id) async {
    await _api.addDocument(data.toJson(), id);
    return;
  }
}
