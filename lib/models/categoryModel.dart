import 'package:flutter/material.dart';

class Category {
  String tenDM;
  String idDM;
  Category({@required this.tenDM, @required this.idDM})
      : assert(tenDM != null && tenDM != ''),
        assert(idDM != null && idDM != '');
  Category.fromMap(Map<String, dynamic> data)
      : this(tenDM: data['tenDM'], idDM: data['idDM']);
  toJson() {
    return {'tenDM': this.tenDM, 'idDM': this.idDM};
  }
}
