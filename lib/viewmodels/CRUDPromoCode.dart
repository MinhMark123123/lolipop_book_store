import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/promocodeModel.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDPromoCode extends ChangeNotifier {
  static Firestore _db = Firestore.instance;
  Api _api;
  final String document;
  //List<PromoCodeModel> promocodeModel; //?
  CollectionReference reference;
  CRUDPromoCode(this.document) {
    CollectionReference reference = _db
        .collection('UserCollection')
        .document(this.document)
        .collection('PromotionalCodeCollection');
    this.reference = reference;
    this._api = Api.subcollection(reference, '');
  }
  PromoCodeModel promocodeModel;

  List<PromoCodeModel> promocodeModels;
  Future<bool> checkIfPromoCodeExist(String value) async {
    var result = await _api.getDocumentById(value);
    if (result.exists) {
      return true;
    }
    return false;
  }

  Future<List<PromoCodeModel>> fetchPromoCodeModels() async {
    var result = await _api.getDataCollection();
    promocodeModels = result.documents
        .map((doc) => PromoCodeModel.fromMap(doc.data))
        .toList();
    return promocodeModels;
  }

  Stream<QuerySnapshot> fetchPromoCodeModelsAsStream() {
    return _api.streamDataCollection();
  }

  Stream<DocumentSnapshot> fetchOnePromoCodeModelAsStream(String id) {
    return _api.streamDataDocumnet(id);
  }

  Future<PromoCodeModel> getPromoCodeModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    if (doc.exists) {
      return PromoCodeModel.fromMap(doc.data);
    }
    return null;
  }

  Future removePromoCodeModel(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updatePromoCodeModel(String id,
      {PromoCodeModel data, fieldName, fieldValue}) async {
    if (fieldName == null && fieldValue == null) {
      await _api.updateDocument(data.toJson(), id);
    } else {
      await _api.updateOneField(id, fieldName, fieldValue);
    }
    return;
  }

  Future addpromocodeModel(PromoCodeModel data, String id) async {
    await _api.addDocument(data.toJson(), id);
    return;
  }
}
