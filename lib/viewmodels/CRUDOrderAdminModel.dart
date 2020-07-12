import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/orderAdminModel.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDOrderAdmin extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api = Api('OrderAdminCollection');

  List<OrderAdminModel> bookModels;

  OrderAdminModel orderAdminModel;

  List<OrderAdminModel> orderAdminModels;

  Future<List<OrderAdminModel>> fetchOrderAdminModels() async {
    var result = await _api.getDataCollection();
    orderAdminModels = result.documents
        .map((doc) => OrderAdminModel.fromMap(doc.data))
        .toList();
    return orderAdminModels;
  }

  Stream<QuerySnapshot> fetchOrderAdminModelsAsStream() {
    return _api.streamDataCollection();
  }

  Stream<DocumentSnapshot> fetchOneOrderAdminModelAsStream(String id) {
    return _api.streamDataDocumnet(id);
  }

  Future<OrderAdminModel> getOrderAdminModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    if (doc.exists) {
      return OrderAdminModel.fromMap(doc.data);
    }
    return null;
  }

  Future removeOrderAdminModel(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateOrderAdminModel(String id,
      {OrderAdminModel data, fieldName, fieldValue}) async {
    if (fieldName == null && fieldValue == null) {
      await _api.updateDocument(data.toJson(), id);
    } else {
      await _api.updateOneField(id, fieldName, fieldValue);
    }
    return;
  }

  Future addOrderAdminModel(OrderAdminModel data, String id) async {
    await _api.addDocument(data.toJson(), id);
    return;
  }
}
