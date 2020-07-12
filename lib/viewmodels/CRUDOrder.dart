import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/orderModel.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDOrder extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api;
  final String document;
  List<OrderModel> bookModels;
  CollectionReference reference;
  CRUDOrder(this.document) {
    CollectionReference reference = _db
        .collection('UserCollection')
        .document(this.document)
        .collection('OrderCollection');
    this.reference = reference;
    this._api = Api.subcollection(reference, '');
  }
  OrderModel orderModel;

  List<OrderModel> orderModels;

  Future<List<OrderModel>> fetchorderModels() async {
    var result = await _api.getDataCollection();
    orderModels =
        result.documents.map((doc) => OrderModel.fromMap(doc.data)).toList();
    return orderModels;
  }

  Stream<QuerySnapshot> fetchorderModelsAsStream() {
    return _api.streamDataCollection();
  }

  Stream<DocumentSnapshot> fetchOneOrderModelAsStream(String id) {
    return _api.streamDataDocumnet(id);
  }

  Future<OrderModel> getOrderModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    if (doc.exists) {
      return OrderModel.fromMap(doc.data);
    }
    return null;
  }

  Future removeOrderModel(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateOrderModel(String id,
      {OrderModel data, fieldName, fieldValue}) async {
    if (fieldName == null && fieldValue == null) {
      await _api.updateDocument(data.toJson(), id);
    } else {
      await _api.updateOneField(id, fieldName, fieldValue);
    }
    return;
  }

  Future addOrderModel(OrderModel data, String id) async {
    await _api.addDocument(data.toJson(), id);
    return;
  }
}
