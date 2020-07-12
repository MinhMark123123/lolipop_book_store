import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/notificationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDNotification extends ChangeNotifier {
  Api _api = Api('NotificationsCollection');

  List<NotificationModel> NotificationModels;

  Future<List<NotificationModel>> fetchNotificationModels() async {
    var result = await _api.getDataCollection();
    NotificationModels = result.documents
        .map((doc) => NotificationModel.fromMap(doc.data))
        .toList();
    return NotificationModels;
  }

  Stream<QuerySnapshot> fetchNotificationModelsAsStream() {
    return _api.streamDataCollection();
  }

  // Stream<DocumentSnapshot> fetchOneNotificationModelAsStream(String id) {
  //   return _api.streamDataDocumnet(id);
  // }

  // Future<NotificationModel> getNotificationModelById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   if (doc.exists) {
  //     return NotificationModel.fromMap(doc.data);
  //   }
  //   return null;
  // }

  // Future removeNotificationModel(String id) async {
  //   await _api.removeDocument(id);
  //   return;
  // }

  // Future updateNotificationModel(String id,
  //     {NotificationModel data, fieldName, fieldValue}) async {
  //   if (fieldName == null && fieldValue == null) {
  //     await _api.updateDocument(data.toJson(), id);
  //   } else {
  //     await _api.updateOneField(id, fieldName, fieldValue);
  //   }
  //   return;
  // }

  // Future addNotificationModel(NotificationModel data, String id) async {
  //   await _api.addDocument(data.toJson(), id);
  //   return;
  // }
}
