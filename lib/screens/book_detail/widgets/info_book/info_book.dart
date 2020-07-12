import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/screens/book_detail/widgets/info_book/item_info_book.dart';

class InfoBook extends StatelessWidget {
  final String tacGia;
  final String nhaXuatBan;
  final String maSP;
  final String nhaPhatHanh;
  final String khoiLuong;
  final String kichThuoc;
  final String ngonNgu;
  final String nguoiDich;
  final String dinhDang;
  final int soTrang;

  InfoBook(
      {Key key,
      @required this.tacGia,
      @required this.nhaXuatBan,
      @required this.maSP,
      @required this.nhaPhatHanh,
      @required this.khoiLuong,
      @required this.kichThuoc,
      @required this.ngonNgu,
      @required this.nguoiDich,
      @required this.dinhDang,
      @required this.soTrang})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: new Container(
          color: Colors.white,
          margin: EdgeInsets.only(left: 10.0, top: 10.0),
          child: Column(
            children: <Widget>[
              ItemInfoBook(
                title: 'Tác giả',
                value: tacGia,
              ),
              ItemInfoBook(
                title: 'Nhà xuất bản',
                value: nhaXuatBan,
              ),
              ItemInfoBook(
                title: 'Mã sản phẩm',
                value: maSP,
              ),
              ItemInfoBook(
                title: 'Nhà phát hành',
                value: nhaPhatHanh,
              ),
              ItemInfoBook(
                title: 'Khối lượng',
                value: khoiLuong,
              ),
              ItemInfoBook(
                title: 'Kích thước',
                value: kichThuoc,
              ),
              ItemInfoBook(
                title: 'Ngôn ngữ',
                value: ngonNgu,
              ),
              ItemInfoBook(
                title: 'Người Dịch',
                value: nguoiDich,
              ),
              ItemInfoBook(
                title: 'Định dạng',
                value: dinhDang,
              ),
              // ItemInfoBook(
              //   title: 'Ngày phát hành',
              //   value: 'Chua lam',
              // ),
              ItemInfoBook(
                title: 'Số trang',
                value: soTrang.toString(),
              ),
            ],
          )),
    ));
  }
}
