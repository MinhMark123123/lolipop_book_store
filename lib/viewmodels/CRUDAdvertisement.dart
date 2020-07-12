import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lolipop_book_store/models/advertisement.dart';

class CRUDAdvertisement extends ChangeNotifier {
  Api _api = Api('Advertisement');

  List<Advertisement> Advertisements;

  Future<List<Advertisement>> fetchAdvertisements() async {
    var result = await _api.getDataCollection();
    Advertisements =
        result.documents.map((doc) => Advertisement.fromMap(doc.data)).toList();
    return Advertisements;
  }

  Stream<QuerySnapshot> fetchAdvertisementsAsStream() {
    return _api.streamDataCollection();
  }

  // Stream<DocumentSnapshot> fetchOneAdvertisementAsStream(String id) {
  //   return _api.streamDataDocumnet(id);
  // }

  // Future<Advertisement> getAdvertisementById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   if (doc.exists) {
  //     return Advertisement.fromMap(doc.data);
  //   }
  //   return null;
  // }

  // Future removeAdvertisement(String id) async {
  //   await _api.removeDocument(id);
  //   return;
  // }

  // Future updateAdvertisement(String id,
  //     {Advertisement data, fieldName, fieldValue}) async {
  //   if (fieldName == null && fieldValue == null) {
  //     await _api.updateDocument(data.toJson(), id);
  //   } else {
  //     await _api.updateOneField(id, fieldName, fieldValue);
  //   }
  //   return;
  // }

  // Future addAdvertisement(Advertisement data, String id) async {
  //   await _api.addDocument(data.toJson(), id);
  //   return;
  // }
}
