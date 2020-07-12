import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/categoryModel.dart';
import 'package:lolipop_book_store/services/api.dart';

class CRUDCategory extends ChangeNotifier {
  List<Category> categories;
  Api _api = Api('DanhMucCollection');

  Future<List<Category>> fetchCategories() async {
    var result = await _api.getDataCollection();
    categories =
        result.documents.map((doc) => Category.fromMap(doc.data)).toList();
    return categories;
  }

  Stream<QuerySnapshot> fetchCategoriesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Category> getCategoryById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Category.fromMap(doc.data);
  }

  Future removeCategory(String id) async {
    var result = await _api.removeDocument(id);
    return;
  }

  Future updateCategory(String id, Category category) async {
    var result = await _api.updateDocument(category.toJson(), id);
    return;
  }

  Future addCategory(String id, Category category) async {
    var result = await _api.addDocument(category.toJson(), id);
    return;
  }
}
