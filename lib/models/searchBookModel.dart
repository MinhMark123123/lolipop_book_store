import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBook {
  final String tenSach;
  final String biaSach;
  final String idDM;
  final String tenKhongDau;

  const SearchBook({this.tenSach, this.biaSach, this.idDM, this.tenKhongDau});

  SearchBook.fromMap(Map<String, dynamic> data)
      : this(
            tenSach: data['tenSach'],
            biaSach: data['biaSach'],
            idDM: data['idDM'],
            tenKhongDau: data['tenKhongDau']);

  toJson() {
    return {
      'tenSach': this.tenSach,
      'biaSach': this.biaSach,
      'idDM': this.idDM,
      'tenKhongDau': this.tenKhongDau
    };
  }
}
