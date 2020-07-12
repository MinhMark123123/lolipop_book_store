import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/screens/book_detail/widgets/book_reviews/book_reviews.dart';
import '../services/api.dart';
import '../models/reviewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/models/reviewModel.dart';

class CRUDBookReview extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api;
  final String documentCategory, documentBook;
  CollectionReference reference;

  CRUDBookReview(this.documentCategory, this.documentBook) {
    CollectionReference reference = _db
        .collection('DanhMucCollection')
        .document(documentCategory)
        .collection("SachCollection")
        .document(documentBook)
        .collection("ReviewCollection");
    this.reference = reference;
    this._api = Api.subcollection(reference, '');
  }

  List<Review> bookReviews;

  Future<List<Review>> fetchPromoCodeModels() async {
    var result = await _api.getDataCollection();
    bookReviews =
        result.documents.map((doc) => Review.fromMap(doc.data)).toList();
    return bookReviews;
  }

  Future addReview(Review data, String idReview) async {
    await _api.addDocument(data.toJson(), idReview);
    return;
  }

  Future<Review> getReviewBookById(String id) async {
    var doc = await _api.getDocumentById(id);
    if (doc.exists)
      return Review.fromMap(doc.data);
    else
      return null;
  }

  Future updateBookReview(Review data, String idReview) async {
    await _api.updateDocument(data.toJson(), idReview);
    return;
  }
}
