import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Api {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }
  Api.subcollection(CollectionReference ref, this.path) {
    this.ref = ref;
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Stream<DocumentSnapshot> streamDataDocumnet(String id) {
    return ref.document(id).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<void> addDocument(Map data, String id) {
    return ref.document(id).setData(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }

  Future<void> updateOneField(String id, String name, dynamic value) {
    return ref.document(id).updateData({name: value});
  }

  Future<bool> checkDocExist(String field, String value) async {
    var result = await ref.where('field', isEqualTo: value).getDocuments();
    if (result == null) {
      return false;
    }
    return true;
  }
}
