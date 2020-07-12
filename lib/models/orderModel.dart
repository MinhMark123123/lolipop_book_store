import 'package:flutter/material.dart';

class OrderModel {
  final String maDonHang;
  final String ngayDatHang;
  final String phuongThucThanhToan;
  final String trangThai;
  final String tenNguoiMua;
  final double tongTien;
  final double giamGia;
  final String maGiamGia;
  final String diaChiGiaoHang;
  final String soDienThoai;
  final String ghiChu;
  final int soLuongMua;
  final double tamTinh;

  const OrderModel({
    this.maDonHang,
    this.ngayDatHang,
    this.phuongThucThanhToan,
    this.trangThai,
    this.giamGia,
    this.tenNguoiMua,
    this.tongTien,
    this.maGiamGia,
    this.diaChiGiaoHang,
    this.soDienThoai,
    this.ghiChu,
    this.soLuongMua,
    this.tamTinh,
  });

  OrderModel.fromMap(Map<String, dynamic> data)
      : this(
          maDonHang: data['maDonHang'],
          ngayDatHang: data['ngayDatHang'],
          phuongThucThanhToan: data['phuongThucThanhToan'],
          trangThai: data['trangThai'],
          giamGia: data['giamGia'],
          tenNguoiMua: data['tenNguoiMua'],
          tongTien: data['tongTien'],
          maGiamGia: data['maGiamGia'],
          diaChiGiaoHang: data['diaChiGiaoHang'],
          soDienThoai: data['soDienThoai'],
          ghiChu: data['ghiChu'],
          soLuongMua: data['soLuongMua'],
          tamTinh: data['tamTinh'],
        );

  toJson() {
    return {
      'maDonHang': this.maDonHang,
      'ngayDatHang': this.ngayDatHang,
      'phuongThucThanhToan': this.phuongThucThanhToan,
      'trangThai': this.trangThai,
      'giamGia': this.giamGia,
      'tenNguoiMua': this.tenNguoiMua,
      'tongTien': this.tongTien,
      'maGiamGia': this.maGiamGia,
      'diaChiGiaoHang': this.diaChiGiaoHang,
      'soDienThoai': this.soDienThoai,
      'ghiChu': this.ghiChu,
      'soLuongMua': this.soLuongMua,
      'tamTinh': this.tamTinh,
    };
  }
}
