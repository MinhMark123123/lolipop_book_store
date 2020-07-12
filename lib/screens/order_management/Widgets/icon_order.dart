import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';

IconButton iconOrder(
    String trangThai, String email, String docOrder, BuildContext context) {
  if (trangThai == 'Đã tiếp nhận')
    return IconButton(
      icon: Icon(
        Icons.delete,
      ),
      onPressed: () {
        showAlertDialog(context, email, docOrder);
      },
    );
  else if (trangThai == 'Đang xử lý') {
    return IconButton(
        icon: Icon(
          Icons.timer,
          color: Colors.orange,
        ),
        onPressed: () {});
  } else if (trangThai == 'Đang vận chuyển') {
    return IconButton(
        icon: Icon(
          Icons.airport_shuttle,
          color: Colors.black,
        ),
        onPressed: () {});
  } else if (trangThai == 'Đã giao')
    return IconButton(
        icon: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        onPressed: () {});
  else if (trangThai == 'Đã huỷ')
    return IconButton(
        icon: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onPressed: null);
}

Future<BookModel> getBookInfo(String idBook, String idDM) async {
  CRUDBook crudBook = new CRUDBook(idDM);
  BookModel book = await crudBook.getBookByTitleBook(idBook);
  return book;
}

showAlertDialog(BuildContext context, String email, String docOrder) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Không"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Đồng ý"),
    onPressed: () async {
      await Firestore.instance
          .collection('UserCollection')
          .document(email)
          .collection('OrderCollection')
          .document(docOrder)
          .updateData({'trangThai': 'Đã huỷ'});
      //TODO: Khi khách hàng đồng ý huỷ đơn hàng thì sẽ cập nhật lại số sách cho kho
      Firestore.instance
          .collection('UserCollection')
          .document(email)
          .collection('OrderCollection')
          .document(docOrder)
          .collection('BoughtBooksCollection')
          .getDocuments()
          .then((value) {
        print('Độ dài: ${value.documents.length}');
        for (int i = 0; i < value.documents.length; i++) {
          print('Phần tử chạy: ${i}');
          print(value.documents[i].data['tenSach']);
          print(value.documents[i].data['idDM']);
          FutureBuilder(
              future: getBookInfo(value.documents[i].data["tenSach"],
                  value.documents[i].data["idDM"]),
              builder:
                  (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
                print('${snapshot.data.tenSach}');
                BookModel book = new BookModel(
                  biaSach: snapshot.data.biaSach,
                  danhGia: snapshot.data.danhGia,
                  dinhDang: snapshot.data.dinhDang,
                  giaTien: snapshot.data.giaTien,
                  giaTienDaGiam: snapshot.data.giaTienDaGiam,
                  gioiThieuSach: snapshot.data.gioiThieuSach,
                  idDM: snapshot.data.idDM,
                  khoiLuong: snapshot.data.khoiLuong,
                  kichThuoc: snapshot.data.kichThuoc,
                  luotDanhGia: snapshot.data.luotDanhGia,
                  maSP: snapshot.data.maSP,
                  ngayPhatHanh: snapshot.data.ngayPhatHanh,
                  ngonNgu: snapshot.data.ngonNgu,
                  nguoiDich: snapshot.data.nguoiDich,
                  nhaPhatHanh: snapshot.data.nhaPhatHanh,
                  nhaXuatBan: snapshot.data.nhaXuatBan,
                  phanTramGiamGia: snapshot.data.phanTramGiamGia,
                  soLuong: snapshot.data.soLuong +
                      value.documents[i].data['soLuongMua'],
                  soTrang: snapshot.data.soTrang,
                  tacGia: snapshot.data.tacGia,
                  tenSach: snapshot.data.tenSach,
                  trangThai: snapshot.data.trangThai,
                );
                print(
                    'Số sách sau khi hoàn lại: ${snapshot.data.soLuong} + ${value.documents[i].data['soLuongMua']}');
                CRUDBook crudBookUpdate = new CRUDBook(snapshot.data.idDM);
                crudBookUpdate.updateBook(snapshot.data.tenSach, data: book);
              });
        }
      });
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Huỷ Đơn Hàng"),
    content: Text("Bạn có muốn huỷ đơn hàng?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
