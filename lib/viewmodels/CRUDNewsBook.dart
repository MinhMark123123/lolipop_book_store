import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/newsBookModel.dart';
import 'package:lolipop_book_store/services/api.dart';

class CRUDNewsBook extends ChangeNotifier {
  List<NewsBookModel> newsBooks;
  Api _api = Api('SuggestionBookCollection');

  Future<List<NewsBookModel>> fetchNewsBooks() async {
    var result = await _api.getDataCollection();
    newsBooks =
        result.documents.map((doc) => NewsBookModel.fromMap(doc.data)).toList();
    return newsBooks;
  }

  Stream<QuerySnapshot> fetchNewsBooksAsStream() {
    return _api.streamDataCollection();
  }

  // Future<NewsBookModel> getNewsBookById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   return NewsBookModel.fromMap(doc.data);
  // }

  // Future removeNewsBook(String id) async {
  //   var result = await _api.removeDocument(id);
  //   return;
  // }

  // Future updateNewsBooks(String id, NewsBookModel newsBooks) async {
  //   var result = await _api.updateDocument(newsBooks.toJson(), id);
  //   return;
  // }

  // Future addnewsBooks(String id, NewsBookModel newsBooks) async {
  //   var result = await _api.addDocument(newsBooks.toJson(), id);
  //   return;
  // }
}
