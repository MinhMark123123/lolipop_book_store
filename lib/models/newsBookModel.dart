import 'package:flutter/material.dart';

class NewsBookModel {
  final String tenNoiDung;
  final String noiDung;
  final String urlNoiDung;
  final String urlBiaSach;
  final String website;
  NewsBookModel(
      {this.tenNoiDung,
      this.noiDung,
      this.urlNoiDung,
      this.urlBiaSach,
      this.website});

  NewsBookModel.fromMap(Map<String, dynamic> data)
      : this(
          tenNoiDung: data['tenNoiDung'],
          noiDung: data['noiDung'],
          urlNoiDung: data['urlNoiDung'],
          urlBiaSach: data['urlBiaSach'],
          website: data['website'],
        );

  toJson() {
    return {
      'tenNoiDung': this.tenNoiDung,
      'noiDung': this.noiDung,
      'urlNoiDung': this.urlNoiDung,
      'urlBiaSach': this.urlBiaSach,
      'website': this.website,
    };
  }
}
