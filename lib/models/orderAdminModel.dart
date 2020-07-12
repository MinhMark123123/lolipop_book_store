import 'package:flutter/material.dart';

class OrderAdminModel {
  final String idOrder;
  final String idUser;

  const OrderAdminModel({this.idOrder, this.idUser});

  OrderAdminModel.fromMap(Map<String, dynamic> data)
      : this(idOrder: data['idOrder'], idUser: data['idUser']);

  toJson() {
    return {'idOrder': this.idOrder, 'idUser': this.idUser};
  }
}
