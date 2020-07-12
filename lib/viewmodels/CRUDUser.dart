import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDUser extends ChangeNotifier {
  Api _api = Api('UserCollection');

  List<User> users;

  Future<List<User>> fetchUsers() async {
    var result = await _api.getDataCollection();
    users = result.documents.map((doc) => User.fromMap(doc.data)).toList();
    return users;
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

  Stream<DocumentSnapshot> fetchOneUserAsStream(String id) {
    return _api.streamDataDocumnet(id);
  }

  Future<User> getUserById(String id) async {
    var doc = await _api.getDocumentById(id);
    if (doc.exists) {
      return User.fromMap(doc.data);
    }
    return null;
  }

  Future removeUser(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateUser(String id, {User data, fieldName, fieldValue}) async {
    if (fieldName == null && fieldValue == null) {
      await _api.updateDocument(data.toJson(), id);
    } else {
      await _api.updateOneField(id, fieldName, fieldValue);
    }
    return;
  }

  Future addUser(User data, String id) async {
    await _api.addDocument(data.toJson(), id);
    return;
  }
}
