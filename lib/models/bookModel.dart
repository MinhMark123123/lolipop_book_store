import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String biaSach;
  final int danhGia;
  final String dinhDang;
  final int giaTien;
  final int giaTienDaGiam;
  final String gioiThieuSach;
  final String idDM;
  final String khoiLuong;
  final String kichThuoc;
  final int luotDanhGia;
  final String maSP;
  final Timestamp ngayPhatHanh;
  final String ngonNgu;
  final String nguoiDich;
  final String nhaPhatHanh;
  final String nhaXuatBan;
  final int phanTramGiamGia;
  final int soLuong;
  final int soTrang;
  final String tacGia;
  final bool trangThai;
  final String tenSach;

  const BookModel(
      {this.biaSach,
      this.danhGia,
      this.dinhDang,
      this.giaTien,
      this.giaTienDaGiam,
      this.gioiThieuSach,
      this.idDM,
      this.khoiLuong,
      this.kichThuoc,
      this.luotDanhGia,
      this.maSP,
      this.ngayPhatHanh,
      this.ngonNgu,
      this.nguoiDich,
      this.nhaPhatHanh,
      this.nhaXuatBan,
      this.phanTramGiamGia,
      this.soLuong,
      this.soTrang,
      this.tacGia,
      this.trangThai,
      this.tenSach});

  BookModel.fromMap(Map<String, dynamic> data)
      : this(
            biaSach: data['biaSach'],
            danhGia: data['danhGia'],
            dinhDang: data['dinhDang'],
            giaTien: data['giaTien'],
            giaTienDaGiam: data['giaTienDaGiam'],
            gioiThieuSach: data['gioiThieuSach'],
            idDM: data['idDM'],
            khoiLuong: data['khoiLuong'],
            kichThuoc: data['kichThuoc'],
            luotDanhGia: data['luotDanhGia'],
            maSP: data['maSP'],
            ngayPhatHanh: data['ngayPhatHanh'],
            ngonNgu: data['ngonNgu'],
            nguoiDich: data['nguoiDich'],
            nhaPhatHanh: data['nhaPhatHanh'],
            nhaXuatBan: data['nhaXuatBan'],
            phanTramGiamGia: data['phanTramGiamGia'],
            soLuong: data['soLuong'],
            soTrang: data['soTrang'],
            tacGia: data['tacGia'],
            trangThai: data['trangThai'],
            tenSach: data['tenSach']);

  toJson() {
    return {
      'biaSach': this.biaSach,
      'danhGia': this.danhGia,
      'dinhDang': this.dinhDang,
      'giaTien': this.giaTien,
      'giaTienDaGiam': this.giaTienDaGiam,
      'gioiThieuSach': this.gioiThieuSach,
      'idDM': this.idDM,
      'khoiLuong': this.khoiLuong,
      'kichThuoc': this.kichThuoc,
      'luotDanhGia': this.luotDanhGia,
      'maSP': this.maSP,
      'ngayPhatHanh': this.ngayPhatHanh,
      'ngonNgu': this.ngonNgu,
      'nguoiDich': this.nguoiDich,
      'nhaPhatHanh': this.nhaPhatHanh,
      'nhaXuatBan': this.nhaXuatBan,
      'phanTramGiamGia': this.phanTramGiamGia,
      'soLuong': this.soLuong,
      'soTrang': this.soTrang,
      'tacGia': this.tacGia,
      'trangThai': this.trangThai,
      'tenSach': this.tenSach
    };
  }
}
