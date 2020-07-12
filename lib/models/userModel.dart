import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String email;
  bool gioiTinh;
  String imageURL;
  String userName;
  String role;
  String ngaySinh;
  String soDienThoai;
  int soSachDaMua;
  String diaChi;
  String verification;
  User(
      {@required this.email,
      @required this.gioiTinh,
      @required this.imageURL,
      @required this.userName,
      @required this.role,
      @required this.ngaySinh,
      @required this.soDienThoai,
      @required this.soSachDaMua,
      @required this.diaChi,
      @required this.verification})
      : assert(email != null && email.isNotEmpty),
        assert(userName != null && userName.isNotEmpty);

  User.fromMap(Map<String, dynamic> data)
      : this(
            email: data['email'],
            gioiTinh: data['gioiTinh'],
            imageURL: data['imageURL'],
            userName: data['userName'],
            role: data['role'],
            ngaySinh: data['ngaySinh'],
            soDienThoai: data['soDienThoai'],
            soSachDaMua: data['soSachDaMua'],
            diaChi: data['diaChi'],
            verification: data['verification']);
  toJson() {
    return {
      'email': this.email,
      'gioiTinh': this.gioiTinh,
      'imageURL': this.imageURL,
      'userName': this.userName,
      'role': this.role,
      'ngaySinh': this.ngaySinh,
      'soDienThoai': this.soDienThoai,
      'soSachDaMua': this.soSachDaMua,
      'diaChi': this.diaChi,
      'verification': this.verification,
    };
  }
}
