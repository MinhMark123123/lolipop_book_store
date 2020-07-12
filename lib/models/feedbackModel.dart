import 'package:flutter/material.dart';

class FeedbackModel {
  final String noiDungPhanHoi;
  final String emailNguoiDung;
  final String thoiGianPhanHoi;

  FeedbackModel(
      {this.emailNguoiDung, this.noiDungPhanHoi, this.thoiGianPhanHoi});

  FeedbackModel.fromMap(Map<String, dynamic> data)
      : this(
          emailNguoiDung: data['emailNguoiDung'],
          noiDungPhanHoi: data['noiDungPhanHoi'],
          thoiGianPhanHoi: data['thoiGianPhanHoi'],
        );

  toJson() {
    return {
      'emailNguoiDung': this.emailNguoiDung,
      'noiDungPhanHoi': this.noiDungPhanHoi,
      'thoiGianPhanHoi': this.thoiGianPhanHoi,
    };
  }
}
