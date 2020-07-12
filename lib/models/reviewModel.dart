import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Review {
  String idReview;
  String urlHinhDaiDien;
  String hoTen;
  String noiDungBinhLuan;
  String email;
  String thoiGianReview;
  double saoDanhGia;

  Review(
      {@required this.idReview,
      @required this.urlHinhDaiDien,
      @required this.hoTen,
      @required this.noiDungBinhLuan,
      @required this.email,
      @required this.thoiGianReview,
      @required this.saoDanhGia});

  Review.fromMap(Map<String, dynamic> data)
      : this(
          idReview: data['idReview'],
          urlHinhDaiDien: data['urlHinhDaiDien'],
          hoTen: data['hoTen'],
          noiDungBinhLuan: data['noiDungBinhLuan'],
          email: data['email'],
          thoiGianReview: data['thoiGianReview'],
          saoDanhGia: data['saoDanhGia'],
        );

  toJson() {
    return {
      'idReview': this.idReview,
      'urlHinhDaiDien': this.urlHinhDaiDien,
      'hoTen': this.hoTen,
      'noiDungBinhLuan': this.noiDungBinhLuan,
      'email': email,
      'thoiGianReview': this.thoiGianReview,
      'saoDanhGia': this.saoDanhGia,
    };
  }
}
